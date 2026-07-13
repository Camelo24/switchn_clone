package com.switchn.backend.repository;

import com.switchn.backend.entity.Bundle;
import com.switchn.backend.entity.ISP;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface BundleRepository extends JpaRepository<Bundle, Long> {
    List<Bundle> findByIspAndIsActiveTrue(ISP isp);
}
