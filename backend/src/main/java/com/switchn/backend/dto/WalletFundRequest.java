package com.switchn.backend.dto;

import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class WalletFundRequest {
    private BigDecimal amount;
}
