package com.HR.app.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

import com.HR.app.DTO.ReimbursementResponseDTO;
import com.HR.app.Enums.ReimbursementStatus;
import com.HR.app.Enums.ReimbursementType;
import com.HR.app.Model.Reimbursement;
import com.HR.app.Model.Users;
import com.HR.app.Service.ReimbursementService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;


import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/reimbursements")
public class ReimbursementController {

    @Autowired
    private ReimbursementService reimbursementService;

    // 1. File a reimbursement
    @PostMapping("/submit")
    public ResponseEntity<?> fileReimbursement(
            Authentication authentication,
            @RequestParam("file") MultipartFile file,
            @RequestParam("value") Double value,
            @RequestParam("type") ReimbursementType type,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate expenseDate,
            @RequestParam(value = "comments", required = false) String comments
    ) throws IOException {
        String userEmail = authentication.getName();
        Reimbursement reimbursement = reimbursementService.fileReimbursement(userEmail, file, value, type, expenseDate, comments);
        return ResponseEntity.ok(mapToHistoryDTO(reimbursement));
    }

    // 2. Get my reimbursement history (user)
    @GetMapping("/history")
    public ResponseEntity<List<ReimbursementResponseDTO>> getMyHistory(Authentication authentication) {
        String userEmail = authentication.getName();
        List<Reimbursement> history = reimbursementService.getMyHistory(userEmail);
        List<ReimbursementResponseDTO> dtos = history.stream()
                .map(this::mapToHistoryDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    // 3. Get all pending approvals (for manager/HR/admin)
    @GetMapping("/pending")
    @PreAuthorize("hasAnyRole('ADMIN', 'HR', 'MANAGER')")
    public ResponseEntity<List<ReimbursementResponseDTO>> getPendingApprovals() {
        List<Reimbursement> pending = reimbursementService.getPendingApprovals();
        List<ReimbursementResponseDTO> dtos = pending.stream()
                .map(this::mapToApprovalQueueDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    // 4. Get details of a reimbursement by id (for manager/HR/admin)
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'HR', 'MANAGER')")
    public ResponseEntity<ReimbursementResponseDTO> getReimbursementById(@PathVariable UUID id) {
        Reimbursement reimbursement = reimbursementService.getReimbursementById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Not found"));
        return ResponseEntity.ok(mapToHistoryDTO(reimbursement));
    }

    // 5. Download reimbursement file (inline mode support)
    @GetMapping("/{id}/file")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> downloadReimbursementFile(@PathVariable UUID id) throws IOException {
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
    public ResponseEntity<?> deleteReimbursementFile(@PathVariable UUID id) throws IOException {
        reimbursementService.deleteReimbursementFile(id);
        return ResponseEntity.ok().build();
    }

    // 7. Approve reimbursement
    @PostMapping("/{id}/approve")
    @PreAuthorize("hasAnyRole('ADMIN', 'HR', 'MANAGER')")
    public ResponseEntity<?> approveReimbursement(@PathVariable UUID id, @PathVariable Users user) {
        reimbursementService.approveReimbursement(id, user);
        return ResponseEntity.ok().build();
    }

    // 8. Deny reimbursement
    @PostMapping("/{id}/deny")
    @PreAuthorize("hasAnyRole('ADMIN', 'HR', 'MANAGER')")
    public ResponseEntity<?> denyReimbursement(@PathVariable UUID id, @RequestBody Map<String, String> body) {
        String reason = body.get("reason");
        reimbursementService.denyReimbursement(id, reason);
        return ResponseEntity.ok().build();
    }

    // Reimbursement → DTO for "My History"
    private ReimbursementResponseDTO mapToHistoryDTO(Reimbursement reimbursement) {
        return new ReimbursementResponseDTO(
            reimbursement.getId(),
            reimbursement.getValue(),
            reimbursement.getType(),
            reimbursement.getExpenseDate(),
            reimbursement.getComments(),
            reimbursement.getFileType(),
            reimbursement.getFileId(),
            reimbursement.getFilePath(),
            reimbursement.getStatus().toString(), // STATUS INCLUDED
            reimbursement.getStatus() == ReimbursementStatus.DENIED ? reimbursement.getRejectionReason() : null,
            null, // employeeId omitted
            null, // employeeName omitted
            reimbursement.getCreatedAt(),
            reimbursement.getApprovedDate(),
            reimbursement.getApprovedBy()
        );
    }

    // Reimbursement → DTO for "Approval Queue"
    private ReimbursementResponseDTO mapToApprovalQueueDTO(Reimbursement reimbursement) {
        return new ReimbursementResponseDTO(
            reimbursement.getId(),
            reimbursement.getValue(),
            reimbursement.getType(),
            reimbursement.getExpenseDate(),
            reimbursement.getComments(),
            reimbursement.getFileType(),
            reimbursement.getFileId(),
            reimbursement.getFilePath(),
            null, // STATUS OMITTED
            null, // rejectionReason omitted
            reimbursement.getUser() != null ? reimbursement.getUser().getEID() : null,
            reimbursement.getUser() != null ? reimbursement.getUser().getName() : null,
            reimbursement.getCreatedAt(),
            null, // approvedDate omitted
            null  // approvedBy omitted
        );
    }
}
