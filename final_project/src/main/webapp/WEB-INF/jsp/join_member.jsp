<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>소담여행 - 회원가입</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #faf5f9;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .logo-container {
            position: absolute;
            top: 20px;
            left: 20px;
        }

        .logo-container img {
            width: 150px;
            height: auto;
        }

        .join-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            width: 400px;
        }

        .join-title {
            text-align: center;
            margin-bottom: 30px;
            font-size: 24px;
            color: #333;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .join-title .emoji {
            font-size: 28px;
        }

        .input-group {
            margin-bottom: 20px;
        }

        .input-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .input-group input:focus {
            outline: none;
            border-color: #4CAF50;
        }

        .input-group input::placeholder {
            color: #999;
        }

        .submit-btn {
            width: 100%;
            padding: 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .submit-btn:hover {
            background-color: #45a049;
        }

        .social-login {
            margin-top: 30px;
            text-align: center;
        }

        .social-login p {
            color: #666;
            margin-bottom: 15px;
        }

        .social-buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        .kakao-login-btn {
            padding: 10px 20px;
            background-color: #FEE500;
            color: #000000;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }

        .validation-message {
            color: #ff0000;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        
        .error-message {
            color: #ff0000;
            font-size: 14px;
            margin-bottom: 15px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="logo-container">
        <img src="/images/sodam_logo.png" alt="소담여행 로고">
    </div>

    <div class="join-container">
        <h2 class="join-title">
            <span>회원가입</span>
            <span class="emoji">😊</span>
        </h2>

        <!-- 에러 메시지 표시 -->
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <form action="/join" method="POST" id="joinForm">
            <div class="input-group">
                <input type="text" name="name" id="name" placeholder="이름" required>
                <div class="validation-message" id="nameValidation">이름을 입력해주세요.</div>
            </div>

            <div class="input-group">
                <input type="text" name="nickname" id="nickname" placeholder="닉네임" required>
                <div class="validation-message" id="nicknameValidation">닉네임을 입력해주세요.</div>
            </div>
            
            <div class="input-group">
                <input type="email" name="email" id="email" placeholder="이메일" required>
                <div class="validation-message" id="emailValidation">올바른 이메일 형식이 아닙니다.</div>
            </div>

            <div class="input-group">
                <input type="tel" name="phone" id="phone" placeholder="전화번호 (예: 010-1234-5678)" required>
                <div class="validation-message" id="phoneValidation">올바른 전화번호 형식이 아닙니다.</div>
            </div>

            <div class="input-group">
                <input type="password" name="password" id="password" placeholder="비밀번호" required>
                <div class="validation-message" id="passwordValidation">비밀번호는 8자 이상이어야 합니다.</div>
            </div>

            <button type="submit" class="submit-btn">회원가입</button>
        </form>

        <div class="social-login">
            <p>소셜 계정으로 간편 가입</p>
            <div class="social-buttons">
                <button type="button" class="kakao-login-btn" onclick="kakaoLogin()">
                    <img src="/images/kakao_icon.png" alt="카카오 아이콘" style="width: 20px; height: 20px;">
                    카카오 로그인
                </button>
            </div>
        </div>
    </div>

    <script>
        // 폼 유효성 검사
        const joinForm = document.getElementById('joinForm');
        
        joinForm.addEventListener('submit', function(e) {
            let isValid = true;
            
            // 이름 검사
            const name = document.getElementById('name').value;
            if (name.trim() === '') {
                document.getElementById('nameValidation').style.display = 'block';
                isValid = false;
            }
            
            // 이메일 형식 검사
            const email = document.getElementById('email').value;
            const emailRegex = /^[A-Za-z0-9+_.-]+@(.+)$/;
            if (!emailRegex.test(email)) {
                document.getElementById('emailValidation').style.display = 'block';
                isValid = false;
            }

            // 전화번호 형식 검사
            const phone = document.getElementById('phone').value;
            const phoneRegex = /^010-\d{4}-\d{4}$/;
            if (!phoneRegex.test(phone)) {
                document.getElementById('phoneValidation').style.display = 'block';
                isValid = false;
            }

            // 비밀번호 검사
            const password = document.getElementById('password').value;
            if (password.length < 8) {
                document.getElementById('passwordValidation').style.display = 'block';
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
            }
        });

        // 입력 필드 포커스시 에러 메시지 숨기기
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('focus', function() {
                const validationMessage = this.nextElementSibling;
                if (validationMessage.classList.contains('validation-message')) {
                    validationMessage.style.display = 'none';
                }
            });
        });

        // 카카오 로그인 함수
        function kakaoLogin() {
            // 카카오 로그인 API 연동 코드 구현
            alert('카카오 로그인 기능 준비중입니다.');
        }
    </script>
</body>
</html>