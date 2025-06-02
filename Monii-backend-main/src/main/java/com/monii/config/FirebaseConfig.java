package com.monii.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import javax.annotation.PostConstruct;
import java.io.InputStream;
import java.io.IOException;

@Configuration
public class FirebaseConfig {

    @PostConstruct
    public void init() {
        try {
            // Load the service account file from classpath
            InputStream serviceAccount = getClass().getClassLoader().getResourceAsStream("monii-1873-firebase-adminsdk-fbsvc-a5464e3386.json");

            if (serviceAccount == null) {
                throw new IOException("Firebase service account file not found in classpath");
            }

            // Initialize Firebase only if not already initialized
            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseOptions options = new FirebaseOptions.Builder()
                        .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                        .build();
                FirebaseApp.initializeApp(options);
                System.out.println("✅ FirebaseApp initialized successfully");
            }
        } catch (IOException e) {
            // Print full stack trace for better error diagnosis
            e.printStackTrace();
            System.err.println("❌ Firebase initialization error: " + e.getMessage());
        }
    }

    // Optional: You can expose FirebaseApp as a bean if needed
    @Bean
    public FirebaseApp firebaseApp() throws IOException {
        // Ensure Firebase is initialized before returning the instance
        if (FirebaseApp.getApps().isEmpty()) {
            InputStream serviceAccount = getClass().getClassLoader().getResourceAsStream("monii-1873-firebase-adminsdk-fbsvc-a5464e3386.json");
            FirebaseOptions options = new FirebaseOptions.Builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();
            return FirebaseApp.initializeApp(options);
        }
        return FirebaseApp.getInstance();
    }
}
