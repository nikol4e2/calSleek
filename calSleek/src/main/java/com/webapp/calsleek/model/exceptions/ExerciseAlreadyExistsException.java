package com.webapp.calsleek.model.exceptions;

public class ExerciseAlreadyExistsException extends RuntimeException {
    public ExerciseAlreadyExistsException() {
        super("Exercise with that name already exists");
    }
}
