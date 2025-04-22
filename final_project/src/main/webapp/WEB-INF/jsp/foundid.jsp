<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>아이디 찾기 결과</title>
  <style>
 body {
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #e6f3ff;
      margin: 50;
      padding: 0;
    }

    .container {
      max-width: 600px; 
      background: #fff;
      border-radius: 15px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      padding: 30px 25px;
      text-align: center;
      margin: 30px auto; 
    }

    .result-title {
      font-size: 25px;
      font-weight: 600;
      color: #333;
      margin-bottom: 25px;
      text-align: left;
    }

    .result-box {
      background-color: #f9f9f9; 
      border: 1px solid #ddd;
      border-radius: 8px;
      padding: 20px;
      margin-bottom: 20px; 
      text-align: left;
    }

    .result-id {
      color: #4a90e2;
      font-weight: bold;
      text-decoration: none;
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
    var message = "${msg}";
    if (message != "") {
        alert(message);
    };
  </script>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container">
  <h2 class="result-title">아이디 찾기 결과</h2>
  <div class="result-box">
    <c:if test="${not empty foundID}">
      <p class="result-text">찾으시는 아이디는
      <strong class="result-id">${foundid}</strong> 입니다.</p>
    </c:if>
  </div>
  <div class="back-link">
    <a href="/login">← 로그인으로 돌아가기</a>
  </div>
</div>
<jsp:include page="header2.jsp" />
</body>
</html>