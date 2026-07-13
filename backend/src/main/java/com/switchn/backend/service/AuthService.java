package com.switchn.backend.service;

import com.switchn.backend.dto.AuthRequest;
import com.switchn.backend.dto.AuthResponse;
import com.switchn.backend.dto.UserDTO;
import com.switchn.backend.entity.User;
import com.switchn.backend.entity.Wallet;
import com.switchn.backend.repository.UserRepository;
import com.switchn.backend.repository.WalletRepository;
import com.switchn.backend.security.JwtUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.Optional;

@Service
@Transactional
public class AuthService {

    private final UserRepository userRepository;
    private final WalletRepository walletRepository;
    private final JwtUtil jwtUtil;

    public AuthService(UserRepository userRepository, WalletRepository walletRepository, JwtUtil jwtUtil) {
        this.userRepository = userRepository;
        this.walletRepository = walletRepository;
        this.jwtUtil = jwtUtil;
    }

    public AuthResponse verifyFirebaseToken(AuthRequest request) {
        // In production, verify the Firebase token here
        // For MVP/demo, we'll accept any non-null token and use it as Firebase UID
        
        String firebaseUid = request.getFirebaseToken();
        if (firebaseUid == null || firebaseUid.isBlank()) {
            throw new IllegalArgumentException("Firebase token is required");
        }

        // Check if user exists
        Optional<User> existingUser = userRepository.findByFirebaseUid(firebaseUid);
        
        User user;
        if (existingUser.isPresent()) {
            user = existingUser.get();
        } else {
            // Create new user
            user = User.builder()
                    .firebaseUid(firebaseUid)
                    .email(firebaseUid + "@switchn.demo") // Demo email
                    .fullName("User " + firebaseUid.substring(0, Math.min(8, firebaseUid.length())))
                    .createdAt(LocalDateTime.now())
                    .build();
            user = userRepository.save(user);

            // Create wallet for the user
            Wallet wallet = new Wallet(user);
            walletRepository.save(wallet);
        }

        // Generate JWT
        String token = jwtUtil.generateToken(user.getId().toString());

        return AuthResponse.builder()
                .token(token)
                .user(mapToUserDTO(user))
                .message("Authentication successful")
                .build();
    }

    public UserDTO getUserProfile(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        return mapToUserDTO(user);
    }

    private UserDTO mapToUserDTO(User user) {
        return UserDTO.builder()
                .id(user.getId())
                .email(user.getEmail())
                .phone(user.getPhone())
                .fullName(user.getFullName())
                .createdAt(user.getCreatedAt())
                .build();
    }
}
