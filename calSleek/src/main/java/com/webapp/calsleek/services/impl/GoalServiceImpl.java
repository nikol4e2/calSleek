package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.Goal;
import com.webapp.calsleek.model.Measurement;
import com.webapp.calsleek.model.User;
import com.webapp.calsleek.model.dtos.UpdateGoalDto;
import com.webapp.calsleek.model.enums.ActivityLevel;
import com.webapp.calsleek.model.enums.GoalType;
import com.webapp.calsleek.model.exceptions.GoalNotFoundException;
import com.webapp.calsleek.repositories.GoalRepository;
import com.webapp.calsleek.repositories.UserRepository;
import com.webapp.calsleek.services.GoalService;
import com.webapp.calsleek.services.MeasurementService;
import com.webapp.calsleek.services.UserService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class GoalServiceImpl implements GoalService {
    private final GoalRepository goalRepository;
    private final UserService userService;
    private final UserRepository userRepository;
    private final MeasurementService measurementService;


    public GoalServiceImpl(GoalRepository goalRepository, UserService userService, UserRepository userRepository, MeasurementService measurementService) {
        this.goalRepository = goalRepository;
        this.userService = userService;
        this.userRepository = userRepository;
        this.measurementService = measurementService;
    }


    @Override
    public Goal saveGoal(Long userId,ActivityLevel activityLevel, float weight, int height, int age, GoalType goalType, Boolean isMale) {
        if(!(weight > 20 && height > 100 && age>10))
        {
            throw new IllegalArgumentException("Invalid arguments passed to saveGoal");
        }

        User user=userRepository.findById(userId).orElseThrow(()-> new RuntimeException("User not found"));
        Goal goal=new Goal(activityLevel,weight,height,age,goalType,isMale);
        goal.setUser(user);
        this.userService.addGoalToUser(userId, goal);

        Goal savedGoal=this.goalRepository.save(goal);
        //CREATE INTIAL MEASUREMENT

        measurementService.addMeasurementToUser(userId,LocalDateTime.now(),weight);
        return savedGoal;
    }

    @Override
    public Goal editGoal(Long id, UpdateGoalDto dto) {

        Goal goal = goalRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Goal not found"));


        Measurement latest = measurementService
                .getLatest(goal.getUser().getId());


        // update values selected by user
        goal.setActivityLevel(dto.getActivityLevel());
        goal.setGoalType(dto.getGoalType());


        // always use latest weight
        goal.setWeight(latest.getValue());


        // recalculate calories and macros
        goal.calculateCalories();


        return goalRepository.save(goal);
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

    @Override
    public Optional<Goal> findByUserId(Long userId) {
        return this.goalRepository.findTopByUserIdOrderByIdDesc(userId);
    }
}
