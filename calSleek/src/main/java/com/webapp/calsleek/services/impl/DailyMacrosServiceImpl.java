package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.DailyMacros;
import com.webapp.calsleek.model.ExerciseLog;
import com.webapp.calsleek.model.FoodEntry;
import com.webapp.calsleek.model.User;
import com.webapp.calsleek.repositories.DailyMacrosRepository;
import com.webapp.calsleek.services.DailyMacrosService;
import com.webapp.calsleek.services.ExerciseLogService;
import com.webapp.calsleek.services.FoodEntryService;
import com.webapp.calsleek.services.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class DailyMacrosServiceImpl implements DailyMacrosService {

    private final DailyMacrosRepository dailyMacrosRepository;
    private final UserService userService;
    private final ExerciseLogService exerciseLogService;
    private final FoodEntryService foodEntryService;


    public DailyMacrosServiceImpl(DailyMacrosRepository dailyMacrosRepository, UserService userService, ExerciseLogService exerciseLogService, FoodEntryService foodEntryService) {
        this.dailyMacrosRepository = dailyMacrosRepository;
        this.userService = userService;
        this.exerciseLogService = exerciseLogService;
        this.foodEntryService = foodEntryService;
    }

    @Override
    public DailyMacros save(LocalDateTime date, Long userId) {
        User user=userService.findById(userId).orElseThrow(()->new RuntimeException("User Not Found"));
        DailyMacros dailyMacros = new DailyMacros(date,user);
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
        this.foodEntryService.deleteById(foodEntryId);
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
        exerciseLogService.delete(exerciseLogId);
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

    @Override
    public List<FoodEntry> getFoodEntriesForUserAndDate(Long userId, LocalDateTime dateTime) {
        LocalDateTime startOfDay = dateTime.toLocalDate().atStartOfDay();
        LocalDateTime endOfDay = dateTime.toLocalDate().atTime(23, 59, 59, 999_999_999);

        return dailyMacrosRepository
                .findByUser_IdAndDateBetween(userId, startOfDay, endOfDay)
                .map(DailyMacros::getFoodEntries)
                .orElse(List.of());
    }


    @Override
    public DailyMacros findByUserIdAndDate(Long userId, LocalDateTime dateTime) {
        LocalDateTime startOfDay = dateTime.toLocalDate().atStartOfDay();
        LocalDateTime endOfDay = dateTime.toLocalDate().atTime(23, 59, 59, 999_999_999);
        DailyMacros dailyMacros=this.dailyMacrosRepository.findByUser_IdAndDateBetween(userId,startOfDay,endOfDay).orElseThrow(()->new RuntimeException("Daily Macros not found"));
        return dailyMacros;
    }
}
