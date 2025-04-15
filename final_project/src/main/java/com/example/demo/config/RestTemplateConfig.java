package com.example.demo.config;

import java.net.URI;
import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpRequest;
import org.springframework.http.client.support.HttpRequestWrapper;
import org.springframework.web.client.RestTemplate;

@Configuration
public class RestTemplateConfig {

    @Bean
    public RestTemplate restTemplate() {
        RestTemplate restTemplate = new RestTemplate();

        restTemplate.setInterceptors(List.of((request, body, execution) -> {
            URI originalUri = request.getURI();
            String originalUrl = originalUri.toString();
            
            String serviceKey = "0MHNpRPQr0BonjfZozHtGZWjNLitvGLKjNT%2BW6nBSCYW2Zz7e5ro7gq%2FMRKLoP%2FcNmbAAErU2AgWo2LvLGiIfA%3D%3D";
        	
            // 인코딩되지 않은 원본 키를 수동으로 붙이기
            String finalUrl = originalUrl + "&serviceKey=" + serviceKey;

            //System.out.println("최종 요청 URL: " + finalUrl);

            // URI 객체로 다시 생성
            URI updatedUri = URI.create(finalUrl);

            //System.out.println("최종 요청 URI: " + updatedUri);
            
            // URI를 request에 반영
            HttpRequest modifiedRequest = new HttpRequestWrapper(request) {
                @Override
                public URI getURI() {
                    return updatedUri;
                }
            };
            
            return execution.execute(modifiedRequest, body);
        }));
        return restTemplate;
    }
}
