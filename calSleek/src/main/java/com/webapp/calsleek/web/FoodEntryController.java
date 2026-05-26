package com.webapp.calsleek.web;

import com.webapp.calsleek.model.FoodEntry;
import com.webapp.calsleek.model.dtos.FoodEntryDto;
import com.webapp.calsleek.services.DailyMacrosService;
import com.webapp.calsleek.services.FoodEntryService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/food/entry")
public class FoodEntryController {


    private final FoodEntryService foodEntryService;
    private final DailyMacrosService dailyMacrosService;

    public FoodEntryController(FoodEntryService foodEntryService, DailyMacrosService dailyMacrosService) {
        this.foodEntryService = foodEntryService;
        this.dailyMacrosService = dailyMacrosService;
    }



    @GetMapping("/{id}")
    public ResponseEntity<FoodEntry> findById(@PathVariable Long id) {
        return this.foodEntryService.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<FoodEntry>> findByUserId(@PathVariable Long userId,@DateTimeFormat(iso = DateTimeFormat.ISO.DATE) @RequestParam LocalDate date) {

        List<FoodEntry> foodEntries=dailyMacrosService.getFoodEntriesForUserAndDate(userId, date);
        return ResponseEntity.ok(foodEntries);
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
