package com.webapp.calsleek.model.dtos;

import com.webapp.calsleek.model.enums.ActivityLevel;
import com.webapp.calsleek.model.enums.GoalType;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateGoalDto {

    @NotNull
    private ActivityLevel activityLevel;

    @Min(100)
    private int height;

    @Min(12)
    private int age;

    private Boolean isMale;

    private GoalType goalType;

    @Min(0)
    private int calories;

    @Min(0)
    private int carbs;

    @Min(0)
    private int proteins;

    @Min(0)
    private int fats;
}
