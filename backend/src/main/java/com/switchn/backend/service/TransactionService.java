package com.switchn.backend.service;

import com.switchn.backend.dto.TransactionDTO;
import com.switchn.backend.entity.Transaction;
import com.switchn.backend.entity.User;
import com.switchn.backend.repository.TransactionRepository;
import com.switchn.backend.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class TransactionService {

    private final TransactionRepository transactionRepository;
    private final UserRepository userRepository;

    public TransactionService(TransactionRepository transactionRepository, UserRepository userRepository) {
        this.transactionRepository = transactionRepository;
        this.userRepository = userRepository;
    }

    public Page<TransactionDTO> getTransactions(Long userId, int page, int size) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        
        Pageable pageable = PageRequest.of(page, size);
        Page<Transaction> transactions = transactionRepository.findByUserOrderByCreatedAtDesc(user, pageable);
        
        return transactions.map(this::mapToTransactionDTO);
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
