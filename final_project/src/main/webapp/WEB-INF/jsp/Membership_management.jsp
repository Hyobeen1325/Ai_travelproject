<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원관리 - 관리자 페이지</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            margin: 20px;
            background-color: #f5f7ff;
        }
        .container {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            width: 100%;
            box-sizing: border-box;
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .icon {
            font-size: 24px;
        }
        .search-box {
            display: flex;
            margin-bottom: 20px;
            gap: 10px;
        }
        .search-box form {
            display: flex;
            flex: 1;
            gap: 10px;
        }
        .search-input {
            flex: 1;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .search-button {
            padding: 8px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            table-layout: fixed;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            vertical-align: middle;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        .edit-btn, .delete-btn {
            padding: 5px 10px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 12px;
            white-space: nowrap;
        }
        .edit-btn {
            background-color: #4CAF50;
            color: white;
        }
        .delete-btn {
            background-color: #f44336;
            color: white;
        }
        .pagination {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 5px;
        }
        .pagination a {
            padding: 8px 12px;
            text-decoration: none;
            color: #333;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .pagination a.active {
            background-color: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
        .pagination a:hover:not(.active) {
            background-color: #f5f5f5;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>
            <span>Membership management</span>
            <span class="icon">📋</span>
        </h1>

        <div class="search-box">
            <form action="/admin/member" method="get">
                <input type="text" class="search-input" name="searchKeyword" value="${searchKeyword}" placeholder="회원 이름 또는 이메일 검색">
                <input type="hidden" name="size" value="${pageSize}">
                <button type="submit" class="search-button">검색</button>
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th style="width: 5%">No</th>
                    <th style="width: 10%">이름</th>
                    <th style="width: 15%">닉네임</th>
                    <th style="width: 20%">이메일</th>
                    <th style="width: 15%">전화번호</th>
                    <th style="width: 10%">가입일자</th>
                    <th style="width: 10%">수정일자</th>
                    <th style="width: 15%">관리</th>
                </tr>
            </thead>
            <tbody>
              <!-- <c:forEach items="${members}" var="member" varStatus="status">
                    <tr>
                        <td>${status.count}</td>
                        <td>${member.name}</td>
                        <td>${member.nickname}</td>
                        <td>${member.email}</td>
                        <td>${member.phone}</td>
                        <td><fmt:formatDate value="${member.createdDate}" pattern="yy-MM-dd"/></td>
                        <td><fmt:formatDate value="${member.modifiedDate}" pattern="yy-MM-dd"/></td>
                        <td>
                            <div class="action-buttons">
                                <button class="edit-btn" onclick="location.href='${pageContext.request.contextPath}/admin/member/edit?memberId=${member.id}'">수정</button>
                                <button class="delete-btn" onclick="deleteMember('${member.id}', '${member.name}')">삭제</button>
                            </div>
                        </td>
                    </tr>
                </c:forEach> 
				-->
                    <tr>
                        <td>1</td>
                        <td>홍길동</td>
                        <td>병맛레시피</td>
                        <td>aaa@gmail.com</td>
                        <td>010-1234-5678</td>
                        <td>2025-04-09</td>
                        <td>2025-04-10</td>
                        <td>
                            <div class="action-buttons">
                                <button class="edit-btn" >수정</button>
                                <button class="delete-btn" >삭제</button>
								
								<!--<button class="edit-btn" onclick="location.href='${pageContext.request.contextPath}/admin/member/edit?memberId=${member.id}'">수정</button>
								<button class="delete-btn" onclick="deleteMember('${member.id}', '${member.name}')">삭제</button>-->
								</div>
                        </td>
                    </tr>
                
            </tbody>
        </table>

        <div class="pagination">
            <% 
                int currentPage = (Integer) request.getAttribute("currentPage");
                int totalPages = (Integer) request.getAttribute("totalPages");
                String searchKeyword = (String) request.getAttribute("searchKeyword");
                
                if (currentPage > 1) {
            %>
                <a href="/admin/member?page=<%= currentPage - 1 %>&size=${pageSize}&searchKeyword=${searchKeyword}">이전</a>
            <% 
                }
                
                int startPage = Math.max(1, currentPage - 4);
                int endPage = Math.min(totalPages, currentPage + 4);
                
                for (int i = startPage; i <= endPage; i++) {
            %>
                <a href="/admin/member?page=<%= i %>&size=${pageSize}&searchKeyword=${searchKeyword}" 
                   class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
            <% 
                }
                
                if (currentPage < totalPages) {
            %>
                <a href="/admin/member?page=<%= currentPage + 1 %>&size=${pageSize}&searchKeyword=${searchKeyword}">다음</a>
            <% } %>
        </div>
    </div>

    <script>
        function deleteMember(memberId, memberName) {
            if (confirm('회원 [' + memberName + '] (ID: ' + memberId + ') 정말 삭제하시겠습니까?\n삭제 후 복구할 수 없습니다.')) {
                fetch('${pageContext.request.contextPath}/admin/member/delete/' + memberId, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        alert('삭제되었습니다.');
                        location.reload();
                    } else {
                        alert('삭제 실패했습니다.');
                    }
                })
                .catch(error => {
                    alert('오류가 발생했습니다: ' + error);
                });
            }
        }
    </script>
</body>
</html>