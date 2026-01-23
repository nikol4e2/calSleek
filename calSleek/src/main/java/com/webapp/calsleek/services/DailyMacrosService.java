package com.webapp.calsleek.services;

import com.webapp.calsleek.model.DailyMacros;
import com.webapp.calsleek.model.ExerciseLog;
import com.webapp.calsleek.model.FoodEntry;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface DailyMacrosService {
    DailyMacros save(LocalDateTime date, Long userId);
    DailyMacros edit(Long id,LocalDateTime date);
    void addFoodEntry(Long dailyMacrosId,FoodEntry foodEntry);
    void removeFoodEntry(Long dailyMacrosId,Long foodEntryId);
    void addExerciseLog(Long dailyMacrosId, ExerciseLog exerciseLog);
    void removeExerciseLog(Long dailyMacrosId, Long exerciseLogId);
    Optional<DailyMacros> findById(Long id);
    void deleteById(Long id);
    List<FoodEntry> getFoodEntriesForUserAndDate(Long userId, LocalDateTime date);
}
