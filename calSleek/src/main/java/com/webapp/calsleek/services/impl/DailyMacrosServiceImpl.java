package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.DailyMacros;
import com.webapp.calsleek.model.ExerciseLog;
import com.webapp.calsleek.model.FoodEntry;
import com.webapp.calsleek.repositories.DailyMacrosRepository;
import com.webapp.calsleek.services.DailyMacrosService;
import com.webapp.calsleek.services.UserService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class DailyMacrosServiceImpl implements DailyMacrosService {

    private final DailyMacrosRepository dailyMacrosRepository;
    private final UserService userService;


    public DailyMacrosServiceImpl(DailyMacrosRepository dailyMacrosRepository,UserService userService) {
        this.dailyMacrosRepository = dailyMacrosRepository;
        this.userService = userService;
    }


    @Override
    public DailyMacros save(LocalDateTime date, Long userId) {
        DailyMacros dailyMacros = new DailyMacros(date);
        userService.addDailyMacrosToUser(userId,dailyMacros);
        return dailyMacrosRepository.save(dailyMacros);

    }

    @Override
    public DailyMacros edit(Long id, LocalDateTime date) {
        DailyMacros dailyMacros = this.dailyMacrosRepository.findById(id).orElseThrow(()->new RuntimeException("Daily Macros not found"));
        dailyMacros.setDate(date);
        return this.dailyMacrosRepository.save(dailyMacros);
    }


    @Override
    public void addFoodEntry(Long dailyMacrosId, FoodEntry foodEntry) {
        DailyMacros dailyMacros = this.dailyMacrosRepository.findById(dailyMacrosId).orElseThrow(()->new RuntimeException("Daily Macros not found"));
        dailyMacros.addFoodEntry(foodEntry);
        this.dailyMacrosRepository.save(dailyMacros);
    }

    @Override
    public void removeFoodEntry(Long dailyMacrosId, Long foodEntryId) {
        DailyMacros dailyMacros = this.dailyMacrosRepository.findById(dailyMacrosId).orElseThrow(()->new RuntimeException("Daily Macros not found"));
        dailyMacros.removeFoodEntry(foodEntryId);
        this.dailyMacrosRepository.save(dailyMacros);
    }

    @Override
    public void addExerciseLog(Long dailyMacrosId, ExerciseLog exerciseLog) {
        DailyMacros dailyMacros = this.dailyMacrosRepository.findById(dailyMacrosId).orElseThrow(()->new RuntimeException("Daily Macros not found"));
        dailyMacros.addExerciseLog(exerciseLog);
        this.dailyMacrosRepository.save(dailyMacros);
    }

    @Override
    public void removeExerciseLog(Long dailyMacrosId, Long exerciseLogId) {
        DailyMacros dailyMacros = this.dailyMacrosRepository.findById(dailyMacrosId).orElseThrow(()->new RuntimeException("Daily Macros not found"));
        dailyMacros.removeExerciseLog(exerciseLogId);
        this.dailyMacrosRepository.save(dailyMacros);
    }

    @Override
    public Optional<DailyMacros> findById(Long id) {
        return this.dailyMacrosRepository.findById(id);
    }

    @Override
    public void deleteById(Long id) {
        if (this.dailyMacrosRepository.existsById(id)) {
            this.dailyMacrosRepository.deleteById(id);
        }
    }
}
