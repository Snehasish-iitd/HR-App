package com.HR.app.Config;



import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter@Setter
@AllArgsConstructor
@NoArgsConstructor

@Component
@ConfigurationProperties(prefix = "file.storage")
public class FileStorageConfig {
    
    private String provider = "google_drive"; // default
    private String googleDriveCredentialsPath;
    private String localStoragePath;
    
}
   
