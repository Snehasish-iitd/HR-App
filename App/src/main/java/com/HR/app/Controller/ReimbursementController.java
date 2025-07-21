package com.HR.app.Controller;


import com.HR.app.DTO.ReimbursementResponseDTO;
import com.HR.app.Enums.ReimbursementStatus;
import com.HR.app.Enums.ReimbursementType;
import com.HR.app.Model.Reimbursement;
import com.HR.app.Model.Users;
import com.HR.app.Repository.UserRepository;
import com.HR.app.Service.ReimbursementService;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@AllArgsConstructor
@RequestMapping("/api/reimbursements")
public class ReimbursementController {

    private final ReimbursementService reimbursementService;
    private final UserRepository userRepository;

    // 1. File a reimbursement
    @PostMapping("/submit")
    public ResponseEntity<ReimbursementResponseDTO> fileReimbursement(
            Authentication authentication,
            @RequestParam("file") MultipartFile file,
            @RequestParam("value") Double value,
            @RequestParam("type") ReimbursementType type,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate expenseDate,
            @RequestParam(value = "comments", required = false) String comments
    ) throws IOException {
        String userEmail = authentication.getName();
        
        Reimbursement reimbursement = reimbursementService.fileReimbursement(
                userEmail, file, value, type, expenseDate, comments
        );
        return ResponseEntity.ok(mapToDTO(reimbursement));
    }

    // 2. Get my reimbursement history (user)
    @GetMapping("/history")
    public ResponseEntity<List<ReimbursementResponseDTO>> getMyHistory(Authentication authentication) {
        String userEmail = authentication.getName();
        List<Reimbursement> history = reimbursementService.getMyHistory(userEmail);
        List<ReimbursementResponseDTO> dtos = history.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    // 3. Get all pending approvals (for manager/HR/admin)
    @GetMapping("/pending")
    @PreAuthorize("hasAnyRole('ADMIN', 'HR', 'MANAGER')")
    public ResponseEntity<List<ReimbursementResponseDTO>> getPendingApprovals() {
        List<Reimbursement> pending = reimbursementService.getPendingApprovals();
        List<ReimbursementResponseDTO> dtos = pending.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    // 4. Get details of a reimbursement by id (for manager/HR/admin)
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'HR', 'MANAGER')")
    public ResponseEntity<ReimbursementResponseDTO> getReimbursementById(@PathVariable UUID id) {
        Reimbursement reimbursement = reimbursementService.getReimbursementById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Not found"));
        return ResponseEntity.ok(mapToDTO(reimbursement));
    }

    // 5. Download reimbursement file (inline mode support)
    @GetMapping("/{id}/file")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<byte[]> downloadReimbursementFile(@PathVariable UUID id) throws IOException {
        Reimbursement reimbursement = reimbursementService.getReimbursementById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Reimbursement not found"));
        byte[] fileData = reimbursementService.getReimbursementFile(id);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType(reimbursement.getFileType()));
        headers.set(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + reimbursement.getFilePath() + "\"");
        return ResponseEntity.ok().headers(headers).body(fileData);
    }

    // 6. Delete reimbursement file
    @DeleteMapping("/{id}/file")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> deleteReimbursementFile(@PathVariable UUID id) throws IOException {
        reimbursementService.deleteReimbursementFile(id);
        return ResponseEntity.ok().build();
    }

    // 7. Approve reimbursement
    @PostMapping("/{id}/approve")
    @PreAuthorize("hasAnyRole('ADMIN', 'HR', 'MANAGER')")
    public ResponseEntity<Void> approveReimbursement(@PathVariable UUID id, Authentication authentication) {
        // Get the authenticated user's email (or username, depending on your app)
        String email = authentication.getName();
        // Fetch the real user entity from the database
        Users approvedBy = userRepository.findByEmail(email)
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        // Optional: log the approver's role for debugging
        // log.info("Approver: {}, role: {}", approvedBy.getEmail(), approvedBy.getRole());

        reimbursementService.approveReimbursement(id, approvedBy);
        return ResponseEntity.ok().build();
    }

    // 8. Deny reimbursement
    @PostMapping("/{id}/deny")
    @PreAuthorize("hasAnyRole('ADMIN', 'HR', 'MANAGER')")
    public ResponseEntity<Void> denyReimbursement(@PathVariable UUID id, @RequestBody DenyRequest request, Authentication authentication) {
        String email = authentication.getName();
        Users deniedBy = userRepository.findByEmail(email)
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        // Optional: You can record who denied the request by updating your service/model
        reimbursementService.denyReimbursement(id, request.reason, deniedBy);
        return ResponseEntity.ok().build();
    }


    // Maps a Reimbursement entity to the frontend-ready DTO
    private ReimbursementResponseDTO mapToDTO(Reimbursement reimbursement) {
        return ReimbursementResponseDTO.builder()
                .id(reimbursement.getId())
                .value(reimbursement.getValue())
                .type(reimbursement.getType().name())
                .expenseDate(reimbursement.getExpenseDate())
                .comments(reimbursement.getComments())
                .fileType(reimbursement.getFileType())
                .fileId(reimbursement.getFileId())
                .filePath(reimbursement.getFilePath())
                .status(reimbursement.getStatus().toString().toLowerCase())
                .rejectionReason(reimbursement.getStatus() == ReimbursementStatus.DENIED ? reimbursement.getRejectionReason() : null)
                .employeeId(reimbursement.getUser().getEid())
                .employeeName(reimbursement.getUser().getName())
                .managerId(reimbursement.getUser().getManagerId()) 
                .createdAt(reimbursement.getCreatedAt())
                .approvedDate(reimbursement.getApprovedDate())
                .approvedBy(reimbursement.getApprovedBy() != null ? reimbursement.getApprovedBy().getName() : null)
                .build();
    }

    // Denial request DTO
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DenyRequest {
        private String reason;
    }
}
