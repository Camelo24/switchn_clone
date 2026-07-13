package com.switchn.backend.dto;

import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WalletDTO {
    private Long id;
    private BigDecimal balance;
}
