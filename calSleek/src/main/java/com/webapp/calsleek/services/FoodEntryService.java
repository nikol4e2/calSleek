package com.webapp.calsleek.services;

import com.webapp.calsleek.model.DailyMacros;
import com.webapp.calsleek.model.Food;
import com.webapp.calsleek.model.FoodEntry;
import com.webapp.calsleek.model.enums.TimeCategory;

import java.util.Optional;

public interface FoodEntryService {

    FoodEntry save(TimeCategory category,Food food,int grams);
    FoodEntry edit(Long id, TimeCategory category, int grams);
    Optional<FoodEntry> findById(Long id);
    void delete(FoodEntry foodEntry);
}
