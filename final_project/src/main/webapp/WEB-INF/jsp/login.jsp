<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Login</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #e6f3ff;
      overflow-x: hidden;
    }

    .container {
      width: 40%;
      margin: 0 auto;
      padding: 20px;
    }

    .logo-container {
      padding: 10px 0;
      margin-bottom: 20px;
      text-align: center;
    }

    .logo {
      width: 200px;
      height: auto;
    }

    .login-box {
      background-color: white;
      border-radius: 15px;
      padding: 30px;
      margin: 10px auto;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      max-width: 400px;
      text-align: center;
    }

    .login-title {
      font-size: 26px;
      font-weight: 600;
      margin-bottom: 20px;
      color: #333;
    }

    .welcome-message {
      text-align: center;
      color: #1a2b4d;
      font-size: 14px;
      margin-bottom: 20px;
    }

    .highlight {
      color: #4a90e2;
    }

    .login-form {
      display: flex;
      flex-direction: column;
      align-items: stretch;
    }

    .login-input {
      width: 100%;
      padding: 10px;
      margin-bottom: 12px;
      border: 1px solid #e0e0e0;
      border-radius: 10px;
      font-size: 14px;
      transition: all 0.3s ease;
      box-sizing: border-box;
    }

    .login-input:focus {
      border-color: #4a90e2;
      box-shadow: 0 0 5px rgba(74, 144, 226, 0.3);
    }

    .login-button {
      width: 100%;
      padding: 10px 30px;
      font-size: 16px;
      background-color: #4a90e2;
      color: white;
      border: none;
      border-radius: 20px;
      cursor: pointer;
      transition: all 0.3s ease;
      margin-bottom: 16px;
      height: 44px;
      border-radius: 12px;
    }

    .login-button:hover {
      background-color: #357abd;
      transform: translateY(-2px);
    }

    .divider {
      display: flex;
      align-items: center;
      text-align: center;
      margin: 20px 0;
    }

    .divider::before,
    .divider::after {
      content: "";
      flex: 1;
      height: 1px;
      background: #ccc;
    }

    .divider-text {
      padding: 0 10px;
      font-size: 13px;
      color: #888;
    }

    .kakao-login-btn {
      background-color: #FEE500;
      color: rgba(0, 0, 0, 0.85);
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      width: 100%;
      padding: 12px;
      font-size: 16px;
      border-radius: 20px;
      border: none;
      cursor: pointer;
      transition: all 0.3s ease;
      height: 44px;
      border-radius: 12px;
    }

    .kakao-login-btn:hover {
      background-color: #FDD835;
      transform: translateY(-2px);
    }

    .kakao-icon {
      width: 20px;
      height: 20px;
      object-fit: contain;
    }

    .error-message {
      color: #ff3b3b;
      text-align: center;
      margin-bottom: 20px;
      padding: 10px;
      background-color: rgba(255, 59, 59, 0.1);
      border-radius: 10px;
    }

    .signup-wrapper {
      margin-top: 15px;
      text-align: center;
    }

    .signup-text {
      font-size: 14px;
      color: #666;
    }

    .signup-link {
      color: #4a90e2;
      text-decoration: none;
      margin-left: 5px;
    }

    @media (max-width: 768px) {
      .container {
        width: 90%;
      }

      .login-box {
        padding: 20px;
      }
    }
  </style>
</head>
<body>
<%
  String error = request.getParameter("error");
  if (error != null && error.equals("true")) {
    request.setAttribute("errorMsg", "아이디 또는 비밀번호가 일치하지 않습니다.");
  }
%>

<!-- 로고 -->
<div class="logo-container">
  <img src="<c:url value='/image/logo.png' />" alt="Logo" class="logo">
</div>

<!-- 로그인 박스 -->
<div class="login-box">
  <h1 class="login-title">로그인</h1>
  <p class="welcome-message">
    국내여행지 추천 AI, <span class="highlight">소담여행</span>
  </p>

  <!-- 에러 메시지 -->
  <% if (request.getAttribute("errorMsg") != null) { %>
    <p class="error-message">
      <%= request.getAttribute("errorMsg") %>
    </p>
  <% } %>

  <form class="login-form" action="<c:url value='/user/login'/>" method="post">
    <input type="text" name="id" placeholder="아이디" class="login-input" required value="${param.id}">
    <input type="password" name="password" placeholder="비밀번호" class="login-input" required>

    <!-- 원래 크기의 로그인 버튼 -->
    <button type="submit" class="login-button">로그인</button>

    <!-- 구분선 -->
    <div class="divider">
      <span class="divider-text">또는</span>
    </div>

    <!-- 카카오 로그인 버튼 -->
    <button type="button" class="kakao-login-btn" onclick="location.href='${location}'">
      <img src="https://developers.kakao.com/assets/img/about/logos/kakaolink/kakaolink_btn_small.png"
           alt="kakao" class="kakao-icon">
      kakao 로그인
    </button>
  </form>

  <div class="signup-wrapper">
    <span class="signup-text">계정이 없으신가요?</span>
    <a href="<c:url value='/user/signup'/>" class="signup-link">회원가입</a>
  </div>
</div>
</body>
</html>
