package com.switchn.backend.controller;

import com.switchn.backend.dto.ApiResponse;
import com.switchn.backend.dto.TransactionDTO;
import com.switchn.backend.dto.WalletDTO;
import com.switchn.backend.dto.WalletFundRequest;
import com.switchn.backend.service.WalletService;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/wallet")
public class WalletController {

    private final WalletService walletService;

    public WalletController(WalletService walletService) {
        this.walletService = walletService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<WalletDTO>> getWallet(Authentication authentication) {
        Long userId = Long.parseLong(authentication.getPrincipal().toString());
        WalletDTO wallet = walletService.getWallet(userId);
        return ResponseEntity.ok(ApiResponse.<WalletDTO>builder()
                .success(true)
                .message("Wallet retrieved successfully")
                .data(wallet)
                .build());
    }

    @PostMapping("/fund")
    public ResponseEntity<ApiResponse<WalletDTO>> fundWallet(
            Authentication authentication,
            @RequestBody WalletFundRequest request) {
        Long userId = Long.parseLong(authentication.getPrincipal().toString());
        WalletDTO wallet = walletService.fundWallet(userId, request.getAmount());
        return ResponseEntity.ok(ApiResponse.<WalletDTO>builder()
                .success(true)
                .message("Wallet funded successfully")
                .data(wallet)
                .build());
    }

    @GetMapping("/history")
    public ResponseEntity<ApiResponse<Page<TransactionDTO>>> getWalletHistory(
            Authentication authentication,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Long userId = Long.parseLong(authentication.getPrincipal().toString());
        Page<TransactionDTO> history = walletService.getWalletHistory(userId, page, size);
        return ResponseEntity.ok(ApiResponse.<Page<TransactionDTO>>builder()
                .success(true)
                .message("Wallet history retrieved successfully")
                .data(history)
                .build());
    }
}
