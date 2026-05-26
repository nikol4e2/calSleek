package com.webapp.calsleek.services;

import com.webapp.calsleek.model.DailyMacros;
import com.webapp.calsleek.model.ExerciseLog;
import com.webapp.calsleek.model.FoodEntry;
import org.springframework.cglib.core.Local;
import org.springframework.http.ResponseEntity;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface DailyMacrosService {
    DailyMacros save(LocalDate date, Long userId);
    DailyMacros edit(Long id,LocalDate date);
    void addFoodEntry(Long dailyMacrosId,FoodEntry foodEntry);
    void removeFoodEntry(Long dailyMacrosId,Long foodEntryId);
    void addExerciseLog(Long dailyMacrosId, ExerciseLog exerciseLog);
    void removeExerciseLog(Long dailyMacrosId, Long exerciseLogId);
    Optional<DailyMacros> findById(Long id);
    void deleteById(Long id);
    List<FoodEntry> getFoodEntriesForUserAndDate(Long userId, LocalDate date);

    DailyMacros findByUserIdAndDate(Long userId, LocalDate dateTime);
     DailyMacros getOrCreateToday(Long userId);
}
