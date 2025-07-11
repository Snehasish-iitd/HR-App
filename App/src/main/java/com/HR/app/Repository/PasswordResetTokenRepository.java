package com.HR.app.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.HR.app.Model.PasswordResetToken;

import java.util.Optional;



public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, Long> {
    Optional<PasswordResetToken> findByUserEmailAndCode(String email, String code);
}

