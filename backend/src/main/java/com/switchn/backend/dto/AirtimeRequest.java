package com.switchn.backend.dto;

import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AirtimeRequest {
    private String network;
    private String phoneNumber;
    private BigDecimal amount;
}
