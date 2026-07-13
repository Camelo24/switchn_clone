package com.switchn.backend.util;

import com.switchn.backend.entity.Bundle;
import com.switchn.backend.entity.ISP;
import com.switchn.backend.entity.TelecomCustomer;
import com.switchn.backend.repository.BundleRepository;
import com.switchn.backend.repository.ISPRepository;
import com.switchn.backend.repository.TelecomCustomerRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import java.math.BigDecimal;

@Component
public class DataSeeder implements CommandLineRunner {

    private final ISPRepository ispRepository;
    private final BundleRepository bundleRepository;
    private final TelecomCustomerRepository telecomCustomerRepository;

    public DataSeeder(ISPRepository ispRepository, 
                      BundleRepository bundleRepository,
                      TelecomCustomerRepository telecomCustomerRepository) {
        this.ispRepository = ispRepository;
        this.bundleRepository = bundleRepository;
        this.telecomCustomerRepository = telecomCustomerRepository;
    }

    @Override
    public void run(String... args) {
        seedISPs();
        seedBundles();
        seedTelecomCustomers();
    }

    private void seedISPs() {
        if (ispRepository.count() == 0) {
            ISP mtn = ISP.builder()
                    .name("MTN")
                    .displayName("MTN Cameroon")
                    .build();
            
            ISP orange = ISP.builder()
                    .name("ORANGE")
                    .displayName("Orange Cameroon")
                    .build();
            
            ISP camtel = ISP.builder()
                    .name("CAMTEL")
                    .displayName("Camtel")
                    .build();
            
            ISP yoomee = ISP.builder()
                    .name("YOOMEE")
                    .displayName("Yoomee")
                    .build();

            ispRepository.save(mtn);
            ispRepository.save(orange);
            ispRepository.save(camtel);
            ispRepository.save(yoomee);
            
            System.out.println("ISPs seeded successfully");
        }
    }

    private void seedBundles() {
        if (bundleRepository.count() == 0) {
            ISP mtn = ispRepository.findByName("MTN").orElseThrow();
            ISP orange = ispRepository.findByName("ORANGE").orElseThrow();
            ISP camtel = ispRepository.findByName("CAMTEL").orElseThrow();

            // MTN Data Bundles
            bundleRepository.save(Bundle.builder()
                    .isp(mtn)
                    .name("Daily 50MB")
                    .type("DATA")
                    .volume("50MB")
                    .price(new BigDecimal("50"))
                    .validityDays(1)
                    .isActive(true)
                    .build());

            bundleRepository.save(Bundle.builder()
                    .isp(mtn)
                    .name("Daily 200MB")
                    .type("DATA")
                    .volume("200MB")
                    .price(new BigDecimal("100"))
                    .validityDays(1)
                    .isActive(true)
                    .build());

            bundleRepository.save(Bundle.builder()
                    .isp(mtn)
                    .name("Weekly 1GB")
                    .type("DATA")
                    .volume("1GB")
                    .price(new BigDecimal("500"))
                    .validityDays(7)
                    .isActive(true)
                    .build());

            bundleRepository.save(Bundle.builder()
                    .isp(mtn)
                    .name("Monthly 2GB")
                    .type("DATA")
                    .volume("2GB")
                    .price(new BigDecimal("1000"))
                    .validityDays(30)
                    .isActive(true)
                    .build());

            // Orange Data Bundles
            bundleRepository.save(Bundle.builder()
                    .isp(orange)
                    .name("Daily 100MB")
                    .type("DATA")
                    .volume("100MB")
                    .price(new BigDecimal("75"))
                    .validityDays(1)
                    .isActive(true)
                    .build());

            bundleRepository.save(Bundle.builder()
                    .isp(orange)
                    .name("Daily 500MB")
                    .type("DATA")
                    .volume("500MB")
                    .price(new BigDecimal("150"))
                    .validityDays(1)
                    .isActive(true)
                    .build());

            bundleRepository.save(Bundle.builder()
                    .isp(orange)
                    .name("Weekly 2GB")
                    .type("DATA")
                    .volume("2GB")
                    .price(new BigDecimal("600"))
                    .validityDays(7)
                    .isActive(true)
                    .build());

            bundleRepository.save(Bundle.builder()
                    .isp(orange)
                    .name("Monthly 5GB")
                    .type("DATA")
                    .volume("5GB")
                    .price(new BigDecimal("2000"))
                    .validityDays(30)
                    .isActive(true)
                    .build());

            // Camtel Data Bundles
            bundleRepository.save(Bundle.builder()
                    .isp(camtel)
                    .name("Daily 1GB")
                    .type("DATA")
                    .volume("1GB")
                    .price(new BigDecimal("200"))
                    .validityDays(1)
                    .isActive(true)
                    .build());

            bundleRepository.save(Bundle.builder()
                    .isp(camtel)
                    .name("Monthly 10GB")
                    .type("DATA")
                    .volume("10GB")
                    .price(new BigDecimal("3000"))
                    .validityDays(30)
                    .isActive(true)
                    .build());

            System.out.println("Bundles seeded successfully");
        }
    }

    private void seedTelecomCustomers() {
        if (telecomCustomerRepository.count() == 0) {
            telecomCustomerRepository.save(TelecomCustomer.builder()
                    .fullName("John Neba")
                    .phoneNumber("677123456")
                    .isp(ispRepository.findByName("MTN").orElseThrow())
                    .build());

            telecomCustomerRepository.save(TelecomCustomer.builder()
                    .fullName("Marie Fouda")
                    .phoneNumber("699876543")
                    .isp(ispRepository.findByName("ORANGE").orElseThrow())
                    .build());

            telecomCustomerRepository.save(TelecomCustomer.builder()
                    .fullName("Paul Mbarga")
                    .phoneNumber("677555666")
                    .isp(ispRepository.findByName("MTN").orElseThrow())
                    .build());

            telecomCustomerRepository.save(TelecomCustomer.builder()
                    .fullName("Sarah Atangana")
                    .phoneNumber("699444333")
                    .isp(ispRepository.findByName("ORANGE").orElseThrow())
                    .build());

            System.out.println("Telecom customers seeded successfully");
        }
    }
}
