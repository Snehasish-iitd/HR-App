package com.HR.app.DTO;

import lombok.*;

@Getter @Setter
@AllArgsConstructor
@NoArgsConstructor

public class LoginRequest {
    private String email;
    private String password;
    
}

