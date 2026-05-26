package com.webapp.calsleek.services;

import com.webapp.calsleek.model.Goal;
import com.webapp.calsleek.model.enums.ActivityLevel;
import com.webapp.calsleek.model.enums.GoalType;

import java.util.Optional;

public interface GoalService {

    Goal saveGoal(Long userId,ActivityLevel activityLevel, float weight, int height, int age, GoalType goalType, Boolean isMale);
    Goal editGoal(Long id, ActivityLevel activityLevel, float weight, int height, int age, GoalType goalType, Boolean isMale);
    Optional<Goal> findById(Long id);
    void deleteGoal(Long id);

    Optional<Goal> findByUserId(Long userId);
    //TODO-ADD functionality only to change the macros

}
