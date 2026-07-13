package com.switchn.backend.service;

import com.switchn.backend.dto.BundleDTO;
import com.switchn.backend.entity.Bundle;
import com.switchn.backend.entity.ISP;
import com.switchn.backend.repository.BundleRepository;
import com.switchn.backend.repository.ISPRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class ISPService {

    private final ISPRepository ispRepository;
    private final BundleRepository bundleRepository;

    public ISPService(ISPRepository ispRepository, BundleRepository bundleRepository) {
        this.ispRepository = ispRepository;
        this.bundleRepository = bundleRepository;
    }

    public List<ISP> getAllISPs() {
        return ispRepository.findAll();
    }

    public ISP getISPById(Long id) {
        return ispRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("ISP not found"));
    }

    public List<BundleDTO> getBundlesByISP(Long ispId) {
        ISP isp = getISPById(ispId);
        List<Bundle> bundles = bundleRepository.findByIspAndIsActiveTrue(isp);
        return bundles.stream()
                .map(this::mapToBundleDTO)
                .collect(Collectors.toList());
    }

    private BundleDTO mapToBundleDTO(Bundle bundle) {
        return BundleDTO.builder()
                .id(bundle.getId())
                .ispName(bundle.getIsp().getName())
                .name(bundle.getName())
                .type(bundle.getType())
                .volume(bundle.getVolume())
                .price(bundle.getPrice())
                .validityDays(bundle.getValidityDays())
                .build();
    }
}
