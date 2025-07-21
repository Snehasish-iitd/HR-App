package com.HR.app.Service;

import com.HR.app.Enums.ReimbursementStatus;
import com.HR.app.Enums.ReimbursementType;
import com.HR.app.Model.Reimbursement;
import com.HR.app.Model.Users;
import com.HR.app.Repository.ReimbursementRepository;
import com.HR.app.Repository.UserRepository;
import com.HR.app.Service.Storage.FileStorageFactory;
import com.HR.app.Service.Storage.FileStorageStrategy;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ReimbursementService {
    private final ReimbursementRepository reimbursementRepository;
    private final UserRepository userRepository;
    private final FileStorageFactory storageFactory;

    @Transactional
    public Reimbursement fileReimbursement(String userEmail, MultipartFile file, Double value,
                                          ReimbursementType type, LocalDate expenseDate, String comments) throws IOException {
        Users user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        FileStorageStrategy storageStrategy = storageFactory.getStorageStrategy();
        String fileId = storageStrategy.uploadFile(file, user.getName(), type.name(), expenseDate);

        Reimbursement reimbursement = Reimbursement.builder()
                .user(user)
                .fileId(fileId)
                .filePath(file.getOriginalFilename())
                .fileType(file.getContentType())
                .value(value)
                .type(type)
                .expenseDate(expenseDate)
                .comments(comments)
                .status(ReimbursementStatus.PENDING)
                .build();

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

   // Approve
@Transactional
public void approveReimbursement(UUID id, Users approver) {
    Reimbursement reimbursement = reimbursementRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Reimbursement not found"));
    reimbursement.setStatus(ReimbursementStatus.APPROVED);
    reimbursement.setApprovedBy(approver);
    reimbursement.setApprovedDate(LocalDate.now());
    reimbursementRepository.save(reimbursement);
}

// Deny (UPDATED to accept denier)
@Transactional
public void denyReimbursement(UUID id, String reason, Users deniedBy) {
    Reimbursement reimbursement = reimbursementRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Reimbursement not found"));
    reimbursement.setStatus(ReimbursementStatus.DENIED);
    reimbursement.setRejectionReason(reason);
    reimbursement.setApprovedBy(deniedBy); // (optional: if you want to track who denied)
    reimbursement.setApprovedDate(LocalDate.now()); // (optional: track when denied)
    reimbursementRepository.save(reimbursement);
}
}
