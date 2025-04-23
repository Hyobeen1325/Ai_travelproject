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
      background-color: #f9f9f9; /* 박스 배경색 */
      border: 1px solid #ddd; /* 박스 테두리 */
      border-radius: 8px; /* 박스 둥근 모서리 */
      padding: 20px; /* 박스 내부 여백 */
      margin-bottom: 20px; /* 아래 요소와의 간격 */
      text-align: left;
    }

    .result-id {
      color: #4a90e2;
      font-weight: bold;
      text-decoration: none;
    }

    .back-link {
      margin-top: 30px;
      text-align: right;
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
    <c:if test="${not empty foundid}">
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