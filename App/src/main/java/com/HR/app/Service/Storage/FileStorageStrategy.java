package com.HR.app.Service.Storage;

import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.time.LocalDateTime;

public interface FileStorageStrategy {
    String uploadFile(MultipartFile file, String employeeName, String reimbursementType, LocalDateTime timestamp) throws IOException;
    byte[] downloadFile(String fileId) throws IOException;
    void deleteFile(String fileId) throws IOException;
    boolean fileExists(String fileId) throws IOException;
}
