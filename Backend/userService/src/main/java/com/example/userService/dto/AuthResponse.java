package com.example.userService.dto;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AuthResponse {

    private String username;
    private String token;
    private String firtName;
    private String lastName;
    private String email;
}