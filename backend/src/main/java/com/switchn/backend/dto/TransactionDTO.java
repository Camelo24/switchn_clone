package com.switchn.backend.dto;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TransactionDTO {
    private Long id;
    private String type;
    private BigDecimal amount;
    private String status;
    private String description;
    private LocalDateTime createdAt;
}
