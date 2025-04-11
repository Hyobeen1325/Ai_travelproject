<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background-color: #f8fafd;
      min-height: 100vh;
      padding: 20px;
    }

    .logo-container {
      padding: 20px 25px;
      margin-bottom: 15px;
      text-align: center;
    }

    .logo {
      max-width: 180px;
      height: auto;
      margin-bottom: 15px;
    }

    .logo-subtitle {
      color: #1a2b4d;
      font-size: 15px;
      font-weight: 500;
      letter-spacing: -0.3px;
      opacity: 0.9;
    }

    .welcome-section {
      margin-bottom: 35px;
      padding-bottom: 25px;
      border-bottom: 1px solid #e4e9f2;
      text-align: center;
    }

    .welcome-title {
      color: #1a2b4d;
      font-size: 15px;
      font-weight: 500;
      letter-spacing: -0.3px;
      opacity: 0.9;
    }

    .login-box {
      max-width: 400px;
      margin: 0 auto;
      background-color: white;
      padding: 35px;
      border-radius: 20px;
      box-shadow: 0 10px 40px rgba(31, 68, 135, 0.08);
    }

    .login-title {
      text-align: center;
      margin-bottom: 15px;
    }

    .welcome-message {
      text-align: center;
      color: #1a2b4d;
      font-size: 14px;
      font-weight: 500;
      letter-spacing: -0.3px;
      opacity: 0.9;
      margin-bottom: 30px;
    }

    .highlight {
      color: #3b7dff;
      opacity: 1;
    }

    .login-form {
      display: flex;
      flex-direction: column;
      gap: 14px;
    }

    .login-input {
      width: 100%;
      padding: 14px;
      font-size: 14px;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      border: 1px solid #e4e9f2;
      border-radius: 12px;
      outline: none;
      transition: all 0.2s ease;
      background-color: #f8fafd;
      color: #1a2b4d;
    }

    .login-input::placeholder {
      color: #8e9cb4;
      font-size: 14px;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    }

    .login-input:focus {
      border-color: #3b7dff;
      background-color: white;
      box-shadow: 0 0 0 3px rgba(59, 125, 255, 0.1);
    }

    .login-button {
      width: 100%;
      padding: 14px 28px;
      background-color: #3b7dff;
      color: white;
      font-size: 14px;
      font-weight: 500;
      border: none;
      border-radius: 12px;
      cursor: pointer;
      transition: all 0.2s ease;
      letter-spacing: -0.2px;
    }

    .login-button:hover {
      background-color: #2d6bea;
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(59, 125, 255, 0.2);
    }

    .kakao-login-btn {
      width: 100%;
      margin-top: 10px;
      background-color: #FEE500;
      color: rgba(0, 0, 0, 0.85);
      padding: 12px 28px;
      border-radius: 12px;
      border: none;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      font-size: 15px;
      font-weight: 600;
      transition: all 0.2s ease;
      letter-spacing: -0.2px;
    }

    .kakao-login-btn:hover {
      background-color: #FDD835;
    }

    .kakao-icon {
      width: 20px;
      height: 20px;
    }

    .signup-wrapper {
      margin-top: 25px;
      padding-top: 25px;
      border-top: 1px solid #e4e9f2;
      text-align: center;
    }

    .signup-text {
      font-size: 12px;
      color: #8e9cb4;
    }

    .signup-link {
      color: #3b7dff;
      text-decoration: none;
      margin-left: 8px;
      font-weight: 500;
      font-size: 12px;
    }

    .signup-link:hover {
      text-decoration: underline;
    }

    .error-message {
      color: #ff3b3b;
      font-size: 12px;
      text-align: center;
      margin-bottom: 10px;
    }
  </style>
</head>
<body>
  <%
    // 로그인 에러 메시지 처리
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
    <h1 class="login-title">
      로그인
    </h1>
    <p class="welcome-message">
      국내여행지 추천 AI, <span class="highlight">소담여행</span>
    </p>

    <!-- 에러 메시지 표시 -->
    <% if (request.getAttribute("errorMsg") != null) { %>
      <p class="error-message">
        <%= request.getAttribute("errorMsg") %>
      </p>
    <% } %>

    <form class="login-form" action="<c:url value='/user/login'/>" method="post">
      <input 
        type="text" 
        name="id" 
        placeholder="아이디" 
        class="login-input" 
        required
        value="${param.id}"
      >
      <input 
        type="password" 
        name="password" 
        placeholder="비밀번호" 
        class="login-input" 
        required
      >
      <button type="submit" class="login-button">
        로그인
      </button>
     <button type="button" class="kakao-login-btn" onclick="location.href='${location}'"> 
    											<!--  location : kakao 로그인 정보  -->
        <img src="https://developers.kakao.com/assets/img/about/logos/kakaolink/kakaolink_btn_small.png" 
             alt="kakao" 
             class="kakao-icon">
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
