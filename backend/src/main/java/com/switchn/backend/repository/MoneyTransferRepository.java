package com.switchn.backend.repository;

import com.switchn.backend.entity.MoneyTransfer;
import com.switchn.backend.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MoneyTransferRepository extends JpaRepository<MoneyTransfer, Long> {
    Page<MoneyTransfer> findBySenderUserOrderByCreatedAtDesc(User user, Pageable pageable);
}
