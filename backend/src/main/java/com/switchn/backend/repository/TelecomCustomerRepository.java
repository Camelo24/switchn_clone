package com.switchn.backend.repository;

import com.switchn.backend.entity.TelecomCustomer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface TelecomCustomerRepository extends JpaRepository<TelecomCustomer, Long> {
    Optional<TelecomCustomer> findByPhoneNumber(String phoneNumber);
}
