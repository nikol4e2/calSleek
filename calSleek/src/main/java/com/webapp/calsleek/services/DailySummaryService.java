package com.webapp.calsleek.services;

import com.webapp.calsleek.model.DailyMacros;
import com.webapp.calsleek.model.DailySummary;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Optional;

public interface DailySummaryService {

    DailySummary save(LocalDate date, int totalCalories, int totalCarbs, int totalProteins, int totalFats, int totalCaloriesBurned);
    DailySummary update(Long id, LocalDate date, int totalCalories, int totalCarbs, int totalProteins, int totalFats, int totalCaloriesBurned);

    Optional<DailySummary> findById(Long id);
    void deleteById(Long id);

}
