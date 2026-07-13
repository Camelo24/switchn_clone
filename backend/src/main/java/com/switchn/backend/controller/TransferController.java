package com.switchn.backend.controller;

import com.switchn.backend.dto.*;
import com.switchn.backend.service.TransferService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/transfer")
public class TransferController {

    private final TransferService transferService;

    public TransferController(TransferService transferService) {
        this.transferService = transferService;
    }

    @GetMapping("/validate/{phone}")
    public ResponseEntity<ApiResponse<TransferValidationResponse>> validateRecipient(
            @PathVariable String phone) {
        TransferValidationResponse response = transferService.validateRecipient(phone);
        return ResponseEntity.ok(ApiResponse.<TransferValidationResponse>builder()
                .success(true)
                .message("Recipient validated successfully")
                .data(response)
                .build());
    }

    @PostMapping("/send")
    public ResponseEntity<ApiResponse<TransactionDTO>> sendMoney(
            Authentication authentication,
            @RequestBody MoneyTransferRequest request) {
        Long userId = Long.parseLong(authentication.getPrincipal().toString());
        TransactionDTO transaction = transferService.sendMoney(userId, request.getSenderNetwork(), 
                request.getRecipientPhone(), request.getAmount());
        return ResponseEntity.ok(ApiResponse.<TransactionDTO>builder()
                .success(true)
                .message("Money transferred successfully")
                .data(transaction)
                .build());
    }
}
