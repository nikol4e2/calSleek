package com.example.calsleek.exceptions;

public class InvalidDateException extends RuntimeException{

    public InvalidDateException() {
        super("Invalid date entered!");
    }
}
