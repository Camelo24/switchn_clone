package com.switchn.backend.service;

import com.switchn.backend.dto.TransactionDTO;
import com.switchn.backend.dto.WalletDTO;
import com.switchn.backend.entity.Transaction;
import com.switchn.backend.entity.User;
import com.switchn.backend.entity.Wallet;
import com.switchn.backend.repository.TransactionRepository;
import com.switchn.backend.repository.UserRepository;
import com.switchn.backend.repository.WalletRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.stream.Collectors;

@Service
@Transactional
public class WalletService {

    private final WalletRepository walletRepository;
    private final UserRepository userRepository;
    private final TransactionRepository transactionRepository;

    public WalletService(WalletRepository walletRepository, UserRepository userRepository, TransactionRepository transactionRepository) {
        this.walletRepository = walletRepository;
        this.userRepository = userRepository;
        this.transactionRepository = transactionRepository;
    }

    public WalletDTO getWallet(Long userId) {
        User user = getUser(userId);
        Wallet wallet = walletRepository.findByUser(user)
                .orElseThrow(() -> new IllegalArgumentException("Wallet not found"));
        return mapToWalletDTO(wallet);
    }

    @Transactional
    public WalletDTO fundWallet(Long userId, BigDecimal amount) {
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Amount must be greater than zero");
        }

        User user = getUser(userId);
        Wallet wallet = walletRepository.findByUser(user)
                .orElseThrow(() -> new IllegalArgumentException("Wallet not found"));

        // Update balance
        wallet.setBalance(wallet.getBalance().add(amount));
        wallet = walletRepository.save(wallet);

        // Create transaction record
        Transaction transaction = Transaction.builder()
                .user(user)
                .type("FUND")
                .amount(amount)
                .status("COMPLETED")
                .description("Wallet funding")
                .createdAt(LocalDateTime.now())
                .build();
        transactionRepository.save(transaction);

        return mapToWalletDTO(wallet);
    }

    public Page<TransactionDTO> getWalletHistory(Long userId, int page, int size) {
        User user = getUser(userId);
        Pageable pageable = PageRequest.of(page, size);
        Page<Transaction> transactions = transactionRepository.findByUserOrderByCreatedAtDesc(user, pageable);
        return transactions.map(this::mapToTransactionDTO);
    }

    protected void deductBalance(Long userId, BigDecimal amount) {
        User user = getUser(userId);
        Wallet wallet = walletRepository.findByUser(user)
                .orElseThrow(() -> new IllegalArgumentException("Wallet not found"));

        if (wallet.getBalance().compareTo(amount) < 0) {
            throw new IllegalArgumentException("Insufficient balance");
        }

        wallet.setBalance(wallet.getBalance().subtract(amount));
        walletRepository.save(wallet);
    }

    private User getUser(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
    }

    private WalletDTO mapToWalletDTO(Wallet wallet) {
        return WalletDTO.builder()
                .id(wallet.getId())
                .balance(wallet.getBalance())
                .build();
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
