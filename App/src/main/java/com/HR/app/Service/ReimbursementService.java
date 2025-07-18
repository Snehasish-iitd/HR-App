package com.HR.app.Service;

import com.HR.app.Enums.ReimbursementStatus;
import com.HR.app.Enums.ReimbursementType;
import com.HR.app.Model.Reimbursement;
import com.HR.app.Model.Users;
import com.HR.app.Repository.ReimbursementRepository;
import com.HR.app.Repository.UserRepository;
import com.HR.app.Service.Storage.FileStorageFactory;
import com.HR.app.Service.Storage.FileStorageStrategy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class ReimbursementService {

    @Autowired
    private ReimbursementRepository reimbursementRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FileStorageFactory storageFactory;

    @Transactional
    public Reimbursement fileReimbursement(String userEmail, MultipartFile file, Double value,
                                           ReimbursementType type, String comments) throws IOException {
        Users user = userRepository.findByEmail(userEmail)
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        FileStorageStrategy storageStrategy = storageFactory.getStorageStrategy();

        // No userId argument needed!
        String fileId = storageStrategy.uploadFile(
                file, user.getName(), type.name(), LocalDateTime.now()
        );

        Reimbursement reimbursement = new Reimbursement();
        reimbursement.setUser(user);
        reimbursement.setFileId(fileId);
        reimbursement.setFilePath(file.getOriginalFilename());
        reimbursement.setFileType(file.getContentType());
        reimbursement.setValue(value);
        reimbursement.setType(type);
        reimbursement.setComments(comments);
        reimbursement.setStatus(ReimbursementStatus.PENDING);

        return reimbursementRepository.save(reimbursement);
    }

    @Transactional(readOnly = true)
    public byte[] getReimbursementFile(UUID reimbursementId) throws IOException {
        Reimbursement reimbursement = reimbursementRepository.findById(reimbursementId)
            .orElseThrow(() -> new IllegalArgumentException("Reimbursement not found"));

        FileStorageStrategy storageStrategy = storageFactory.getStorageStrategy();
        return storageStrategy.downloadFile(reimbursement.getFileId());
    }

    @Transactional
    public void deleteReimbursementFile(UUID reimbursementId) throws IOException {
        Reimbursement reimbursement = reimbursementRepository.findById(reimbursementId)
            .orElseThrow(() -> new IllegalArgumentException("Reimbursement not found"));

        FileStorageStrategy storageStrategy = storageFactory.getStorageStrategy();
        storageStrategy.deleteFile(reimbursement.getFileId());
    }

    @Transactional(readOnly = true)
    public List<Reimbursement> getMyHistory(String userEmail) {
        return reimbursementRepository.findByUserEmail(userEmail);
    }

    @Transactional(readOnly = true)
    public List<Reimbursement> getPendingApprovals() {
        return reimbursementRepository.findByStatus(ReimbursementStatus.PENDING);
    }

    @Transactional(readOnly = true)
    public Optional<Reimbursement> getReimbursementById(UUID id) {
        return reimbursementRepository.findById(id);
    }

    @Transactional
    public void approveReimbursement(UUID id) {
        Reimbursement reimbursement = reimbursementRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Reimbursement not found"));
        reimbursement.setStatus(ReimbursementStatus.APPROVED);
        reimbursementRepository.save(reimbursement);
    }

    @Transactional
    public void denyReimbursement(UUID id) {
        Reimbursement reimbursement = reimbursementRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Reimbursement not found"));
        reimbursement.setStatus(ReimbursementStatus.DENIED);
        reimbursementRepository.save(reimbursement);
    }
}
