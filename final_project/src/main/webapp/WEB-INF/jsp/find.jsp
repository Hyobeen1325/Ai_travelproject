<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>아이디 / 비밀번호 찾기</title>
  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #e6f3ff;
      margin: 50;
      padding: 0;
    }

	.container {
	  max-width: 500px;
	  margin: 150px auto; 
	  background: #fff;
	  border-radius: 15px;
	  box-shadow: 0 2px 6px rgba(0,0,0,0.1);
	  padding: 30px 25px;
	}

	
    .tab-menu {
      display: flex;
      justify-content: space-around;
      margin-bottom: 20px;
      border-bottom: 2px solid #e0e0e0;
    }

	
	.find-title {
	  font-size: 23px;
	  font-weight: 600;
	  color: #333;
	  margin-bottom: 25px;
	  text-align: left;
	}
	
	
    .tab-menu div {
      padding: 10px 20px;
      cursor: pointer;
      font-weight: 600;
      color: #888;
      border-bottom: 2px solid transparent;
      transition: 0.3s;
    }

    .tab-menu .active {
      color: #4a90e2;
      border-bottom: 2px solid #4a90e2;
    }

    .form-wrapper {
      display: none;
    }

    .form-wrapper.active {
      display: block;
    }

    .form-group {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .input {
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 10px;
      font-size: 14px;
    }

    .button {
      padding: 10px;
      background-color: #4a90e2;
      color: white;
      border: none;
      border-radius: 12px;
      font-size: 16px;
      cursor: pointer;
      margin-top: 10px;
    }

    .button:hover {
      background-color: #357abd;
    }
    .find-box {
	  background-color: #f9f9f9; /* 박스 배경색 */
	  border: 1px solid #ddd; /* 박스 테두리 */
	  border-radius: 8px; /* 박스 둥근 모서리 */
	  padding: 20px; /* 박스 내부 여백 */
	  margin-bottom: 20px; /* 아래 요소와의 간격 (선택 사항) */
	}

    .back-link {
      text-align: center;
      margin-top: 30px;
      text-align: right;
    }

    .back-link a {
      color: #4a90e2;
      text-decoration: none;
    }
  </style>
  <script>
    function showTab(tabId) {
      const tabs = document.querySelectorAll('.tab-menu div');
      const forms = document.querySelectorAll('.form-wrapper');

      tabs.forEach(t => t.classList.remove('active'));
      forms.forEach(f => f.classList.remove('active'));

      document.getElementById(tabId).classList.add('active');
      document.querySelector(`[data-tab="${tabId}"]`).classList.add('active');
    }

    window.onload = function () {
      showTab('find-id'); // 기본 탭
    };
  </script>
</head>
<body>
<!-- 상단 헤더 -->
<jsp:include page="header.jsp" />

<!-- 메인 박스 -->
<div class="container">
  <div class="find-title">아이디 찾기 / 비밀번호 찾기</div>
  
 <!-- 탭 메뉴 -->
 <div class="find-box">
  <div class="tab-menu">
    <div data-tab="find-id" onclick="showTab('find-id')">아이디 찾기</div>
    <div>|</div>
    <div data-tab="find-pwd" onclick="showTab('find-pwd')">비밀번호 찾기</div>
  </div>

  <!-- 아이디 찾기 폼 -->
  <div class="form-wrapper" id="find-id">
    <form action="<c:url value='/findId' />" method="post" class="form-group">
      <input type="text" name="name" placeholder="이름" class="input" required>
      <input type="text" name="phon_num" placeholder="전화번호" class="input" required>
      <button type="submit" class="button">확인</button>
    </form>
  </div>

  <!-- 비밀번호 찾기 폼 -->
  <div class="form-wrapper" id="find-pwd">
    <form action="<c:url value='/login/findpwd' />" method="post" class="form-group">
      <input type="email" name="email" placeholder="아이디" class="input" required>
      <button type="submit" class="button">임시 비밀번호 발송</button>
    </form>
  </div>
</div>
  <!-- 로그인 이동 -->
  <div class="back-link">
    <a href="/login">← 로그인으로 돌아가기</a>
  </div>
</div>

<!-- 하단 헤더 -->
<jsp:include page="header2.jsp" />
</body>
</html>