package com.webapp.calsleek.model.exceptions;

public class FoodNotFoundException extends RuntimeException{
    public FoodNotFoundException(Long id) {
        super("Could not find food: " + id);
    }
}
