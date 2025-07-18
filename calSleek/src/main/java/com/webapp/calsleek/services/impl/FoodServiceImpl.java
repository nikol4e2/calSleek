package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.Food;
import com.webapp.calsleek.model.User;
import com.webapp.calsleek.model.exceptions.FoodNotFoundException;
import com.webapp.calsleek.model.exceptions.UserNotFoundException;
import com.webapp.calsleek.repositories.FoodRepository;
import com.webapp.calsleek.repositories.UserRepository;
import com.webapp.calsleek.services.FoodService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FoodServiceImpl implements FoodService {

    private final FoodRepository foodRepository;
    private final UserRepository userRepository;


    public FoodServiceImpl(FoodRepository foodRepository, UserRepository userRepository) {
        this.foodRepository = foodRepository;
        this.userRepository = userRepository;
    }


    @Override
    public Food saveFood(String name, String brand, int calories, int carbs, int protein, int fat, User createdBy, boolean isVerified) {
        if (name == null || name.isEmpty() || brand == null || brand.isEmpty()) {
            throw new IllegalArgumentException("Name or Brand cannot be null or empty");
        }
        if(!areNutrientsValid(calories,carbs,protein,fat))
        {
            throw new IllegalArgumentException("The nutrients values aren't adding up");
        }
        Food food=null;

        if(createdBy == null)
        {
            food = new Food(name,brand,calories,carbs,protein,fat,true,null);
        }else
        {
            food=new Food(name,brand,calories,carbs,protein,fat,false,createdBy);
        }
        this.foodRepository.save(food);
        return food;

    }

    @Override
    public Food editFood(Long id, String name, String brand, int calories, int carbs, int protein, int fat, User createdBy, boolean isVerified) {
        Food food=this.foodRepository.findById(id).orElseThrow(() -> new FoodNotFoundException(id));
        food.setName(name);
        food.setBrand(brand);
        if(areNutrientsValid(calories,carbs,protein,fat))
        {
            food.setCalories(calories);
            food.setCarbs(carbs);
            food.setProtein(protein);
            food.setFats(fat);
        }
        this.foodRepository.save(food);
        return food;
    }

    @Override
    public void verifyFood(Long id) {
        Food food=this.foodRepository.findById(id).orElseThrow(() -> new FoodNotFoundException(id));
        food.setVerified(true);
        this.foodRepository.save(food);

    }

    @Override
    public void deleteById(Long id) {
        if(this.foodRepository.existsById(id))
        {
           this.foodRepository.deleteById(id);
        }
    }

    @Override
    public List<Food> getAllByNameOrBrand(String search) {
       return this.foodRepository.findAllByNameContainingIgnoreCaseOrBrandContainingIgnoreCase(search,search);
    }

    @Override
    public List<Food> getAllCreatedByUser(Long userId) {
        User user=this.userRepository.findById(userId).orElseThrow(()->new UserNotFoundException());
        return this.foodRepository.findAllByCreatedBy(user);
    }


    private boolean areNutrientsValid(int calories, int carbs, int proteins, int fats) {
        return calories >= (carbs * 4 + proteins * 4 + fats * 9);
    }
}
