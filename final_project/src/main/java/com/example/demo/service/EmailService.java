package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService{ // 비밀번호 찾기

    @Autowired
    private JavaMailSender mailSender; // 이메일 처리 객체

    public void sendEmail(String to, String subject, String body) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, "UTF-8"); // UTF-8 인코딩 설정

            helper.setTo(to); // 수신인 (이메일)
            helper.setSubject(subject); // 제목
            helper.setText(body); // 본문 내용 : 임시 비밀번호

            // 발신자 설정 (닉네임과 이메일 주소)
            String sentFrom = "소담여행 <wsxy70866@gmail.com>"; // 닉네임 <이메일 주소> 형식
            helper.setFrom(new InternetAddress(sentFrom));

            mailSender.send(message); // 이메일 발송

        } catch (Exception e) {
            e.printStackTrace();
            // 이메일 발송 실패 처리
        }
    }
}