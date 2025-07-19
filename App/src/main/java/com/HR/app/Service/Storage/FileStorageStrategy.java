package com.HR.app.Service.Storage;

import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.time.LocalDate;


public interface FileStorageStrategy {
    String uploadFile(MultipartFile file, String employeeName, String reimbursementType, LocalDate expenseDate) throws IOException;
    byte[] downloadFile(String fileId) throws IOException;
    void deleteFile(String fileId) throws IOException;
    boolean fileExists(String fileId) throws IOException;
}
