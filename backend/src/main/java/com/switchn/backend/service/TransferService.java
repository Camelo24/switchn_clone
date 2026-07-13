package com.switchn.backend.service;

import com.switchn.backend.dto.TransactionDTO;
import com.switchn.backend.dto.TransferValidationResponse;
import com.switchn.backend.entity.MoneyTransfer;
import com.switchn.backend.entity.TelecomCustomer;
import com.switchn.backend.entity.Transaction;
import com.switchn.backend.entity.User;
import com.switchn.backend.repository.MoneyTransferRepository;
import com.switchn.backend.repository.TelecomCustomerRepository;
import com.switchn.backend.repository.TransactionRepository;
import com.switchn.backend.repository.UserRepository;
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
public class TransferService {

    private final MoneyTransferRepository moneyTransferRepository;
    private final TelecomCustomerRepository telecomCustomerRepository;
    private final UserRepository userRepository;
    private final TransactionRepository transactionRepository;
    private final WalletService walletService;

    public TransferService(MoneyTransferRepository moneyTransferRepository, 
                          TelecomCustomerRepository telecomCustomerRepository,
                          UserRepository userRepository, TransactionRepository transactionRepository,
                          WalletService walletService) {
        this.moneyTransferRepository = moneyTransferRepository;
        this.telecomCustomerRepository = telecomCustomerRepository;
        this.userRepository = userRepository;
        this.transactionRepository = transactionRepository;
        this.walletService = walletService;
    }

    public TransferValidationResponse validateRecipient(String phoneNumber) {
        String network = NetworkDetector.detectNetwork(phoneNumber);
        if (network == null) {
            throw new IllegalArgumentException("Invalid phone number or unsupported network");
        }

        // Try to find telecom customer
        TelecomCustomer customer = telecomCustomerRepository.findByPhoneNumber(phoneNumber)
                .orElse(null);

        String name = customer != null ? customer.getFullName() : "User " + phoneNumber;

        return TransferValidationResponse.builder()
                .phone(phoneNumber)
                .network(network)
                .name(name)
                .build();
    }

    @Transactional
    public TransactionDTO sendMoney(Long userId, String senderNetwork, String recipientPhone, BigDecimal amount) {
        // Validate amount
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Amount must be greater than zero");
        }

        // Get user
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        // Validate networks
        String recipientNetwork = NetworkDetector.detectNetwork(recipientPhone);
        if (recipientNetwork == null) {
            throw new IllegalArgumentException("Invalid recipient phone number");
        }

        // Deduct from wallet
        walletService.deductBalance(userId, amount);

        // Find recipient info
        TelecomCustomer recipient = telecomCustomerRepository.findByPhoneNumber(recipientPhone)
                .orElse(null);
        String recipientName = recipient != null ? recipient.getFullName() : "User";

        // Create money transfer record
        MoneyTransfer transfer = MoneyTransfer.builder()
                .senderUser(user)
                .senderPhone(user.getPhone() != null ? user.getPhone() : "237XXXXXXXX")
                .senderNetwork(senderNetwork)
                .recipientPhone(recipientPhone)
                .recipientName(recipientName)
                .recipientNetwork(recipientNetwork)
                .amount(amount)
                .status("COMPLETED")
                .createdAt(LocalDateTime.now())
                .build();
        moneyTransferRepository.save(transfer);

        // Create transaction
        Transaction transaction = Transaction.builder()
                .user(user)
                .type("TRANSFER")
                .amount(amount)
                .status("COMPLETED")
                .description("Transfer to " + recipientPhone + " (" + recipientName + ")")
                .referenceId("TRX-" + System.currentTimeMillis())
                .createdAt(LocalDateTime.now())
                .build();
        transaction = transactionRepository.save(transaction);

        return mapToTransactionDTO(transaction);
    }

    public Page<TransactionDTO> getTransferHistory(Long userId, int page, int size) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        Pageable pageable = PageRequest.of(page, size);
        Page<MoneyTransfer> transfers = moneyTransferRepository.findBySenderUserOrderByCreatedAtDesc(user, pageable);
        return transfers.map(t -> TransactionDTO.builder()
                .id(t.getId())
                .type("TRANSFER")
                .amount(t.getAmount())
                .status(t.getStatus())
                .description("Transfer to " + t.getRecipientName())
                .createdAt(t.getCreatedAt())
                .build());
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
