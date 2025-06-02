package com.monii.repository;

import com.monii.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    Optional<User> findById(String id);

    boolean existsByEmail(String email);

    Optional<User> findByGoogleId(String googleId);

}