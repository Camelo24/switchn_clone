package com.switchn.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "money_transfers")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MoneyTransfer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "sender_user_id", nullable = false)
    private User senderUser;

    @Column(name = "sender_phone", nullable = false)
    private String senderPhone;

    @Column(name = "sender_network", nullable = false)
    private String senderNetwork; // MTN, ORANGE

    @Column(name = "recipient_phone", nullable = false)
    private String recipientPhone;

    @Column(name = "recipient_name")
    private String recipientName;

    @Column(name = "recipient_network", nullable = false)
    private String recipientNetwork; // MTN, ORANGE

    @Column(nullable = false)
    private BigDecimal amount;

    @Column(nullable = false)
    private String status; // PENDING, COMPLETED, FAILED

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (status == null) {
            status = "COMPLETED";
        }
    }
}
