package com.monii.controller;

import com.monii.dto.request.MessageRequest;
import com.monii.service.OpenAIService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/openai")
public class OpenAIController {

    private final OpenAIService openAIService;

    public OpenAIController(OpenAIService openAIService) {
        this.openAIService = openAIService;
    }

    @PostMapping("/get-financial-advice")
    public ResponseEntity<String> getAdvice(@RequestBody MessageRequest request) {
        String advice = openAIService.getFinancialAdvice(request.getMessage(), 200);
        if (advice == null || advice.isEmpty()) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Unable to get advice");
        }
        return ResponseEntity.ok(advice);
    }
}
