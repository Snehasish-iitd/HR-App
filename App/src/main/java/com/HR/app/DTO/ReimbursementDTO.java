package com.HR.app.DTO;

import java.util.UUID;

import com.HR.app.Enums.ReimbursementStatus;
import com.HR.app.Enums.ReimbursementType;
import com.HR.app.Model.Reimbursement;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReimbursementDTO {
    private UUID id;
    private String fileId;      // Storage provider's file ID (e.g., Google Drive file ID)
    private String fileName;    // The original file name
    private String fileType;    // MIME type (optional but useful)
    private Double value;
    private ReimbursementType type;
    private String comments;
    private ReimbursementStatus status;

    public ReimbursementDTO(Reimbursement r) {
        this.id = r.getId();
        this.fileId = r.getFileId();             // <-- new
        this.fileName = r.getFilePath();         // filePath is the original filename in your new model
        this.fileType = r.getFileType();
        this.value = r.getValue();
        this.type = r.getType();
        this.comments = r.getComments();
        this.status = r.getStatus();
    }
}
