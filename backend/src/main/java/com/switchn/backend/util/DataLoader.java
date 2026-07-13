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
public class DataLoader implements CommandLineRunner {

    private final ISPRepository ispRepository;
    private final BundleRepository bundleRepository;
    private final TelecomCustomerRepository telecomCustomerRepository;

    public DataLoader(ISPRepository ispRepository, BundleRepository bundleRepository, 
                     TelecomCustomerRepository telecomCustomerRepository) {
        this.ispRepository = ispRepository;
        this.bundleRepository = bundleRepository;
        this.telecomCustomerRepository = telecomCustomerRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        // Load ISPs if not exists
        if (ispRepository.count() == 0) {
            ISP mtn = ISP.builder().name("MTN").displayName("MTN Cameroon").build();
            ISP orange = ISP.builder().name("ORANGE").displayName("Orange Cameroon").build();
            ISP camtel = ISP.builder().name("CAMTEL").displayName("CAMTEL").build();
            ISP nexttel = ISP.builder().name("NEXTTEL").displayName("NEXTTEL").build();
            ISP yoomee = ISP.builder().name("YOOMEE").displayName("YOOMEE").build();
            
            mtn = ispRepository.save(mtn);
            orange = ispRepository.save(orange);
            camtel = ispRepository.save(camtel);
            nexttel = ispRepository.save(nexttel);
            yoomee = ispRepository.save(yoomee);

            // Load Bundles for MTN
            loadBundles(mtn, new String[][] {
                {"MTN Data 500MB", "DATA", "500MB", "500", "7"},
                {"MTN Data 1GB", "DATA", "1GB", "1000", "7"},
                {"MTN Data 5GB", "DATA", "5GB", "3500", "30"},
                {"MTN Call 100min", "CALL", "100 Minutes", "1000", "7"},
                {"MTN Call 500min", "CALL", "500 Minutes", "4000", "30"}
            });

            // Load Bundles for Orange
            loadBundles(orange, new String[][] {
                {"Orange Data 500MB", "DATA", "500MB", "500", "7"},
                {"Orange Data 1GB", "DATA", "1GB", "1000", "7"},
                {"Orange Data 5GB", "DATA", "5GB", "3500", "30"},
                {"Orange Call 100min", "CALL", "100 Minutes", "1000", "7"},
                {"Orange Call 500min", "CALL", "500 Minutes", "4000", "30"}
            });

            // Load sample telecom customers
            if (telecomCustomerRepository.count() == 0) {
                TelecomCustomer[] customers = {
                    TelecomCustomer.builder().fullName("John Neba").phoneNumber("237670123456").isp(mtn).build(),
                    TelecomCustomer.builder().fullName("Sarah Nkomo").phoneNumber("237691234567").isp(orange).build(),
                    TelecomCustomer.builder().fullName("Albert Kamgang").phoneNumber("237675678901").isp(mtn).build(),
                    TelecomCustomer.builder().fullName("Marie Dupont").phoneNumber("237692345678").isp(orange).build(),
                    TelecomCustomer.builder().fullName("David Tchotcho").phoneNumber("237671234567").isp(mtn).build()
                };
                for (TelecomCustomer customer : customers) {
                    telecomCustomerRepository.save(customer);
                }
            }
        }
    }

    private void loadBundles(ISP isp, String[][] bundleData) {
        for (String[] data : bundleData) {
            Bundle bundle = Bundle.builder()
                    .isp(isp)
                    .name(data[0])
                    .type(data[1])
                    .volume(data[2])
                    .price(new BigDecimal(data[3]))
                    .validityDays(Integer.parseInt(data[4]))
                    .isActive(true)
                    .build();
            bundleRepository.save(bundle);
        }
    }
}
