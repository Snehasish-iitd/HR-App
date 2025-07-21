package com.HR.app.DTO;

import com.fasterxml.jackson.annotation.*;
import lombok.*;

import java.time.LocalDate;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReimbursementResponseDTO {
    @JsonProperty("id")
    private UUID id;

    @JsonProperty("amount")
    private Double value;

    @JsonProperty("expenseType")
    private String type;

    @JsonProperty("expenseDate")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate expenseDate;

    @JsonProperty("comment")
    private String comments;

    @JsonProperty("fileType")
    private String fileType;

    @JsonProperty("fileId")
    private String fileId;

    @JsonProperty("fileName")
    private String filePath;

    @JsonProperty("status")
    private String status; // lowercase: "pending", "approved", "rejected"

    @JsonProperty("rejectionReason")
    private String rejectionReason;

    @JsonProperty("employeeId")
    private String employeeId;

    @JsonProperty("employeeName")
    private String employeeName;

    @JsonProperty("managerId")
    private String managerId;


    @JsonProperty("submissionDate")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate createdAt;

    @JsonProperty("approvedDate")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate approvedDate;

    @JsonProperty("approvedBy")
    private String approvedBy;
}
