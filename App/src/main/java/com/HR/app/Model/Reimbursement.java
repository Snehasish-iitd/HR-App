package com.HR.app.Model;

import com.HR.app.Enums.ReimbursementStatus;
import com.HR.app.Enums.ReimbursementType;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import org.hibernate.annotations.UuidGenerator;

import java.time.LocalDateTime;
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
    
    @Column(name = "comments")
    private String comments;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private ReimbursementStatus status;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
}