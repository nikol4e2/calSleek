package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.Food;
import com.webapp.calsleek.model.FoodEntry;
import com.webapp.calsleek.model.User;
import com.webapp.calsleek.model.enums.TimeCategory;
import com.webapp.calsleek.repositories.FoodEntryRepository;
import com.webapp.calsleek.repositories.FoodRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class FoodEntryServiceImpl implements com.webapp.calsleek.services.FoodEntryService {

    private final FoodEntryRepository foodEntryRepository;
    private final FoodRepository foodRepository;


    public FoodEntryServiceImpl(FoodEntryRepository foodEntryRepository, FoodRepository foodRepository) {
        this.foodEntryRepository = foodEntryRepository;
        this.foodRepository = foodRepository;
    }


    @Override
    public FoodEntry save(TimeCategory category, Long foodId, int grams) {
        Food food = foodRepository.findById(foodId).orElseThrow(()->new RuntimeException("Food not found"));
        if(grams <= 0)
        {
            throw new IllegalArgumentException("Grams must be greater than 0");
        }
        float multiplier= grams / 100.0f;

        FoodEntry foodEntry = new FoodEntry();
        foodEntry.setCategory(category);
        foodEntry.setFood(food);
        foodEntry.setGrams(grams);

        foodEntry.setTotalCalories(Math.round(food.getCalories() * multiplier));
        foodEntry.setTotalCarbs(Math.round(food.getCarbs() * multiplier));
        foodEntry.setTotalProtein(Math.round(food.getProtein() * multiplier));
        foodEntry.setTotalFats(Math.round(food.getFats() * multiplier));

        return foodEntryRepository.save(foodEntry);
    }

    @Override
    public FoodEntry edit(Long id, TimeCategory category, int grams) {
        FoodEntry foodEntry = foodEntryRepository.findById(id).orElseThrow(()->new RuntimeException("Could not find food entry"));
        foodEntry.setCategory(category);
        if(grams <= 0)
        {
            throw new IllegalArgumentException("Grams must be greater than 0");
        }
        foodEntry.setGrams(grams);
        return foodEntryRepository.save(foodEntry);
    }

    @Override
    public Optional<FoodEntry> findById(Long id) {
        return this.foodEntryRepository.findById(id);
    }

    @Override
    public void deleteById(Long id) {
        if(this.foodEntryRepository.existsById(id))
        {
            this.foodEntryRepository.deleteById(id);
        }

    }



}
