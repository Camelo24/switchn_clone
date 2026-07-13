package com.switchn.backend.repository;

import com.switchn.backend.entity.Purchase;
import com.switchn.backend.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PurchaseRepository extends JpaRepository<Purchase, Long> {
    Page<Purchase> findByUserOrderByCreatedAtDesc(User user, Pageable pageable);
}
