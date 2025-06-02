package com.monii.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class OpenAIService {

    @Value("${openai.api.key}")
    private String apiKey;

    private final String OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";  // Updated API URL

    private final RestTemplate restTemplate;

    public OpenAIService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public String getFinancialAdvice(String prompt, int maxTokens) {
        String requestBody = buildRequestBody(prompt, maxTokens);

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + apiKey);
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);

        ResponseEntity<String> response = restTemplate.exchange(OPENAI_API_URL, HttpMethod.POST, entity, String.class);

        return parseFinancialAdvice(response.getBody());
    }

    private String buildRequestBody(String prompt, int maxTokens) {
        return "{"
                + "\"model\": \"gpt-3.5-turbo\", "  // Or gpt-4 depending on the model you're using
                + "\"messages\": [{\"role\": \"user\", \"content\": \"" + prompt + "\"}], "
                + "\"max_tokens\": " + maxTokens
                + "}";
    }

    private String parseFinancialAdvice(String responseBody) {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode root = objectMapper.readTree(responseBody);

            return root.path("choices").get(0).path("message").path("content").asText().trim();
        } catch (Exception e) {
            e.printStackTrace();
            return "Error parsing response from OpenAI.";
        }
    }
}
