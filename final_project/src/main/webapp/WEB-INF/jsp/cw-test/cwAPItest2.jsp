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
	<form action="http://apis.data.go.kr/B551011/KorService1/areaBasedList1" method="post">
		<input name="mobileOS" type="hidden" value="ETC"/>
		<input name="MobileApp" type="hidden" value="APPtest"/>
		<input name="serviceKey" type="hidden" value="0MHNpRPQr0BonjfZozHtGZWjNLitvGLKjNT%2BW6nBSCYW2Zz7e5ro7gq%2FMRKLoP%2FcNmbAAErU2AgWo2LvLGiIfA%3D%3D"/>
		<input name="pageNo" type="hidden" value="1"/>
		<input name="numOfRows" type="hidden" value="100"/>
		상위 지역 코드 <input name="areaCode" type="text" value="4"/><br>
		하위 지역 코드 <input name="sigunguCode" type="text" value="4"/><br>
		분류 코드 <input name="contentTypeId" type="text" value="32"/><br>
		테마1 <input name="cat1" type="text" value="A02"/><br>
		테마2 <input name="cat2" type="text" value="A0207"/><br>
		테마3 <input name="cat3" type="text" value=""/><br>
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