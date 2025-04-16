<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>선택값 리스트</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
        tr:hover {
            background-color: #f5f5f5;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h2>학생 목록</h2>
    <table>
        <thead>
            <tr>
                <th>선택값 ID</th>
                <th>상위지역</th>
                <th>하위지역</th>
                <th>테마1</th>
                <th>테마2</th>
                <th>테마3</th>
                <th>테마4</th>
                <th>여행일자</th>
                <th>등록일</th>
                <th>수정일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="choose" items="${chooses}">
                <tr onclick="location.href='/choose_val/One?choose_id=${choose.choose_id}'">
                    <td>${choose.choose_id}</td>
                    <td>${choose.high_loc}</td>
                    <td>${choose.low_loc}</td>
                    <td>${choose.theme1}</td>
                    <td>${choose.theme2}</td>
                    <td>${choose.theme3}</td>
                    <td>${choose.theme4}</td>
                    <td>${choose.days}</td>
                    <td>${choose.regdateS}</td>
                    <td>${choose.uptdateS}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>