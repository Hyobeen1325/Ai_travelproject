<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<jsp:include page="header.jsp" />
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI 국내여행 플래너</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: linear-gradient(rgba(100, 149, 237, 0.7), rgba(100, 149, 237, 0.7)),
                        url('C:/cursor/background.jpg');
            background-size: cover;
            background-position: center;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
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
        
        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            text-align: center;
            position: relative;
            z-index: 1;
            padding: 0 20px;
        }
        
        .welcome-text {
            color: #fff;
            margin-bottom: 40px;
            max-width: 800px;          
        }
        
        .welcome-title {
            font-size: 100px;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }
        .welcome-subtitle{
        	font-size: 60px;
        	font-weight: 400;
        }
        
        .welcome-description {
            font-size: 18px;
            line-height: 1.8;
            margin: 0 auto;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
        }
        
        .start-button {
            margin: 30px 0;
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
        
        /* 특징 섹션 */
        .features {
            padding: 80px 0;
            background-color: #fff;
            width: 100%;
            margin-bottom: 0; /* 하단 여백 제거 */
        }
        
        .features-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .footer-wrapper {
            width: 100%;
            background-color: #f8f9fa;
            position: relative;
            z-index: 2;
        }
        .section-title {
            text-align: center;
            font-size: 2.5rem;
            margin-bottom: 60px;
            color: #333;
            position: relative;
        }
        
        .section-title:after {
            content: '';
            position: absolute;
            width: 80px;
            height: 4px;
            background-color: #6495ED;
            bottom: -15px;
            left: 50%;
            transform: translateX(-50%);
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
        }
        
        .feature-card {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            text-align: center;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        }
        
        .feature-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background-color: #a8c6ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6495ED;
            font-size: 2rem;
        }
        
        .feature-title {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: #333;
        }
        
        .feature-description {
            color: #666;
            line-height: 1.6;
        }
        
        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .welcome-title {
                font-size: 40px;
            }
            
            .welcome-description {
                font-size: 16px;
            }
            
            .start-button {
                padding: 12px 40px;
                font-size: 20px;
            }
            
            .section-title {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="stars"></div>
    <div class="background-overlay"></div>
    
    <div class="container">
        <div class="welcome-text">
            <h1 class="welcome-title">Welcome</h1>
            <h2 class="welcome-subtitle">${sessionScope.SessionMember.name} 님!</h2>
            <h3 class="welcome-text">  </h3>
            <p class="welcome-description">
                AI국내여행 플래너, 소담 여행에 오신 것을 환영합니다.<br>
                국내 여행을 계획 중이신가요?<br>
                여행을 떠날 지역, 기간, 테마만 알려주시면<br>
                저희가 맞춤형 코스를 만들어 드립니다.
            </p>
        </div>
        
        <button class="start-button" onclick="location.href='/mainarea/regions'">
            START
        </button>
    </div>
    
    <!-- 특징 섹션 -->
    <section class="features">
        <div class="features-container">
            <h2 class="section-title">소담 여행의 특별함</h2>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">🎯</div>
                    <h3 class="feature-title">맞춤형 여행 코스</h3>
                    <p class="feature-description">AI가 분석하여 당신의 취향과 상황에 맞는 최적의 여행 코스를 제안합니다.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🗺️</div>
                    <h3 class="feature-title">다양한 여행지 정보</h3>
                    <p class="feature-description">전국 각지의 숨은 명소부터 인기 관광지까지 폭넓은 여행 정보를 제공합니다.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">⏱️</div>
                    <h3 class="feature-title">시간 절약</h3>
                    <p class="feature-description">여행 계획에 소요되는 시간을 줄이고, 더 많은 여행 경험을 즐길 수 있습니다.</p>
                </div>
            </div>
        </div>
    </section>
    <div class="footer-wrapper">
        <jsp:include page="header2.jsp" />
    </div>
    <script>
        // 반짝이는 별 효과 생성
        function createStars() {
            const starsContainer = document.querySelector('.stars');
            const numberOfStars = 300;
            
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
         <c:if test="${empty sessionScope.SessionMember.email}">
      	 location.href = '/login';
         </c:if>
    </script>   
   
</body>
</html> 