package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.DailyMacros;
import com.webapp.calsleek.model.ExerciseLog;
import com.webapp.calsleek.model.FoodEntry;
import com.webapp.calsleek.model.User;
import com.webapp.calsleek.repositories.DailyMacrosRepository;
import com.webapp.calsleek.repositories.FoodEntryRepository;
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
    private final FoodEntryRepository foodEntryRepository;


    public DailyMacrosServiceImpl(DailyMacrosRepository dailyMacrosRepository, UserService userService, ExerciseLogService exerciseLogService, FoodEntryService foodEntryService, FoodEntryRepository foodEntryRepository) {
        this.dailyMacrosRepository = dailyMacrosRepository;
        this.userService = userService;
        this.exerciseLogService = exerciseLogService;
        this.foodEntryService = foodEntryService;
        this.foodEntryRepository = foodEntryRepository;
    }

    @Override
    public DailyMacros save(LocalDate date, Long userId) {
        User user=userService.findById(userId).orElseThrow(()->new RuntimeException("User Not Found"));
        DailyMacros dailyMacros = new DailyMacros(date,user);
        userService.addDailyMacrosToUser(userId,dailyMacros);
        return dailyMacrosRepository.save(dailyMacros);

    }

    @Override
    public DailyMacros edit(Long id, LocalDate date) {
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
    public List<FoodEntry> getFoodEntriesForUserAndDate(Long userId, LocalDate date) {


        return dailyMacrosRepository
                .findByUser_IdAndDate(userId, date)
                .map(DailyMacros::getFoodEntries)
                .orElse(List.of());
    }


    @Override
    public DailyMacros findByUserIdAndDate(Long userId, LocalDate dateTime) {



        return dailyMacrosRepository
                .findByUser_IdAndDate(userId, dateTime)
                .orElseGet(() -> {
                    User user = userService.findById(userId)
                            .orElseThrow(() -> new RuntimeException("User not found"));

                    DailyMacros macros = new DailyMacros(dateTime, user);
                    return dailyMacrosRepository.save(macros);
                });
    }

    @Override
    public DailyMacros getOrCreateToday(Long userId) {

        LocalDate today = LocalDate.now();

        return dailyMacrosRepository
                .findByUser_IdAndDate(userId, today)
                .orElseGet(() -> {
                    User user = userService.findById(userId)
                            .orElseThrow(() -> new RuntimeException("User not found"));

                    DailyMacros dailyMacros = new DailyMacros(today, user);

                    return dailyMacrosRepository.save(dailyMacros);
                });
    }

    public void updateFoodEntryGrams(
            Long dailyMacrosId,
            Long foodEntryId,
            int grams
    ) {
        DailyMacros dailyMacros =
                dailyMacrosRepository.findById(dailyMacrosId)
                        .orElseThrow();

        FoodEntry entry =
                foodEntryRepository.findById(foodEntryId)
                        .orElseThrow();

        dailyMacros.setTotalCalories(
                dailyMacros.getTotalCalories()
                        - entry.getTotalCalories());

        dailyMacros.setTotalCarbs(
                dailyMacros.getTotalCarbs()
                        - entry.getTotalCarbs());

        dailyMacros.setTotalProteins(
                dailyMacros.getTotalProteins()
                        - entry.getTotalProtein());

        dailyMacros.setTotalFats(
                dailyMacros.getTotalFats()
                        - entry.getTotalFats());

        entry.setGrams(grams);

        dailyMacros.setTotalCalories(
                dailyMacros.getTotalCalories()
                        + entry.getTotalCalories());

        dailyMacros.setTotalCarbs(
                dailyMacros.getTotalCarbs()
                        + entry.getTotalCarbs());

        dailyMacros.setTotalProteins(
                dailyMacros.getTotalProteins()
                        + entry.getTotalProtein());

        dailyMacros.setTotalFats(
                dailyMacros.getTotalFats()
                        + entry.getTotalFats());

        foodEntryRepository.save(entry);
        dailyMacrosRepository.save(dailyMacros);
    }



}
