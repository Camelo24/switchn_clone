package com.switchn.backend.repository;

import com.switchn.backend.entity.Transaction;
import com.switchn.backend.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    Page<Transaction> findByUserOrderByCreatedAtDesc(User user, Pageable pageable);
}
