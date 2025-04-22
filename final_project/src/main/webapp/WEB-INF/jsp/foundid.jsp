<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기 결과 조회</title>
<script>
	// 메세지 출력
var message = "${msg}";
if (message != "") {
    alert(message);
};
</script>   
</head>
<body>
<!-- 상단 헤더 -->
<jsp:include page="header.jsp" />
	 <h1>아이디 찾기 결과</h1>
    <c:if test="${not empty foundID}">
        <p>찾으신 아이디는: <strong>${foundid}</strong> 입니다.</p>
        <a href="/login">로그인 페이지로 돌아가기</a>
    </c:if>
<!-- 단 헤더 -->
<jsp:include page="header2.jsp" />
</body>
</html>