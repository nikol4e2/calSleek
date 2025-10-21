package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.DailyMacros;
import com.webapp.calsleek.model.DailySummary;
import com.webapp.calsleek.repositories.DailySummaryRepository;
import com.webapp.calsleek.services.DailySummaryService;

import java.time.LocalDateTime;
import java.util.Optional;

public class DailySummaryServiceImpl implements DailySummaryService {


    private final DailySummaryRepository dailySummaryRepository;

    public DailySummaryServiceImpl(DailySummaryRepository dailySummaryRepository) {
        this.dailySummaryRepository = dailySummaryRepository;
    }

    @Override
    public DailySummary save(LocalDateTime date, int totalCalories, int totalCarbs, int totalProteins, int totalFats, int totalCaloriesBurned) {
        if(totalCalories < 0 && totalCarbs < 0 && totalProteins < 0 && totalFats < 0) {
            throw new IllegalArgumentException("Can't have less then zero values for calories, carbs, proteins or fats");
        }
        DailySummary dailySummary = new DailySummary(date,totalCalories,totalCarbs,totalFats,totalProteins,totalCaloriesBurned);
        return dailySummaryRepository.save(dailySummary);
    }

    @Override
    public DailySummary update(Long id, LocalDateTime date, int totalCalories, int totalCarbs, int totalProteins, int totalFats, int totalCaloriesBurned) {
        if(this.dailySummaryRepository.existsById(id)) {
            DailySummary dailySummary = this.dailySummaryRepository.findById(id).get();
            dailySummary.setDate(date);
            dailySummary.setTotalCalories(totalCalories);
            dailySummary.setTotalCarbs(totalCarbs);
            dailySummary.setTotalProteins(totalProteins);
            dailySummary.setTotalFats(totalFats);
            dailySummary.setTotalcaloriesBurned(totalCaloriesBurned);
            return dailySummaryRepository.save(dailySummary);
        }
        throw new IllegalArgumentException("Can't find daily summary with id: " + id);
    }

    @Override
    public Optional<DailySummary> findById(Long id) {
        return this.dailySummaryRepository.findById(id);
    }

    @Override
    public void deleteById(Long id) {
        if(this.dailySummaryRepository.existsById(id)) {
            this.dailySummaryRepository.deleteById(id);
        }
    }
}
