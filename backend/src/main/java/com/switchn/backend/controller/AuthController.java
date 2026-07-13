package com.switchn.backend.controller;

import com.switchn.backend.dto.ApiResponse;
import com.switchn.backend.dto.AuthRequest;
import com.switchn.backend.dto.AuthResponse;
import com.switchn.backend.dto.UserDTO;
import com.switchn.backend.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/verify")
    public ResponseEntity<ApiResponse<AuthResponse>> verifyFirebaseToken(@RequestBody AuthRequest request) {
        AuthResponse authResponse = authService.verifyFirebaseToken(request);
        return ResponseEntity.ok(ApiResponse.<AuthResponse>builder()
                .success(true)
                .message("Authentication successful")
                .data(authResponse)
                .build());
    }

    @GetMapping("/profile")
    public ResponseEntity<ApiResponse<UserDTO>> getProfile(Authentication authentication) {
        Long userId = Long.parseLong(authentication.getPrincipal().toString());
        UserDTO user = authService.getUserProfile(userId);
        return ResponseEntity.ok(ApiResponse.<UserDTO>builder()
                .success(true)
                .message("User profile retrieved successfully")
                .data(user)
                .build());
    }

    @GetMapping("/health")
    public ResponseEntity<ApiResponse<String>> health() {
        return ResponseEntity.ok(ApiResponse.<String>builder()
                .success(true)
                .message("Backend is healthy")
                .data("OK")
                .build());
    }
}
