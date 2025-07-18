package com.webapp.calsleek.model.exceptions;

public class UserNotFoundException extends RuntimeException{
    public UserNotFoundException() {
        super("User not found");
    }
}
