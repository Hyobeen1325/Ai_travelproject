package com.example.demo.config;

import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpRequest;
import org.springframework.http.client.ClientHttpRequestExecution;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.http.client.support.HttpRequestWrapper;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.http.converter.xml.MappingJackson2XmlHttpMessageConverter;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

@Configuration
public class RestTemplateConfig {

    @Bean
    public RestTemplate restTemplate() {
        RestTemplate restTemplate = new RestTemplate();

        List<HttpMessageConverter<?>> converters = new ArrayList<>();
        //converters.add(new Jaxb2RootElementHttpMessageConverter());	   // XML 메시지 컨버터 추가
        converters.add(new MappingJackson2XmlHttpMessageConverter());  // XML 지원 추가
        converters.add(new MappingJackson2HttpMessageConverter());     // JSON도 여전히 지원

        restTemplate.setMessageConverters(converters);
        
        restTemplate.setInterceptors(List.of((request, body, execution) -> {
            URI originalUri = request.getURI();
            String originalUrl = originalUri.toString();

            // 서비스 키 문자열을 인코딩 없이 직접 붙이기
            String serviceKey = "0MHNpRPQr0BonjfZozHtGZWjNLitvGLKjNT%2BW6nBSCYW2Zz7e5ro7gq%2FMRKLoP%2FcNmbAAErU2AgWo2LvLGiIfA%3D%3D";
            String updatedUrl;

            // serviceKey가 붙어 있지 않다면 추가
            if (!originalUrl.contains("serviceKey=")) {
                if (originalUrl.contains("?")) {
                    updatedUrl = originalUrl + "&serviceKey=" + serviceKey;
                } else {
                    updatedUrl = originalUrl + "?serviceKey=" + serviceKey;
                }
            } else {
                updatedUrl = originalUrl;  // 이미 있으면 그대로
            }

            //System.out.println("최종 요청 URL: " + updatedUrl);

            // 새로운 URI로 교체
            HttpRequest modifiedRequest = new HttpRequestWrapper(request) {
                @Override
                public URI getURI() {
                    return URI.create(updatedUrl); // 문자열로 직접 만든 URI
                }
            };

            return execution.execute(modifiedRequest, body);
        }));
        return restTemplate;
    }
}
