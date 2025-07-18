package com.HR.app.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.HR.app.DTO.ReimbursementDTO;
import com.HR.app.Enums.ReimbursementType;
import com.HR.app.Model.Reimbursement;
import com.HR.app.Service.ReimbursementService;

import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

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
            @RequestParam(value = "comments", required = false) String comments
    ) throws IOException {
        String userEmail = authentication.getName();
        Reimbursement reimbursement = reimbursementService.fileReimbursement(userEmail, file, value, type, comments);
        return ResponseEntity.ok(new ReimbursementDTO(reimbursement));
    }

    // 2. Get my reimbursement history
    @GetMapping("/history")
    public ResponseEntity<List<Reimbursement>> getMyHistory(Authentication authentication) {
        String userEmail = authentication.getName();
        List<Reimbursement> history = reimbursementService.getMyHistory(userEmail);
        return ResponseEntity.ok(history);
    }

    // 3. Get all pending approvals (admin, HR, manager)
    @GetMapping("/pending")
    @PreAuthorize("hasAnyRole('ADMIN', 'HR', 'MANAGER')")
    public ResponseEntity<List<Reimbursement>> getPendingApprovals() {
        List<Reimbursement> pending = reimbursementService.getPendingApprovals();
        return ResponseEntity.ok(pending);
    }

    // 4. Get details of a reimbursement by id (admin, HR, manager)
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'HR', 'MANAGER')")
    public ResponseEntity<?> getReimbursementById(@PathVariable UUID id) {
        Optional<Reimbursement> result = reimbursementService.getReimbursementById(id);
        return result.map(ResponseEntity::ok)
                     .orElseGet(() -> ResponseEntity.notFound().build());
    }

    // 5. Download reimbursement file (User or authorized roles)
    @GetMapping("/{id}/file")
    @PreAuthorize("isAuthenticated()") // adjust this as per your policy
    public ResponseEntity<byte[]> downloadReimbursementFile(@PathVariable UUID id) throws IOException {
        byte[] fileData = reimbursementService.getReimbursementFile(id);
        // Add headers if you want (Content-Type, Content-Disposition)
        return ResponseEntity.ok(fileData);
    }

    // 6. Delete reimbursement file (User or authorized roles)
    @DeleteMapping("/{id}/file")
    @PreAuthorize("isAuthenticated()") // adjust & tighten as needed
    public ResponseEntity<?> deleteReimbursementFile(@PathVariable UUID id) throws IOException {
        reimbursementService.deleteReimbursementFile(id);
        return ResponseEntity.ok("File deleted successfully.");
    }

    // 7. Approve a reimbursement (admin, HR, manager)
    @PostMapping("/{id}/approve")
    @PreAuthorize("hasAnyRole('ADMIN', 'HR', 'MANAGER')")
    public ResponseEntity<?> approveReimbursement(@PathVariable UUID id) {
        reimbursementService.approveReimbursement(id);
        return ResponseEntity.ok("Reimbursement approved.");
    }

    // 8. Deny a reimbursement (admin, HR, manager)
    @PostMapping("/{id}/deny")
    @PreAuthorize("hasAnyRole('ADMIN', 'HR', 'MANAGER')")
    public ResponseEntity<?> denyReimbursement(@PathVariable UUID id) {
        reimbursementService.denyReimbursement(id);
        return ResponseEntity.ok("Reimbursement denied.");
    }
}
