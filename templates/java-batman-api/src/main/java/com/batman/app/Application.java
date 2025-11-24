package com.batman.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

@RestController
@RequestMapping("/api/v1/health")
class HealthController {

    @GetMapping
    public HealthResponse health() {
        return new HealthResponse("BATMAN-ONLINE", "Gotham backend is up");
    }

    public record HealthResponse(String status, String message) {}
}
