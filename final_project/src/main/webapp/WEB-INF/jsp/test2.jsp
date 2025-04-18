<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<jsp:include page="header.jsp" />
<body>
<h1>test2</h1>
<script>
	 var message = "${msg}";
	 if (message && message !== "") {
	     alert(message); // 메세지 출력 
	 }
</script>
</body>
<jsp:include page="header2.jsp" /> 
</html>