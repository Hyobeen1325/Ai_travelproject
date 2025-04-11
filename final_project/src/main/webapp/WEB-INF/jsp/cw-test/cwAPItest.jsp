<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

</style>
<script>

</script>
</head>

<body>
	<form action="/cwtestAPIre">
		<input name="high_loc" type="text">
		<input name="low_loc" type="text">
		<input name="theme1" type="text">
		<input name="theme2" type="text">
		<input name="theme3" type="text">
		<input name="theme4" type="text">
	</form>
	<div>
		받은 값 : 
		<c:forEach var="response" items="${responses}">
			<p>---------------------------</p>
			<p>response.addr1</p>
			<p>response.title</p>
			<p>response.mapx</p>
			<p>response.mapy</p>
			<p>response.firstimage</p>
			<p>response.firstimage2</p>
			<p>---------------------------</p>
		</c:forEach>
	</div>

<script>

</script>

</body>
</html>