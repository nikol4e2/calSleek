package com.webapp.calsleek.model.dtos;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ExerciseLogDto {

    private Long id;
    private Long exerciseId;
    private int durationInMinutes;

}
