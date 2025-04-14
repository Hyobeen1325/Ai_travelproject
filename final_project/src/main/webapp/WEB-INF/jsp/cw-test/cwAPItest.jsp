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
	<form action="/cwtestAPIre" method="post">
		상위 지역 코드 <input name="high_loc" type="text" value="4"/><br>
		하위 지역 코드 <input name="low_loc" type="text" value="4"/><br>
		테마1 <input name="theme1" type="text" value="A01"/><br>
		테마1 <input name="theme1" type="text"/><br>
		테마1 <input name="theme1" type="text"/><br>
		테마2 <input name="theme2" type="text" value="A0207"/><br>
		테마2 <input name="theme2" type="text"/><br>
		테마2 <input name="theme2" type="text"/><br>
		테마3 <input name="theme3" type="text" value="C0113"/><br>
		테마3 <input name="theme3" type="text"/><br>
		테마3 <input name="theme3" type="text"/><br>
		테마4 <input name="theme4" type="text"/><br>
		테마4 <input name="theme4" type="text"/><br>
		테마4 <input name="theme4" type="text"/><br>
		일정 <input name="days" type="number" value="1"/><br>
		<input type="submit" value="제출" />
	</form>
	<%--
	<div>
		받은 값 : 
		<c:forEach var="response" items="${responses}">
			<c:forEach var="r" items="${response}">
				<p>---------------------------</p>
				<p>r.addr1</p>
				<p>r.title</p>
				<p>r.mapx</p>
				<p>r.mapy</p>
				<p>r.firstimage</p>
				<p>r.firstimage2</p>
				<p>---------------------------</p>
			</c:forEach>
		</c:forEach>
	</div>
	--%>
<script>

</script>

</body>
</html>