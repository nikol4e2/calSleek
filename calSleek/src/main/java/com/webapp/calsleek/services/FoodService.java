package com.webapp.calsleek.services;

import com.webapp.calsleek.model.Food;
import com.webapp.calsleek.model.User;

import java.util.List;
import java.util.Optional;

public interface FoodService {
    Food saveFood(String name, String brand, int calories, int carbs, int protein, int fat, User createdBy, boolean isVerified);
    Food editFood(Long id, String name, String brand, int calories, int carbs, int protein, int fat);
    void deleteById(Long id);
    Optional<Food> getById(Long id);
    List<Food> getAllByNameOrBrand(String search);
    List<Food> getAllCreatedByUser(Long userId);
    List<Food> getAll();
    void verifyFood(Long id);
}
