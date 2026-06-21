package com.webapp.calsleek.web;

import com.webapp.calsleek.model.DailyMacros;
import com.webapp.calsleek.model.Exercise;
import com.webapp.calsleek.model.ExerciseLog;
import com.webapp.calsleek.model.FoodEntry;
import com.webapp.calsleek.model.dtos.ExerciseLogDto;
import com.webapp.calsleek.model.dtos.FoodEntryDto;
import com.webapp.calsleek.services.DailyMacrosService;
import com.webapp.calsleek.services.ExerciseLogService;
import com.webapp.calsleek.services.FoodEntryService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/daily-macros")
public class DailyMacrosController {

    private final DailyMacrosService dailyMacrosService;
    private final FoodEntryService foodEntryService;
    private final ExerciseLogService exerciseLogService;

    public DailyMacrosController(DailyMacrosService dailyMacrosService, FoodEntryService foodEntryService, ExerciseLogService exerciseLogService) {
        this.dailyMacrosService = dailyMacrosService;
        this.foodEntryService = foodEntryService;
        this.exerciseLogService = exerciseLogService;
    }

//    @PostMapping("/{userId}")
//    public ResponseEntity<DailyMacros> createDailyMacros(@PathVariable Long userId, @RequestParam LocalDate date)
//    {
//        LocalDateTime dateTime=date.atStartOfDay();
//        DailyMacros dailyMacros=dailyMacrosService.save(dateTime,userId);
//        return ResponseEntity.ok(dailyMacros);
//    }
//
//    @GetMapping("/{userId}")
//    public ResponseEntity<DailyMacros> getDailyMacros(@PathVariable Long userId, @RequestParam LocalDate date) {
//        LocalDateTime dateTime=date.atStartOfDay();
//        DailyMacros dailyMacros=this.dailyMacrosService.findByUserIdAndDate(userId,dateTime);
//        if(dailyMacros!=null)
//            return ResponseEntity.ok(dailyMacros);
//        return ResponseEntity.notFound().build();
//    }
//
//
//    // Implement get by DailyMacrosId
//
//
//    @PostMapping("/{dailyMacrosId}/food-entries")
//    public ResponseEntity<FoodEntry> addFoodEntry(@PathVariable Long dailyMacrosId, @RequestBody FoodEntryDto foodEntryDto) {
//        FoodEntry foodEntry=this.foodEntryService.save(foodEntryDto.getCategory(),foodEntryDto.getFood(),foodEntryDto.getGrams());
//        this.dailyMacrosService.addFoodEntry(dailyMacrosId,foodEntry);
//        return ResponseEntity.ok(foodEntry);
//    }
//
//    @DeleteMapping("/{dailyMacrosId}/food-entries/{foodEntryId}")
//    public ResponseEntity<Void> removeFoodEntry(@PathVariable Long dailyMacrosId, @PathVariable Long foodEntryId) {
//        dailyMacrosService.removeFoodEntry(dailyMacrosId,foodEntryId);
//        return ResponseEntity.noContent().build();
//    }
//
//    @PostMapping("/{dailyMacrosId}/exercises")
//    public ResponseEntity<Void> addExerciseLog(@PathVariable Long dailyMacrosId,@RequestBody ExerciseLogDto exerciseLogDto) {
//        ExerciseLog exerciseLog=this.exerciseLogService.save(exerciseLogDto.getExerciseId(),exerciseLogDto.getDurationInMinutes(),exerciseLogDto.getDailyMacrosId());
//        this.dailyMacrosService.addExerciseLog(dailyMacrosId,exerciseLog);
//        return ResponseEntity.noContent().build();
//    }
//
//    @DeleteMapping("/{dailyMacrosId}/exercises/{exerciseLogId}")
//    public ResponseEntity<Void> removeExerciseLog(
//            @PathVariable Long dailyMacrosId,
//            @PathVariable Long exerciseLogId
//    ) {
//        dailyMacrosService.removeExerciseLog(dailyMacrosId, exerciseLogId);
//        return ResponseEntity.noContent().build();
//    }
//
//
//
//
//
//



    @GetMapping("/today/{userId}")
    public ResponseEntity<DailyMacros> getToday(@PathVariable Long userId){
        return ResponseEntity.ok(
                dailyMacrosService.getOrCreateToday(userId)
        );
    }

    @GetMapping("/date/{userId}")
    public ResponseEntity<DailyMacros> getByDate(
            @PathVariable Long userId,
            @RequestParam String date) {

        LocalDate parsedDate = LocalDate.parse(date);

        return ResponseEntity.ok(
                dailyMacrosService.findByUserIdAndDate(userId, parsedDate)
        );
    }


    @PostMapping("/{dailyMacrosId}/food-entries")
    public ResponseEntity<FoodEntry> addFoodEntry(
            @PathVariable Long dailyMacrosId,
            @RequestBody FoodEntryDto dto) {

        FoodEntry foodEntry = foodEntryService.save(
                dto.getCategory(),
                dto.getFoodId(),
                dto.getGrams()
        );

        dailyMacrosService.addFoodEntry(dailyMacrosId, foodEntry);

        return ResponseEntity.ok(foodEntry);
    }

    @DeleteMapping("/{dailyMacrosId}/food-entries/{foodEntryId}")
    public ResponseEntity<Void> removeFoodEntry(
            @PathVariable Long dailyMacrosId,
            @PathVariable Long foodEntryId
    ) {
        dailyMacrosService.removeFoodEntry(dailyMacrosId, foodEntryId);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{dailyMacrosId}/food-entries/{foodEntryId}")
    public ResponseEntity<Void> updateGrams(
            @PathVariable Long dailyMacrosId,
            @PathVariable Long foodEntryId,
            @RequestParam int grams
    ) {
        dailyMacrosService.updateFoodEntryGrams(
                dailyMacrosId,
                foodEntryId,
                grams
        );

        return ResponseEntity.ok().build();
    }

    @PostMapping("/{dailyMacrosId}/exercises")
    public ResponseEntity<Void> addExercise(
            @PathVariable Long dailyMacrosId,
            @RequestBody ExerciseLogDto dto
    ) {
        ExerciseLog log = exerciseLogService.save(
                dto.getExerciseId(),
                dto.getDurationInMinutes(),
                dailyMacrosId
        );

        dailyMacrosService.addExerciseLog(dailyMacrosId, log);

        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{dailyMacrosId}/exercises/{exerciseLogId}")
    public ResponseEntity<Void> removeExercise(
            @PathVariable Long dailyMacrosId,
            @PathVariable Long exerciseLogId
    ) {
        dailyMacrosService.removeExerciseLog(dailyMacrosId, exerciseLogId);
        return ResponseEntity.noContent().build();
    }

}
