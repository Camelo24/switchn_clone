package com.switchn.backend.controller;

import com.switchn.backend.dto.ApiResponse;
import com.switchn.backend.dto.TransactionDTO;
import com.switchn.backend.service.TransactionService;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/transactions")
public class TransactionController {

    private final TransactionService transactionService;

    public TransactionController(TransactionService transactionService) {
        this.transactionService = transactionService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<Page<TransactionDTO>>> getTransactions(
            Authentication authentication,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Long userId = Long.parseLong(authentication.getPrincipal().toString());
        Page<TransactionDTO> transactions = transactionService.getTransactions(userId, page, size);
        return ResponseEntity.ok(ApiResponse.<Page<TransactionDTO>>builder()
                .success(true)
                .message("Transactions retrieved successfully")
                .data(transactions)
                .build());
    }
}
