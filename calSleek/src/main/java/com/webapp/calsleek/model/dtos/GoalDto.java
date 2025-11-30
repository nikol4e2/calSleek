package com.webapp.calsleek.model.dtos;

import com.webapp.calsleek.model.enums.ActivityLevel;
import com.webapp.calsleek.model.enums.GoalType;
import lombok.Data;

@Data
public class GoalDto {

    private ActivityLevel activityLevel;
    private float weight;
    private int height;
    private int age;
    private Boolean isMale;
    private GoalType goalType;
}
