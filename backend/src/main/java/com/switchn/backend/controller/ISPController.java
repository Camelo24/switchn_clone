package com.switchn.backend.controller;

import com.switchn.backend.dto.ApiResponse;
import com.switchn.backend.dto.BundleDTO;
import com.switchn.backend.entity.ISP;
import com.switchn.backend.service.ISPService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/isps")
public class ISPController {

    private final ISPService ispService;

    public ISPController(ISPService ispService) {
        this.ispService = ispService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<ISP>>> getAllISPs() {
        List<ISP> isps = ispService.getAllISPs();
        return ResponseEntity.ok(ApiResponse.<List<ISP>>builder()
                .success(true)
                .message("ISPs retrieved successfully")
                .data(isps)
                .build());
    }

    @GetMapping("/{id}/bundles")
    public ResponseEntity<ApiResponse<List<BundleDTO>>> getBundles(@PathVariable Long id) {
        List<BundleDTO> bundles = ispService.getBundlesByISP(id);
        return ResponseEntity.ok(ApiResponse.<List<BundleDTO>>builder()
                .success(true)
                .message("Bundles retrieved successfully")
                .data(bundles)
                .build());
    }
}
