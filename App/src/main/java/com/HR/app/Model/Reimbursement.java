package com.HR.app.Model;

import com.HR.app.Enums.ReimbursementStatus;
import com.HR.app.Enums.ReimbursementType;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import org.hibernate.annotations.UuidGenerator;

import java.time.LocalDate;

import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor

@Entity
@Table(name = "reimbursements")
public class Reimbursement {
    
    @Id
    @UuidGenerator
    @Column(name = "id", updatable = false, nullable = false)
    private UUID id;
    
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private Users user;
    
    // Remove fileData, fileName, fileType - replace with fileId and filePath
    @Column(name = "file_id")
    private String fileId; // Storage provider's file ID
    
    @Column(name = "file_path")
    private String filePath; // Original file path/name for reference
    
    @Column(name = "file_type")
    private String fileType;
    
    @Column(name = "value")
    private Double value;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "type")
    private ReimbursementType type;

    @Column(name="expenseDate")
    private LocalDate expenseDate;
    
    @Column(name = "comments")
    private String comments;

    @Column(name="rejectionReason")
    private String rejectionReason;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private ReimbursementStatus status;
    
    @Column(name = "created_at")
    private LocalDate createdAt;
    
    @Column(name = "updated_at")
    private LocalDate updatedAt;

    @Column(name="approvedDate")
    private LocalDate approvedDate;

    @ManyToOne
    private Users approvedBy;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDate.now();
        updatedAt = LocalDate.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDate.now();
    }

   
    
}