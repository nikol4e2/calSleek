package com.webapp.calsleek.model.exceptions;

public class GoalNotFoundException extends RuntimeException {
    public GoalNotFoundException() {
        super("Goal not found");
    }
}
