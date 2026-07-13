package com.switchn.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "bundles")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Bundle {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "isp_id", nullable = false)
    private ISP isp;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String type; // DATA, CALL, SMS

    @Column(nullable = false)
    private String volume; // e.g., "1GB", "100 minutes"

    @Column(nullable = false)
    private BigDecimal price;

    @Column(name = "validity_days")
    private Integer validityDays;

    @Column(name = "is_active")
    private Boolean isActive = true;
}
