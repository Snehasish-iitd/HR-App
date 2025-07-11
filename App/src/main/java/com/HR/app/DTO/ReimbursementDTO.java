package com.HR.app.DTO;

import java.util.UUID;

import com.HR.app.Enums.ReimbursementStatus;
import com.HR.app.Enums.ReimbursementType;
import com.HR.app.Model.Reimbursement;

import lombok.*;
@Getter@Setter



public class ReimbursementDTO {
    private UUID id;
    private String fileName;
    private Double value;
    private ReimbursementType type;
    private String comments;
    private ReimbursementStatus status;

    public ReimbursementDTO(Reimbursement r) {
        this.id = r.getId();
        this.fileName = r.getFileName();
        this.value = r.getValue();
        this.type = r.getType();
        this.comments = r.getComments();
        this.status = r.getStatus();
    }
}
