package com.switchn.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "isps")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ISP {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String name;

    @Column(name = "display_name")
    private String displayName;
}
