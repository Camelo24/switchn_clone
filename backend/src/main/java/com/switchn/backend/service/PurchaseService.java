package com.switchn.backend.service;

import com.switchn.backend.dto.TransactionDTO;
import com.switchn.backend.entity.*;
import com.switchn.backend.repository.*;
import com.switchn.backend.util.NetworkDetector;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Service
@Transactional
public class PurchaseService {

    private final PurchaseRepository purchaseRepository;
    private final UserRepository userRepository;
    private final BundleRepository bundleRepository;
    private final TransactionRepository transactionRepository;
    private final WalletService walletService;

    public PurchaseService(PurchaseRepository purchaseRepository, UserRepository userRepository, 
                          BundleRepository bundleRepository, TransactionRepository transactionRepository, 
                          WalletService walletService) {
        this.purchaseRepository = purchaseRepository;
        this.userRepository = userRepository;
        this.bundleRepository = bundleRepository;
        this.transactionRepository = transactionRepository;
        this.walletService = walletService;
    }

    @Transactional
    public TransactionDTO buyAirtime(Long userId, String network, String phoneNumber, BigDecimal amount) {
        // Validate network
        if (!isValidNetwork(network)) {
            throw new IllegalArgumentException("Invalid network: " + network);
        }

        // Validate phone
        if (phoneNumber == null || phoneNumber.isBlank()) {
            throw new IllegalArgumentException("Phone number is required");
        }

        // Validate amount
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Amount must be greater than zero");
        }

        // Get user
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        // Deduct from wallet
        walletService.deductBalance(userId, amount);

        // Create transaction (simulated)
        Transaction transaction = Transaction.builder()
                .user(user)
                .type("AIRTIME")
                .amount(amount)
                .status("COMPLETED")
                .description("Airtime purchase on " + network + " for " + phoneNumber)
                .referenceId("TRX-" + System.currentTimeMillis())
                .createdAt(LocalDateTime.now())
                .build();
        transaction = transactionRepository.save(transaction);

        return mapToTransactionDTO(transaction);
    }

    @Transactional
    public TransactionDTO buyBundle(Long userId, Long bundleId, String beneficiaryPhone) {
        // Validate bundle
        Bundle bundle = bundleRepository.findById(bundleId)
                .orElseThrow(() -> new IllegalArgumentException("Bundle not found"));

        // Get user
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        BigDecimal amount = bundle.getPrice();

        // Deduct from wallet
        walletService.deductBalance(userId, amount);

        // Create purchase record
        Purchase purchase = Purchase.builder()
                .user(user)
                .bundle(bundle)
                .beneficiaryPhone(beneficiaryPhone)
                .amount(amount)
                .status("COMPLETED")
                .createdAt(LocalDateTime.now())
                .build();
        purchaseRepository.save(purchase);

        // Create transaction
        Transaction transaction = Transaction.builder()
                .user(user)
                .type("DATA")
                .amount(amount)
                .status("COMPLETED")
                .description("Data bundle: " + bundle.getName() + " for " + beneficiaryPhone)
                .referenceId("TRX-" + System.currentTimeMillis())
                .createdAt(LocalDateTime.now())
                .build();
        transaction = transactionRepository.save(transaction);

        return mapToTransactionDTO(transaction);
    }

    public Page<TransactionDTO> getPurchaseHistory(Long userId, int page, int size) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        Pageable pageable = PageRequest.of(page, size);
        Page<Purchase> purchases = purchaseRepository.findByUserOrderByCreatedAtDesc(user, pageable);
        return purchases.map(p -> TransactionDTO.builder()
                .id(p.getId())
                .type("DATA")
                .amount(p.getAmount())
                .status(p.getStatus())
                .description(p.getBundle().getName())
                .createdAt(p.getCreatedAt())
                .build());
    }

    private boolean isValidNetwork(String network) {
        return network.equalsIgnoreCase("MTN") || network.equalsIgnoreCase("ORANGE") ||
               network.equalsIgnoreCase("CAMTEL") || network.equalsIgnoreCase("NEXTTEL") ||
               network.equalsIgnoreCase("YOOMEE");
    }

    private TransactionDTO mapToTransactionDTO(Transaction transaction) {
        return TransactionDTO.builder()
                .id(transaction.getId())
                .type(transaction.getType())
                .amount(transaction.getAmount())
                .status(transaction.getStatus())
                .description(transaction.getDescription())
                .createdAt(transaction.getCreatedAt())
                .build();
    }
}
