package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.DailyMacros;
import com.webapp.calsleek.model.Food;
import com.webapp.calsleek.model.FoodEntry;
import com.webapp.calsleek.model.User;
import com.webapp.calsleek.model.enums.TimeCategory;
import com.webapp.calsleek.repositories.FoodEntryRepository;
import com.webapp.calsleek.repositories.FoodRepository;
import com.webapp.calsleek.services.FoodService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class FoodEntryService implements com.webapp.calsleek.services.FoodEntryService {

    private final FoodEntryRepository foodEntryRepository;
    private final FoodRepository foodRepository;


    public FoodEntryService(FoodEntryRepository foodEntryRepository, FoodRepository foodRepository) {
        this.foodEntryRepository = foodEntryRepository;
        this.foodRepository = foodRepository;
    }


    @Override
    public FoodEntry save(TimeCategory category, Food food, int grams) {
        if(grams <= 0)
        {
            throw new IllegalArgumentException("grams must be greater than 0");
        }
        FoodEntry foodEntry = new FoodEntry(category, food, grams);
        return foodEntryRepository.save(foodEntry);
    }

    @Override
    public FoodEntry edit(Long id, TimeCategory category, int grams) {
        FoodEntry foodEntry = foodEntryRepository.findById(id).orElseThrow(()->new RuntimeException("Could not find food entry"));
        foodEntry.setCategory(category);
        if(grams <= 0)
        {
            throw new IllegalArgumentException("grams must be greater than 0");
        }
        foodEntry.setGrams(grams);
        return foodEntryRepository.save(foodEntry);
    }

    @Override
    public Optional<FoodEntry> findById(Long id) {
        return this.foodEntryRepository.findById(id);
    }

    @Override
    public void delete(FoodEntry foodEntry) {
        if(this.foodEntryRepository.existsById(foodEntry.getId()))
        {
            this.foodEntryRepository.delete(foodEntry);
        }
    }

}
