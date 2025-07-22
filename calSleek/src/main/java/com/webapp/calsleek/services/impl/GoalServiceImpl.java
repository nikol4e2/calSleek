package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.Goal;
import com.webapp.calsleek.model.enums.ActivityLevel;
import com.webapp.calsleek.model.enums.GoalType;
import com.webapp.calsleek.model.exceptions.GoalNotFoundException;
import com.webapp.calsleek.repositories.GoalRepository;
import com.webapp.calsleek.services.GoalService;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class GoalServiceImpl implements GoalService {
    private GoalRepository goalRepository;


    public GoalServiceImpl(GoalRepository goalRepository) {
        this.goalRepository = goalRepository;
    }


    @Override
    public Goal saveGoal(ActivityLevel activityLevel, float weight, int height, int age, GoalType goalType, Boolean isMale) {
        if(!(weight > 20 && height > 100 && age>10))
        {
            throw new IllegalArgumentException("Invalid arguments passed to saveGoal");
        }

        Goal goal=new Goal(activityLevel,weight,height,age,goalType,isMale);
        return this.goalRepository.save(goal);
    }

    @Override
    public Goal editGoal(Long id, ActivityLevel activityLevel, float weight, int height, int age, GoalType goalType, Boolean isMale) {
        Goal goal=this.goalRepository.findById(id).orElseThrow(()->new GoalNotFoundException());
        goal.setActivityLevel(activityLevel);
        goal.setWeight(weight);
        goal.setHeight(height);
        goal.setAge(age);
        goal.setGoalType(goalType);
        goal.setIsMale(isMale);
        // TODO->Make this function in goal class : goal.updateGoal();
        return this.goalRepository.save(goal);
    }

    @Override
    public Optional<Goal> findById(Long id) {
        return this.goalRepository.findById(id);
    }

    @Override
    public void deleteGoal(Long id) {
        if(this.goalRepository.findById(id).isPresent())
        {
            this.goalRepository.deleteById(id);
        }
    }
}
