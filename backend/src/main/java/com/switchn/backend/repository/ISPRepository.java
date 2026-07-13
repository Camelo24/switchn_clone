package com.switchn.backend.repository;

import com.switchn.backend.entity.ISP;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface ISPRepository extends JpaRepository<ISP, Long> {
    Optional<ISP> findByName(String name);
}
