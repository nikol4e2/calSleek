package com.webapp.calsleek.web;

import com.webapp.calsleek.model.Food;
import com.webapp.calsleek.model.User;
import com.webapp.calsleek.model.dtos.FoodDto;
import com.webapp.calsleek.services.FoodService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/api/food")
public class FoodController {

    private final FoodService foodService;

    //TODO Create UserService
    private final UserService userService;


    public FoodController(FoodService foodService,UserService userService) {
        this.foodService = foodService;
        this.userService = userService;
    }

    @GetMapping
    public ResponseEntity<List<Food>> getAll() {
        return ResponseEntity.ok(this.foodService.getAll());
    }


    @GetMapping("/{id}")
    public ResponseEntity<Food> getById(@PathVariable Long id) {
        Optional<Food> food=foodService.getById(id);
        return food.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }



    //Send null as UserId if the administrator is creating the food
    @PostMapping
    public ResponseEntity<Food> createFood(@RequestBody FoodDto foodDto) {
        User user = null;
        boolean isVerified = true;

        if (foodDto.getUserId() != null) {

            //IMPORT WHEN USERSERVICE IS CREATED
            user = userService.findById(foodDto.getUserId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
            isVerified = false; // Храна од корисник — не е верифицирана
        }

        Food food = foodService.saveFood(
                foodDto.getName(),
                foodDto.getBrand(),
                foodDto.getCalories(),
                foodDto.getCarbs(),
                foodDto.getProtein(),
                foodDto.getFat(),
                user,
                isVerified
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(food);


    }

    @PutMapping("/{id}")
    public ResponseEntity<Food> editFood(@PathVariable Long id, @RequestBody FoodDto foodDto) {
        Food food = foodService.editFood(id,foodDto.getName(),foodDto.getBrand(),foodDto.getCalories(),foodDto.getCarbs(),foodDto.getProtein(),foodDto.getFat());
        return ResponseEntity.ok(food);
    }

    @PostMapping("/verify/{id}")
    public ResponseEntity<Void> verify(@PathVariable Long id) {
        this.foodService.verifyFood(id);
        return ResponseEntity.noContent().build();
    }


    @DeleteMapping("/{id}/delete")
    public ResponseEntity<Void> deleteFood(@PathVariable Long id) {
        this.foodService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/search")
    public ResponseEntity<List<Food>> search(@RequestParam String searchText){
        List<Food> foods=this.foodService.getAllByNameOrBrand(searchText);
        if(!foods.isEmpty())
        {
            return ResponseEntity.ok(foods);
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/created-by/{userId}")
    public ResponseEntity<List<Food>> getAllCreatedBy(@PathVariable Long userId) {
        List<Food> foods=this.foodService.getAllCreatedByUser(userId);
        if(!foods.isEmpty())
        {
            return ResponseEntity.ok(foods);
        }
        return ResponseEntity.notFound().build();
    }


}
