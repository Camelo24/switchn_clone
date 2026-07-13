package com.switchn.backend.dto;

import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BundleDTO {
    private Long id;
    private String ispName;
    private String name;
    private String type;
    private String volume;
    private BigDecimal price;
    private Integer validityDays;
}
