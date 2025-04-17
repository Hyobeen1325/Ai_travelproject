<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI 국내여행 플래너</title>
    <style>
       @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap');
        
        body {
            margin: 0;
            padding: 0;
            font-family: 'Noto Sans KR', sans-serif;
            background: linear-gradient(rgba(100, 149, 237, 0.7), rgba(100, 149, 237, 0.7)),
                        url('C:/cursor/background.jpg');
            background-size: cover;
            background-position: center;
            min-height: 100vh;
            position: relative;
            overflow: hidden;
        }

        .background-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 30%;
            background-image: url('C:/cursor/cityscape.png');
            background-size: contain;
            background-repeat: repeat-x;
            background-position: bottom;
            opacity: 0.5;
        }

        .stars {
            position: absolute;
            width: 100%;
            height: 100%;
            pointer-events: none;
        }

        .star {
            position: absolute;
            background-color: #fff;
            width: 2px;
            height: 2px;
            border-radius: 50%;
            animation: twinkle 1.5s infinite;
        }

        @keyframes twinkle {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.3; }
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 40px;
        }

        .logo {
            width: 180px;
            height: auto;
        }

        .logout-btn {
            background-color: transparent;
            border: 2px solid #fff;
            color: #fff;
            padding: 8px 20px;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 16px;
        }

        .logout-btn:hover {
            background-color: #fff;
            color: #4a90e2;
        }

        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            min-height: calc(100vh - 100px);
            text-align: center;
            position: relative;
            z-index: 1;
            padding-top: 30px;
        }

        .welcome-text {
            color: #fff;
            margin-bottom: 10px;
        }

        .welcome-title {
            font-size: 48px;
            font-weight: 700;
            margin: 0 0 10px 0;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }

        .welcome-subtitle {
            font-size: 24px;
            font-weight: 500;
            margin: 0 0 20px 0;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
        }

        .welcome-description {
            font-size: 18px;
            line-height: 1.6;
            max-width: 600px;
            margin: 0 auto;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
        }

        .robot-character {
            width: 200px;
            height: 200px;
            margin: 20px 0;
            background-image: url('C:/cursor/robot.png');
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }

        .start-button {
            margin-bottom: 40px;
            padding: 15px 60px;
            font-size: 24px;
            background-color: #fff;
            color: #4a90e2;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            font-weight: 700;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .start-button:hover {
            transform: translateX(10px);
            background-color: #4a90e2;
            color: #fff;
        }

        .start-button::after {
            content: '→';
            position: absolute;
            right: -30px;
            top: 50%;
            transform: translateY(-50%);
            opacity: 0;
            transition: all 0.3s ease;
        }

        .start-button:hover::after {
            right: 20px;
            opacity: 1;
        }
    </style>
</head>
<body>
    <div class="stars"></div>
    <div class="background-overlay"></div>
    
    <div class="header">
        <img src="image/logo.png" class="logo" alt="대한민국 구석구석">
        <button class="logout-btn" onclick="location.href='<c:url value='/login.jsp'/>'">로그아웃</button>
    </div>

    <div class="container">
        <div class="welcome-text">
            <div class="welcome-title"><h2>Welcome</h2></div>
            <div class="welcome-subtitle"><h3>${sessionScope.user.nickname}님! 안녕하세요.</h3></div>
            <div class="welcome-description">
                AI국내여행 플래너, 소담 여행에 오신 것을 환영합니다.<br>
                국내 여행을 계획 중이신가요?<br>
                여행을 떠날 지역, 기간, 테마만 알려주시면<br>
                저희가 맞춤형 코스를 만들어 드립니다.
            </div>
        </div>       
        <div><h3></h3></div>
        <button class="start-button" onclick="location.href='/mainarea/regions'">
    		START
		</button>
    </div>

    <script>
        // 반짝이는 별 효과 생성
        function createStars() {
            const starsContainer = document.querySelector('.stars');
            const numberOfStars = 3000;

            for (let i = 0; i < numberOfStars; i++) {
                const star = document.createElement('div');
                star.className = 'star';
                star.style.left = `${Math.random() * 100}%`;
                star.style.top = `${Math.random() * 100}%`;
                star.style.animationDelay = `${Math.random() * 2}s`;
                starsContainer.appendChild(star);
            }
        }

        // 페이지 로드 시 별 생성
        window.addEventListener('load', createStars);

        // 로그인 상태 확인
       // <c:if test="${empty sessionScope.user}">
        //    location.href = '/#';
       // </c:if>
    </script>
</body>
</html> 