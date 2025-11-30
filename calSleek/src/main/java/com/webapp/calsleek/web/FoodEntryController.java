package com.webapp.calsleek.web;

import com.webapp.calsleek.model.FoodEntry;
import com.webapp.calsleek.model.dtos.FoodEntryDto;
import com.webapp.calsleek.services.FoodEntryService;
import com.webapp.calsleek.services.impl.FoodEntryServiceImpl;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/food/entry")
public class FoodEntryController {


    private final FoodEntryService foodEntryService;

    public FoodEntryController(FoodEntryService foodEntryService) {
        this.foodEntryService = foodEntryService;
    }



    @GetMapping("/{id}")
    public ResponseEntity<FoodEntry> findById(@PathVariable Long id) {
        return this.foodEntryService.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<FoodEntry>> findByUserId(@PathVariable Long userId, @RequestParam LocalDateTime date) {
        List<FoodEntry> foodEntries=this.foodEntryService.getAllForUserAndDate(userId,date);
        if(foodEntries.isEmpty())
            return ResponseEntity.notFound().build();
        return ResponseEntity.ok(foodEntries);
    }


    @PostMapping
    public ResponseEntity<FoodEntry> createFoodEntry(@RequestBody FoodEntryDto foodEntryDto) {

        FoodEntry foodEntry = this.foodEntryService.save(foodEntryDto.getCategory(), foodEntryDto.getFood(), foodEntryDto.getGrams());
        return ResponseEntity.ok(foodEntry);


    }


    @PutMapping("/{id}")
    public ResponseEntity<FoodEntry> editFoodEntry(@RequestBody FoodEntryDto foodEntryDto, @PathVariable Long id) {
        FoodEntry foodEntry=this.foodEntryService.findById(id).orElseThrow(()-> new RuntimeException("Error: FoodEntry not found"));
        this.foodEntryService.edit(id,foodEntryDto.getCategory(),foodEntryDto.getGrams());
        return ResponseEntity.ok(foodEntry);
    }



    @DeleteMapping("/{id}")
    public ResponseEntity<FoodEntry> deleteFoodEntry(@PathVariable Long id) {
        this.foodEntryService.deleteById(id);
        if(this.foodEntryService.findById(id).isPresent()){
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.noContent().build();
    }





}
