package com.webapp.calsleek.web;


import com.webapp.calsleek.model.User;
import com.webapp.calsleek.model.dtos.secuirty.AuthResponse;
import com.webapp.calsleek.model.dtos.secuirty.LoginRequest;
import com.webapp.calsleek.model.dtos.secuirty.RegisterRequest;
import com.webapp.calsleek.model.dtos.secuirty.UserResponse;
import com.webapp.calsleek.model.exceptions.InvalidUserCredentialsException;
import com.webapp.calsleek.model.exceptions.PasswordsDoNotMatchException;
import com.webapp.calsleek.model.exceptions.UserNameAlreadyExists;
import com.webapp.calsleek.security.JwtTokenProvider;
import com.webapp.calsleek.security.UserPrincipal;
import com.webapp.calsleek.services.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService userService;
    private final JwtTokenProvider jwtTokenProvider;

    public AuthController(UserService userService, JwtTokenProvider jwtTokenProvider) {
        this.userService = userService;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody RegisterRequest req) {
        try {
            User user=userService.register(
                    req.getUsername(),
                    req.getFirstName(),
                    req.getLastName(),
                    req.getEmail(),
                    req.getPassword(),
                    req.getRepeatPassword()
            );

            String token= jwtTokenProvider.generateToken(user);
            return ResponseEntity.status(201).body(new AuthResponse(token,user.getId(),user.getUsername()));
        } catch (UserNameAlreadyExists e) {
            return ResponseEntity.status(409).body(java.util.Map.of("error", "Username already exists"));
        } catch (PasswordsDoNotMatchException e) {
            return ResponseEntity.status(400).body(java.util.Map.of("error", "Passwords do not match"));
        } catch (InvalidUserCredentialsException e) {
            return ResponseEntity.status(400).body(java.util.Map.of("error", "Invalid credentials"));

        }
    }


    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody LoginRequest req) {
        try {
            User user=userService.login(req.getUsername(), req.getPassword());
            String token= jwtTokenProvider.generateToken(user);
            return ResponseEntity.ok(new AuthResponse(token,user.getId(),user.getUsername()));
        }catch (InvalidUserCredentialsException e) {
            return ResponseEntity.status(401).body(java.util.Map.of("error", "Invalid credentials"));
        }
    }

    @GetMapping("/me")
    public ResponseEntity<?> me(Authentication auth) {
        if(auth==null || !(auth.getPrincipal() instanceof User))
        {
            return ResponseEntity.status(401).build();
        }
        UserPrincipal up=(UserPrincipal)auth.getPrincipal();
        User user=up.getUser();
        return ResponseEntity.ok(new UserResponse(user.getId(), user.getUsername(), user.getFirstName(), user.getLastName(), user.getEmail()));
    }
}
