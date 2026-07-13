package com.switchn.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "telecom_customers")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TelecomCustomer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "phone_number", unique = true, nullable = false)
    private String phoneNumber;

    @ManyToOne
    @JoinColumn(name = "isp_id", nullable = false)
    private ISP isp;
}
