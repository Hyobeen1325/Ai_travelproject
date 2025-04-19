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

  .password-change-button {
    align-self: flex-end;
    padding: 12px 24px;
    background-color: #28a745; /* 초록색 */
    color: white;
    font-size: 14px;
    font-weight: 500;
    border: none;
    border-radius: 12px;
    cursor: pointer;
    transition: all 0.3s ease;
    margin-top: 10px;
  }

  .password-change-button:hover {
    background-color: #1e7e34; /* 좀 더 진한 초록색 */
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(40, 167, 69, 0.2);
  }
  </style>
</head>
<body>
  <div class="mypage-box">
    <div class="mypage-title">내정보</div>

    <form class="mypage-form" id="mainForm">
      <label>이름</label>
      <input type="text" placeholder="이름" class="mypage-input" name="name" value="${member.name}" readonly>
      <label>닉네임</label>
      <input type="text" placeholder="닉네임" class="mypage-input" name="nickname" value="${member.nickname}" readonly>
      <label>전화번호</label>
      <input type="text" placeholder="전화번호" class="mypage-input" name="phone" value="${member.phon_num}" readonly>
      <label>아이디</label>
      <input type="email" placeholder="아이디" class="mypage-input" name="email" value="${member.email}" readonly>
      <div style="display: flex; justify-content: flex-end; gap: 10px;">
        <button type="button" class="password-change-button" onclick="openPasswordModal()">비밀번호 변경</button>
        <button type="button" class="mypage-button" onclick="openEditModal()">수정</button>
      </div>
    </form>
  </div>

  <div class="modal" id="editModal">
    <div class="modal-content">
      <button class="close-button" onclick="closeEditModal()">&times;</button>
      <div class="modal-title">내정보 수정</div>
      <form class="modal-form" id="editForm" action="<c:url value='/login/mypage/${member.email}'/>" method="post">
       <label>이메일</label>
        <input type="email" class="modal-input" id="editEmail" name="email" placeholder="이메일" value="${member.email}">
        <label>닉네임</label>
    	<input type="text" class="modal-input" id="editNickname" name="nickname" placeholder="닉네임" value="${member.nickname}">
    	<label>전화번호</label>
    	<input type="tel" class="modal-input" id="editPhone" name="phon_num" placeholder="전화번호" value="${member.phon_num}">
    	<div class="modal-buttons">
        <button type="button" class="modal-button modal-cancel" onclick="closeEditModal()">취소</button>
        <button type="submit" class="modal-button modal-save">저장</button>
        </div>
      </form>
    </div>
  </div>

  <div class="modal" id="passwordModal">
    <div class="modal-content">
      <button class="close-button" onclick="closePasswordModal()">&times;</button>
      <div class="modal-title">비밀번호 변경</div>
      <form class="modal-form" id="passwordForm" action="<c:url value='/login/updatePassword'/>" method="post">
        <label for="currentPassword">현재 비밀번호</label>
        <input type="password" class="modal-input" id="currentPassword" name="currentPassword" placeholder="현재 비밀번호" required>
        <label for="newPassword">새 비밀번호</label>
        <input type="password" class="modal-input" id="newPassword" name="newPassword" placeholder="새 비밀번호" required>
        <label for="confirmNewPassword">새 비밀번호 확인</label>
        <input type="password" class="modal-input" id="confirmNewPassword" name="confirmNewPassword" placeholder="새 비밀번호 확인" required>
        <div class="modal-buttons">
          <button type="button" class="modal-button modal-cancel" onclick="closePasswordModal()">취소</button>
          <button type="submit" class="modal-button modal-change" style="background-color: #28a745; color: white;">변경</button>
          
        </div>
      </form>
    </div>
  </div>
<jsp:include page="header2.jsp" />
</body>
 <script type="text/javascript">
    const editModal = document.getElementById('editModal');
    const passwordModal = document.getElementById('passwordModal');
    const mainForm = document.querySelector('.mypage-form');
    const editForm = document.getElementById('editForm');
    const passwordForm = document.getElementById('passwordForm');

    function openEditModal() {
      editModal.style.display = 'flex';
    }

    function closeEditModal() {
      editModal.style.display = 'none';
    }

    function openPasswordModal() {
      passwordModal.style.display = 'flex';
    }

    function closePasswordModal() {
      passwordModal.style.display = 'none';
    }

    editForm.addEventListener('submit', function (e) {
      const confirmUpdate = confirm("내정보를 수정하시겠습니까?");
      if (!confirmUpdate) {
        e.preventDefault();
      }
    });

    passwordForm.addEventListener('submit', function (e) {
      const newPassword = document.getElementById('newPassword').value;
      const confirmNewPassword = document.getElementById('confirmNewPassword').value;

      if (newPassword !== confirmNewPassword) {
        alert("새 비밀번호와 새 비밀번호 확인이 일치하지 않습니다.");
        e.preventDefault();
        return;
      }

      const confirmChange = confirm("비밀번호를 변경하시겠습니까?");
      if (!confirmChange) {
        e.preventDefault();
      }
    });

    window.onclick = function (event) {
      if (event.target === editModal) {
        closeEditModal();
      }
      if (event.target === passwordModal) {
        closePasswordModal();
      }
    };

    var message = "${msg}";
    if (message != "") {
        alert(message);
    };
</script>
</html>