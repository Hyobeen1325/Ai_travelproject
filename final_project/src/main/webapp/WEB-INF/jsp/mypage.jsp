<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
  <jsp:include page="header.jsp" />
<head>
  <meta charset="UTF-8">
  <title>My Page</title>
  <style>
    * {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Noto Sans KR', sans-serif;
  background-color: #e6f3ff;
  color: #1a2b4d;
  min-height: 100vh;
  padding-top: 100px;
  position: relative;
}

.logo-container {
  position: fixed;
  top: 20px;
  left: 30px;
  z-index: 1000;
}

.logo {
  width: 160px;
  height: auto;
  transition: transform 0.2s ease;
}

.logo:hover {
  transform: scale(1.05);
}

.mypage-box {
  max-width: 600px;
  margin: 100px auto;
  background-color: white;
  padding: 40px;
  border-radius: 20px;
  box-shadow: 0 10px 40px rgba(31, 68, 135, 0.08);
}

.mypage-title {
  font-size: 26px;
  font-weight: 600;
  color: #333;
  margin-bottom: 25px;
  text-align: left;
}

.mypage-form {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

/* ✅ 로그인 스타일과 통일된 입력창 스타일 */
.mypage-input,
.modal-input {
  width: 100%;
  padding: 10px;
  font-size: 14px;
  border: 1px solid #e0e0e0;
  border-radius: 10px;
  background-color: white;
  transition: all 0.3s ease;
  box-sizing: border-box;
}

.mypage-input:focus,
.modal-input:focus {
  border-color: #4a90e2;
  box-shadow: 0 0 5px rgba(74, 144, 226, 0.3);
  background-color: white;
}

.mypage-input[readonly] {
  background-color: white; /* ← 기존 회색 → 흰색으로 변경 */
  cursor: not-allowed;
}


.mypage-button {
  align-self: flex-end;
  padding: 12px 24px;
  background-color: #4a90e2;
  color: white;
  font-size: 14px;
  font-weight: 500;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.mypage-button:hover {
  background-color: #357abd;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(74, 144, 226, 0.2);
}

.error-message {
  color: #ff3b3b;
  font-size: 13px;
  text-align: center;
  margin-bottom: 15px;
  padding: 10px;
  background-color: #fff1f1;
  border-radius: 8px;
}

.modal {
  display: none;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(26, 43, 77, 0.4);
  z-index: 1000;
  justify-content: center;
  align-items: center;
  backdrop-filter: blur(4px);
  animation: fadeIn 0.2s ease;
}

.modal-content {
  background-color: white;
  padding: 35px;
  border-radius: 20px;
  width: 480px;
  position: relative;
  box-shadow: 0 25px 50px -12px rgba(31, 68, 135, 0.15);
  animation: slideUp 0.3s ease;
}

.modal-title {
  font-size: 24px;
  font-weight: 600;
  color: #1a2b4d;
  margin-bottom: 20px;
}

.modal-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.modal-buttons {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

.modal-button {
  padding: 12px 20px;
  font-size: 14px;
  font-weight: 500;
  border-radius: 12px;
  border: none;
  cursor: pointer;
  transition: all 0.2s ease;
}

.modal-cancel {
  background-color: #e0e0e0;
  color: #333;
}

.modal-save {
  background-color: #4a90e2;
  color: white;
}

.modal-button:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.close-button {
  position: absolute;
  top: 15px;
  right: 20px;
  font-size: 24px;
  background: none;
  border: none;
  color: #aaa;
  cursor: pointer;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 768px) {
  .mypage-box {
    margin: 100px 16px;
    padding: 28px;
  }

  .modal-content {
    width: 90%;
    margin: 20px;
  }

  .mypage-button,
  .modal-button {
    width: 100%;
  }

  .modal-buttons {
    flex-direction: column;
  }
}

  </style>
</head>
<body>

  <!-- 로고 -->

  <!-- 마이페이지 박스 -->
  <div class="mypage-box">
    <div class="mypage-title">내정보</div>
    
    <!-- 내정보 조회 -->
    <form class="mypage-form" id="mainForm">
      <label>이름</label>
      <input type="text" placeholder="이름" class="mypage-input" name="name" value="${member.name}" readonly>
      <label>닉네임</label>
      <input type="text" placeholder="닉네임" class="mypage-input" name="nickname" value="${member.nickname}" readonly>
      <label>전화번호</label>
      <input type="text" placeholder="전화번호" class="mypage-input" name="phone" value="${member.phon_num}" readonly>
      <label>아이디</label>
      <input type="email" placeholder="아이디" class="mypage-input" name="id" value="${member.email}" readonly>
      <button type="button" class="mypage-button" onclick="openModal()">수정</button>
    </form>
  </div>

  <!-- 모달 : 내정보 수정 -->
  <div class="modal" id="editModal">
    <div class="modal-content">
      <button class="close-button" onclick="closeModal()">&times;</button>
      <div class="modal-title">내정보 수정</div>
      
      <form class="modal-form" id="editForm" action="<c:url value='/login/mypage/${member.email}'/>" method="post">
       <label>이메일</label>
        <input type="email" class="modal-input" id="editEmail" name="email" placeholder="이메일" value="${member.email}">
        <label>닉네임</label>
    	<input type="text" class="modal-input" id="editNickname" name="nickname" placeholder="닉네임" value="${member.nickname}">
    	<label>전화번호</label>
    	<input type="tel" class="modal-input" id="editPhone" name="phon_num" placeholder="전화번호" value="${member.phon_num}">
    <div class="modal-buttons">
        <button type="button" class="modal-button modal-cancel" onclick="closeModal()">취소</button>
        <button type="submit" class="modal-button modal-save">저장</button>
        </div>
      </form>
    </div>
  </div>

  <script>
    const modal = document.getElementById('editModal');
    const mainForm = document.querySelector('.mypage-form');
    const editForm = document.getElementById('editForm');

    // 모달 열기
    function openModal() {
      modal.style.display = 'flex';
    }

    // 모달 닫기
    function closeModal() {
      modal.style.display = 'none';
    }

    // 폼 제출 시 확인 메시지
    editForm.addEventListener('submit', function (e) {
      const confirmUpdate = confirm('수정된 정보를 저장하시겠습니까?');
      if (!confirmUpdate) {
        e.preventDefault();
      }
    });

    // 모달 외부 클릭 시 닫기
    window.onclick = function (event) {
      if (event.target === modal) {
        closeModal();
      }
    };
  </script>
<jsp:include page="header2.jsp" />
</body>
</html>