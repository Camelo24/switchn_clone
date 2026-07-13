package com.switchn.backend.controller;

import com.switchn.backend.dto.*;
import com.switchn.backend.service.PurchaseService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/purchases")
public class PurchaseController {

    private final PurchaseService purchaseService;

    public PurchaseController(PurchaseService purchaseService) {
        this.purchaseService = purchaseService;
    }

    @PostMapping("/airtime")
    public ResponseEntity<ApiResponse<TransactionDTO>> buyAirtime(
            Authentication authentication,
            @RequestBody AirtimeRequest request) {
        Long userId = Long.parseLong(authentication.getPrincipal().toString());
        TransactionDTO transaction = purchaseService.buyAirtime(userId, request.getNetwork(), 
                request.getPhoneNumber(), request.getAmount());
        return ResponseEntity.ok(ApiResponse.<TransactionDTO>builder()
                .success(true)
                .message("Airtime purchased successfully")
                .data(transaction)
                .build());
    }

    @PostMapping("/bundle")
    public ResponseEntity<ApiResponse<TransactionDTO>> buyBundle(
            Authentication authentication,
            @RequestBody BundlePurchaseRequest request) {
        Long userId = Long.parseLong(authentication.getPrincipal().toString());
        TransactionDTO transaction = purchaseService.buyBundle(userId, request.getBundleId(), 
                request.getBeneficiaryPhone());
        return ResponseEntity.ok(ApiResponse.<TransactionDTO>builder()
                .success(true)
                .message("Bundle purchased successfully")
                .data(transaction)
                .build());
    }
}
