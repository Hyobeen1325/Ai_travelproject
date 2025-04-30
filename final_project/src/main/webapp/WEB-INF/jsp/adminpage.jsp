<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 페이지</title>
    <style>
        .admin-page-container { width: 80%; margin: 20px auto; font-family: Arial, sans-serif; }
        .admin-title { text-align: center; margin-bottom: 20px; }
        .search-bar { text-align: right; margin-bottom: 15px; }
        .search-input { padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        .search-button { padding: 8px 12px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .member-list { width: 100%; border-collapse: collapse; }
        .member-list th, .member-list td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        .member-list th { background-color: #f2f2f2; }
        .action-buttons a, .action-buttons form button { margin-right: 5px; padding: 6px 10px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; font-size: 0.9em; }
        .edit-button { background-color: #28a745; color: white; }
        .delete-button { background-color: #dc3545; color: white; }
        .text-center { text-align: center; }
        .error-message { color: red; text-align: center; margin-top: 10px; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.4); justify-content: center; align-items: center; z-index: 1000; }
        .modal-content { background-color: #fefefe; padding: 20px; border: 1px solid #888; width: 80%; max-width: 600px; border-radius: 8px; position: relative; }
        .close-button { color: #aaa; float: right; font-size: 28px; font-weight: bold; text-decoration: none; cursor: pointer; }
        .close-button:hover, .close-button:focus { color: black; }
        .modal-title { font-size: 1.5em; margin-bottom: 15px; text-align: center; }
        .modal-form label { display: block; margin-bottom: 5px; font-weight: bold; }
        .modal-input { width: calc(100% - 12px); padding: 8px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .modal-buttons { text-align: right; margin-top: 15px; }
        .modal-button { padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer; font-size: 1em; margin-left: 10px; }
        .modal-cancel { background-color: #6c757d; color: white; }
        .modal-save { background-color: #28a745; color: white; }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />

<c:if test="${empty sessionScope.SessionMember.email || sessionScope.SessionMember.email != 'admin@email.com'}">
    <script>
        alert("관리자 권한이 필요합니다.");
        location.href = '/login';
    </script>
</c:if>

<div class="admin-page-container">
    <h1 class="admin-title">회원정보 관리</h1>

    <div class="search-bar">
        <form action="<c:url value='/login/admin/name'/>" method="get">
            <input type="text" class="search-input" name="memberName" placeholder="이름 입력">
            <button type="submit" class="search-button">검색</button>
        </form>
    </div>

    <table class="member-list">
        <thead>
        <tr>
            <th>아이디</th>
            <th>이름</th>
            <th>닉네임</th>
            <th>전화번호</th>
            <th>생성일</th>
            <th>수정일</th>
            <th>선택</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty member}">
                <c:forEach var="m" items="${member}">
                    <tr>
                        <td>${m.email}</td>
                        <td>${m.name}</td>
                        <td>${m.nickname}</td>
                        <td>${m.phon_num}</td>
                        <td>${m.reg_date}</td>
                        <td>${m.upt_date}</td>
                        <td class="action-buttons">
                            <a href="#" onclick="openEditModal('${m.email}', '${m.name}', '${m.nickname}', '${m.phon_num}')" class="edit-button">수정</a>
                            <%-- <form action="<c:url value='/login/admin/${m.email}'/>" method="post" style="display: inline;"
                                  onsubmit="return confirm('정말로 탈퇴시키겠습니까?');">
                                <input type="hidden" name="_method" value="delete">
                                <button type="submit" class="delete-button">탈퇴</button>
                            </form> --%>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr><td colspan="7" class="text-center">존재하지 않는 데이터 입니다.</td></tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>

    <c:if test="${not empty msg}">
        <p class="error-message">${msg}</p>
    </c:if>

    <div id="editModal" class="modal">
        <div class="modal-content">
            <a href="#" onclick="closeEditModal()" class="close-button">&times;</a>
            <h2 class="modal-title">회원정보 수정</h2>
            <form action="<c:url value='/login/admin/${currentEditEmail}'/>" method="post" id="editForm">
                <label for="editEmail">아이디 : </label>
                <input type="text" id="editEmail" name="email" class="modal-input" readonly>

                <label for="editName">이름 : </label>
                <input type="text" id="editName" name="name" class="modal-input">

                <label for="editNickname">닉네임 : </label>
                <input type="text" id="editNickname" name="nickname" class="modal-input">

                <label for="editPhonNum">전화번호 : </label>
                <input type="text" id="editPhonNum" name="phon_num" class="modal-input">

                <div class="modal-buttons">
                    <button type="button" class="modal-cancel" onclick="closeEditModal()">취소</button>
                    <button type="submit" class="modal-save">저장</button>
                </div>
                <input type="hidden" name="_method" value="put">
            </form>
        </div>
    </div>

</div>

<script>
    let currentEditEmail = '';
   // 회원정보 수정폼
    function openEditModal(email, name, nickname, phonNum) {
        currentEditEmail = email;
        document.getElementById('editEmail').value = email;
        document.getElementById('editName').value = name;
        document.getElementById('editNickname').value = nickname;
        document.getElementById('editPhonNum').value = phonNum;
        // 수정 폼 action URL 동적으로 설정
        document.getElementById('editForm').action = '<c:url value="/login/admin/" />' + email;
        document.getElementById('editModal').style.display = 'flex';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    window.onclick = function(event) {
        if (event.target == document.getElementById('editModal')) {
            closeEditModal();
        }
    }
</script>

</body>
</html>