package com.HR.app.DTO;

import lombok.*;

@Getter@Setter
@AllArgsConstructor
@NoArgsConstructor

public class ResetPasswordRequest {
    private String email;
    private String code; 
    private String newPassword;
    private String confirmPassword;   
}


