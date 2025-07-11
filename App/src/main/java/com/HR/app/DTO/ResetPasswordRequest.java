package com.HR.app.DTO;

import lombok.*;

@Getter@Setter
@AllArgsConstructor
@NoArgsConstructor

public class ResetPasswordRequest {
    private String token;
    private String newPassword;
    
}

