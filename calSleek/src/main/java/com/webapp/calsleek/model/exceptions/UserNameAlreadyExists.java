package com.webapp.calsleek.model.exceptions;

public class UserNameAlreadyExists extends RuntimeException {

    public UserNameAlreadyExists(String username) {
        super(String.format("Username %s already exists", username));
    }
}
