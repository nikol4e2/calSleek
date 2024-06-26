package com.example.calsleek.model;

import lombok.Data;

@Data
public class Exercise {

    private String name;
    private int caloriesBurnedPerMinute;

    public Exercise(String name, int caloriesBurnedPerMinute) {
        this.name = name;
        this.caloriesBurnedPerMinute = caloriesBurnedPerMinute;
    }
}
