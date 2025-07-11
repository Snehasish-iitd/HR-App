package com.HR.app.DTO;

import com.HR.app.Enums.RoleEnum;

import lombok.*;

@Getter@Setter
@AllArgsConstructor
@NoArgsConstructor

public class CreateUserRequest {
    private String email;
    private String name;
    private String password; 
    private RoleEnum role; 

}

