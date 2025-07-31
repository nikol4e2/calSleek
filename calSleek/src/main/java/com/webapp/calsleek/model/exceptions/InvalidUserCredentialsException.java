package com.webapp.calsleek.model.exceptions;

public class InvalidUserCredentialsException extends RuntimeException {

    public InvalidUserCredentialsException(String message) {
        super(String.format("Invalid user credentials: %s", message));
    }
}
