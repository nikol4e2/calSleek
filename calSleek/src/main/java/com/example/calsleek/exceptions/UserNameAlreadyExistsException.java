package com.example.calsleek.exceptions;

public class UserNameAlreadyExistsException extends RuntimeException{

    public UserNameAlreadyExistsException(String message) {
        super(String.format("Username with name %s already exists",message));
    }
}
