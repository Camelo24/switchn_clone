package com.switchn.backend.dto;

import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BundlePurchaseRequest {
    private Long bundleId;
    private String beneficiaryPhone;
}
