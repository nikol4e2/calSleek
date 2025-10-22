package com.webapp.calsleek.model.dtos;

import lombok.Data;

@Data
public class ExerciseDto {

    private String name;
    private int caloriesBurnedPerMinute;

    public ExerciseDto(String name, int caloriesBurnedPerMinute) {
        this.name = name;
        this.caloriesBurnedPerMinute = caloriesBurnedPerMinute;
    }
}
