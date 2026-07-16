package com.webapp.calsleek.model.dtos;

import com.webapp.calsleek.model.enums.ActivityLevel;
import com.webapp.calsleek.model.enums.GoalType;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateGoalDto {

    private ActivityLevel activityLevel;

    private GoalType goalType;
}
