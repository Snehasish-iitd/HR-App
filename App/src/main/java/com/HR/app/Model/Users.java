package com.HR.app.Model;

import java.util.List;
import java.util.UUID;

import com.HR.app.Enums.RoleEnum;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.persistence.*;
import lombok.*;

@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
@Entity
@Table(name = "users")
public class Users {

    @Id
    @org.hibernate.annotations.UuidGenerator
    @Column(name = "id", updatable = false, nullable = false)
    private UUID id;

    @JsonProperty("eid")
    @Column(name = "employeeid", updatable = false, nullable = false)
    private String EID;

    @Column(name = "email", nullable = false)
    private String email;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "department")
    private String department;

    @Column(name = "manager_id")
    private String managerId;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false)
    private RoleEnum role;

    // *** Add this new field for bi-directional relation and cascade ***
   @OneToOne(mappedBy = "user", cascade = CascadeType.REMOVE, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnore
    private PasswordResetToken passwordResetToken;

}
