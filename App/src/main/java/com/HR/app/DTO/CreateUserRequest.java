package com.HR.app.DTO;

import com.HR.app.Enums.RoleEnum;

import lombok.*;

@Getter@Setter
@AllArgsConstructor
@NoArgsConstructor

public class CreateUserRequest {
    private String email;
    private String password; 
    private RoleEnum role; 

}

