package com.monii.service;

import com.monii.model.User;
import com.monii.repository.UserRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {
    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String identifier) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(identifier)
                .orElseGet(() -> userRepository.findById(identifier)
                        .orElseThrow(() -> new UsernameNotFoundException("User not found")));

        return org.springframework.security.core.userdetails.User
                .withUsername(user.getEmail())  // Or use user.getId()
                .password(user.getPassword())
                .authorities("USER")
                .build();
    }
}