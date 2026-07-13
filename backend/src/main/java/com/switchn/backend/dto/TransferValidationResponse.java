package com.switchn.backend.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TransferValidationResponse {
    private String name;
    private String network;
    private String phone;
}
