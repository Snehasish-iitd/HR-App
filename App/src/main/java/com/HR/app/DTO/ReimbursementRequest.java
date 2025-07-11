package com.HR.app.DTO;

import lombok.*;

@Getter@Setter
@AllArgsConstructor
@NoArgsConstructor

public class ReimbursementRequest {
    private Double value;
    private String type; 
    private String comments; 
}

