package com.HR.app.Service.Storage;

import com.HR.app.Service.GoogleOAuthFlowService;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.FileContent;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.FileList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.GeneralSecurityException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;

@Slf4j
@Service
public class GoogleOAuthDriveStorageStrategy implements FileStorageStrategy {

    private static final String APPLICATION_NAME = "HR Reimbursement App";
    private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
    private static final String COMPANY_USER_ID = "snehasishbala52@gmail.com";

    private final GoogleOAuthFlowService googleOAuthFlowService;

    @Autowired
    public GoogleOAuthDriveStorageStrategy(GoogleOAuthFlowService googleOAuthFlowService) {
        this.googleOAuthFlowService = googleOAuthFlowService;
    }

    private Drive getDriveService() throws IOException {
        try {
            Credential credential = googleOAuthFlowService.loadCredential(COMPANY_USER_ID);
            if (credential == null) {
                throw new RuntimeException("Company Google Drive not connected! Visit /company-drive/authorize to connect.");
            }
            return new Drive.Builder(GoogleNetHttpTransport.newTrustedTransport(), JSON_FACTORY, credential)
                    .setApplicationName(APPLICATION_NAME)
                    .build();
        } catch (GeneralSecurityException | IOException e) {
            throw new IOException("Could not create Google Drive service: " + e.getMessage(), e);
        } catch (Exception e) {
            throw new IOException("Failed to load Google OAuth credential: " + e.getMessage(), e);
        }
    }

    @Override
    public String uploadFile(MultipartFile file, String employeeName, String reimbursementType, LocalDate expenseDate)
            throws IOException {
        log.info("Starting upload for: {} (type: {}, user: {}, date: {})",
                file.getOriginalFilename(), reimbursementType, employeeName, expenseDate);

        Drive driveService = getDriveService();
        log.info("Google Drive service initialized successfully");

        String rootFolderId = createOrGetFolder(driveService, "reimbursements", null);
        log.debug("Root folder ID: {}", rootFolderId);

        String financialYearFolderName = getFinancialYearFolderName(expenseDate);
        String financialYearFolderId = createOrGetFolder(driveService, financialYearFolderName, rootFolderId);
        log.debug("Financial year folder '{}' ID: {}", financialYearFolderName, financialYearFolderId);

        String monthFolderName = getMonthFolderName(expenseDate);
        String monthFolderId = createOrGetFolder(driveService, monthFolderName, financialYearFolderId);
        log.debug("Month folder '{}' ID: {}", monthFolderName, monthFolderId);

        String fileName = generateFileName(employeeName, reimbursementType, expenseDate);
        log.info("Preparing to upload as: {}", fileName);

        java.io.File tempFile = convertMultipartFileToFile(file);
        log.debug("Temporary file created at: {}", tempFile.getAbsolutePath());

        try {
            File fileMetadata = new File();
            fileMetadata.setName(fileName);
            fileMetadata.setParents(Collections.singletonList(monthFolderId));

            FileContent mediaContent = new FileContent(file.getContentType(), tempFile);
            File uploadedFile = driveService.files().create(fileMetadata, mediaContent)
                    .setFields("id")
                    .execute();
            log.info("Successfully uploaded to Google Drive, file ID: {}", uploadedFile.getId());
            return uploadedFile.getId();
        } catch (Exception e) {
            log.error("Failed to upload file to Google Drive: {}", e.getMessage(), e);
            throw new IOException("Failed to upload file to Google Drive: " + e.getMessage(), e);
        } finally {
            boolean deleted = tempFile.delete();
            if (!deleted) {
                log.warn("Could not delete temporary file: {}", tempFile.getAbsolutePath());
            }
        }
    }

    @Override
    public byte[] downloadFile(String fileId) throws IOException {
        log.info("Downloading file with ID: {}", fileId);
        Drive driveService = getDriveService();
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        driveService.files().get(fileId).executeMediaAndDownloadTo(outputStream);
        return outputStream.toByteArray();
    }

    @Override
    public void deleteFile(String fileId) throws IOException {
        log.info("Deleting file with ID: {}", fileId);
        Drive driveService = getDriveService();
        driveService.files().delete(fileId).execute();
    }

    @Override
    public boolean fileExists(String fileId) throws IOException {
        log.debug("Checking existence of file with ID: {}", fileId);
        Drive driveService = getDriveService();
        try {
            driveService.files().get(fileId).execute();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private String createOrGetFolder(Drive driveService, String folderName, String parentId) throws IOException {
        String query = "name='" + folderName + "' and mimeType='application/vnd.google-apps.folder'";
        if (parentId != null) {
            query += " and '" + parentId + "' in parents";
        }
        FileList result = driveService.files().list().setQ(query).setSpaces("drive").execute();

        if (!result.getFiles().isEmpty()) {
            return result.getFiles().get(0).getId();
        }

        File fileMetadata = new File();
        fileMetadata.setName(folderName);
        fileMetadata.setMimeType("application/vnd.google-apps.folder");
        if (parentId != null) {
            fileMetadata.setParents(Collections.singletonList(parentId));
        }
        File folder = driveService.files().create(fileMetadata).setFields("id").execute();
        return folder.getId();
    }

    private String getFinancialYearFolderName(LocalDate expenseDate) {
        int year = expenseDate.getYear();
        int month = expenseDate.getMonthValue();
        if (month >= 4) {
            return "fin_year_" + year + "_" + (year + 1);
        } else {
            return "fin_year_" + (year - 1) + "_" + year;
        }
    }

    private String getMonthFolderName(LocalDate expenseDate) {
        String monthNumber = String.format("%02d", expenseDate.getMonthValue());
        String monthName = expenseDate.getMonth().name().toLowerCase();
        String capitalizedMonth = monthName.substring(0, 1).toUpperCase() + monthName.substring(1);
        return monthNumber + "_" + capitalizedMonth;
    }

    private String generateFileName(String employeeName, String reimbursementType, LocalDate expenseDate) {
        String date = expenseDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        String sanitizedEmployeeName = employeeName.replaceAll("[^a-zA-Z0-9._-]", "_");
        String sanitizedReimbursementType = reimbursementType.replaceAll("[^a-zA-Z0-9._-]", "_");
        return sanitizedEmployeeName + "-" + sanitizedReimbursementType + "-" + date;
    }

    private java.io.File convertMultipartFileToFile(MultipartFile file) throws IOException {
        java.io.File tempFile = java.io.File.createTempFile("temp", null);
        try (FileOutputStream fos = new FileOutputStream(tempFile)) {
            fos.write(file.getBytes());
        }
        return tempFile;
    }
}
