package com.HR.app.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.HR.app.Enums.ReimbursementStatus;
import com.HR.app.Model.Reimbursement;

import java.util.List;
import java.util.UUID;

@Repository
public interface ReimbursementRepository extends JpaRepository<Reimbursement, UUID> {
    List<Reimbursement> findByUserEmail(String email);
    List<Reimbursement> findByStatus(ReimbursementStatus status);
}

