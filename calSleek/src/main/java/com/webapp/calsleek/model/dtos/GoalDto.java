package com.webapp.calsleek.model.dtos;

import com.webapp.calsleek.model.enums.ActivityLevel;
import com.webapp.calsleek.model.enums.GoalType;
import jakarta.validation.constraints.Min;
import lombok.Data;
import org.antlr.v4.runtime.misc.NotNull;
import org.hibernate.annotations.NotFound;

@Data
public class GoalDto {

    @NotNull
    private ActivityLevel activityLevel;

    @Min(30)
    private float weight;
    @Min(100)
    private int height;
    @Min(12)
    private int age;
    private Boolean isMale;
    private GoalType goalType;
}
