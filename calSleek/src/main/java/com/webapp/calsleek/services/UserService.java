package com.webapp.calsleek.services;

import com.webapp.calsleek.model.User;

import java.util.Optional;

public interface UserService {
    User login(String username, String password);
    User register(String username, String firstName,String lastName,String email,String password, String repeatPassword);

    Optional<User> findByUsername(String username);
    Optional<User> findById(Long id);
}
