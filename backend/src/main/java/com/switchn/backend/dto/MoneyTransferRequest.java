package com.switchn.backend.dto;

import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MoneyTransferRequest {
    private String recipientPhone;
    private String senderNetwork;
    private BigDecimal amount;
}
