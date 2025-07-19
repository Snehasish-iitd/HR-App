package com.HR.app.DTO;


import java.time.LocalDate;

import java.util.UUID;

import com.HR.app.Enums.ReimbursementType;
import com.HR.app.Model.Users;


import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReimbursementResponseDTO {
    private UUID id;
    private Double amount;
    private ReimbursementType expenseType;
    private LocalDate expenseDate;
    private String comment;
    private String fileType;
    private String fileId;
    private String fileName;

    // Fields for user-side display/context
    private String status;            // Only populated for user "My History"
    private String rejectionReason;   // Only populated when status == "REJECTED"

    // Fields for approval context
    private String employeeId;        // Only for approval queue (who submitted)
    private String employeeName;      // Only for approval queue

    // Timestamps (optional if needed)
    private LocalDate submissionDate;
    private LocalDate approvedDate;
    private Users approvedBy;
}

