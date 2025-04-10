<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
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
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background-color: #f8fafd;
      min-height: 100vh;
      padding: 20px;
      color: #1a2b4d;
    }

    /* 로고 관련 스타일 */
    .logo-container {
      text-align: left;
      padding: 15px 25px;
      margin-bottom: 20px;
      border-bottom: none;
      background-color: transparent;
      position: relative;
      box-shadow: none;
    }

    .logo {
      max-width: 120px;
      height: auto;
      transition: transform 0.2s ease;
    }

    .logo:hover {
      transform: scale(1.05);
    }

    /* 마이페이지 박스 스타일 */
    .mypage-box {
      max-width: 580px;
      margin: 20px auto 0 auto;
      background-color: white;
      padding: 35px;
      border-radius: 20px;
      box-shadow: 0 10px 40px rgba(31, 68, 135, 0.08);
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .mypage-box:hover {
      transform: translateY(-2px);
      box-shadow: 0 15px 50px rgba(31, 68, 135, 0.12);
    }

    .mypage-title {
      font-size: 30px;
      font-weight: 600;
      color: #1a2b4d;
      margin-bottom: 30px;
      letter-spacing: -0.3px;
      text-align: center;
    }

    /* 폼 관련 스타일 */
    .mypage-form {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    .mypage-input,
    .modal-input {
      width: 100%;
      padding: 14px;
      font-size: 14px;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      border: 1px solid #e4e9f2;
      border-radius: 12px;
      outline: none;
      transition: all 0.2s ease;
      background-color: #f8fafd;
      color: #1a2b4d;
    }

    .mypage-input::placeholder,
    .modal-input::placeholder {
      color: #8e9cb4;
      font-size: 14px;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    }

    .mypage-input:focus,
    .modal-input:focus {
      border-color: #3b7dff;
      background-color: white;
      box-shadow: 0 0 0 3px rgba(59, 125, 255, 0.1);
    }

    .mypage-input:disabled,
    .mypage-input[readonly] {
      background-color: #f0f3f9;
      cursor: not-allowed;
    }

    /* 버튼 스타일 */
    .mypage-button {
      width: auto;
      padding: 14px 28px;
      background-color: #3b7dff;
      color: white;
      font-size: 14px;
      font-weight: 500;
      border: none;
      border-radius: 12px;
      cursor: pointer;
      transition: all 0.2s ease;
      letter-spacing: -0.2px;
      align-self: flex-end;
    }

    .mypage-button:hover {
      background-color: #2d6bea;
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(59, 125, 255, 0.2);
    }

    .mypage-button:active {
      transform: translateY(0);
      box-shadow: 0 2px 6px rgba(59, 125, 255, 0.15);
    }

    /* 모달 스타일 */
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
      font-size: 28px;
      font-weight: 600;
      color: #1a2b4d;
      margin-bottom: 25px;
      letter-spacing: -0.3px;
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
      margin-top: 25px;
    }

    .modal-button {
      padding: 14px 24px;
      font-size: 14px;
      font-weight: 500;
      border: none;
      border-radius: 12px;
      cursor: pointer;
      transition: all 0.2s ease;
      letter-spacing: -0.2px;
      width: auto;
    }

    .modal-cancel {
      background-color: #eef1f8;
      color: #1a2b4d;
    }

    .modal-cancel:hover {
      background-color: #e4e9f2;
    }

    .modal-save {
      background-color: #3b7dff;
      color: white;
    }

    .modal-save:hover {
      background-color: #2d6bea;
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(59, 125, 255, 0.2);
    }

    .close-button {
      position: absolute;
      top: 25px;
      right: 25px;
      font-size: 22px;
      color: #8e9cb4;
      cursor: pointer;
      border: none;
      background: none;
      padding: 5px;
      transition: all 0.2s ease;
    }

    .close-button:hover {
      color: #1a2b4d;
      transform: rotate(90deg);
    }

    /* 애니메이션 */
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

    /* 에러 메시지 스타일 */
    .error-message {
      color: #ff3b3b;
      font-size: 12px;
      text-align: center;
      margin-bottom: 10px;
      padding: 10px;
      background-color: #fff1f1;
      border-radius: 8px;
      animation: shake 0.5s ease;
    }

    @keyframes shake {
      0%, 100% { transform: translateX(0); }
      25% { transform: translateX(-5px); }
      75% { transform: translateX(5px); }
    }

    /* 반응형 디자인 */
    @media (max-width: 768px) {
      .mypage-box {
        margin: 10px;
        padding: 25px;
      }

      .modal-content {
        width: 90%;
        margin: 20px;
      }

      .mypage-button {
        width: 100%;
      }

      .modal-buttons {
        flex-direction: column;
      }

      .modal-button {
        width: 100%;
      }
    }
  </style>
</head>
<body>
  <%-- 로그인 체크 임시 주석처리
  <c:if test="${empty sessionScope.userName}">
    <c:redirect url="/login"/>
  </c:if>
  --%>

  <!-- 로고 영역 -->
  <div class="logo-container">
    <img src="<c:url value='/image.png' />" alt="Logo" class="logo">
  </div>

  <!-- 마이페이지 섹션 -->
  <div class="section-container">
    <div class="section-content">
      <div class="mypage-box">
        <div class="mypage-title">
          내정보
        </div>

        <c:if test="${not empty message}">
          <p class="error-message">${message}</p>
        </c:if>

        <form class="mypage-form" action="<c:url value='/login/update-profile'/>" method="post">
          <input type="text" placeholder="이름" class="mypage-input" name="name" 
                 value="${sessionScope.userName}" readonly>
          <input type="text" placeholder="닉네임" class="mypage-input" name="nickname" 
                 value="${sessionScope.userNickname}">
          <input type="tel" placeholder="전화번호" class="mypage-input" name="phone" 
                 value="${sessionScope.userPhone}">
          <input type="text" placeholder="아이디" class="mypage-input" name="id" 
                 value="${sessionScope.userId}">
          <button type="submit" class="mypage-button">수정</button>
        </form>
      </div>
    </div>
  </div>

  <!-- 모달 추가 -->
  <div class="modal" id="editModal">
    <div class="modal-content">
      <button class="close-button" onclick="closeModal()">&times;</button>
      <div class="modal-title">내정보 수정</div>
      <form class="modal-form" id="editForm" action="<c:url value='/login/update-profile'/>" method="post">
        <input type="text" class="modal-input" id="editNickname" name="nickname" placeholder="닉네임">
        <input type="tel" class="modal-input" id="editPhone" name="phone" placeholder="전화번호">
        <input type="text" class="modal-input" id="editId" name="id" placeholder="아이디">
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

    mainForm.querySelector('.mypage-button').addEventListener('click', function(e) {
      e.preventDefault();
      const inputs = mainForm.querySelectorAll('.mypage-input');
      const modalInputs = document.querySelectorAll('.modal-input');
      
      modalInputs[0].value = inputs[1].value;
      modalInputs[1].value = inputs[2].value;
      modalInputs[2].value = inputs[3].value;
      
      modal.style.display = 'flex';
    });

    function closeModal() {
      modal.style.display = 'none';
    }

    editForm.addEventListener('submit', function(e) {
      e.preventDefault();
      const formData = new FormData(this);
      
      fetch('<c:url value="/login/update-profile"/>', {
        method: 'POST',
        body: formData
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          const modalInputs = document.querySelectorAll('.modal-input');
          const mainInputs = mainForm.querySelectorAll('.mypage-input');
          
          mainInputs[1].value = modalInputs[0].value;
          mainInputs[2].value = modalInputs[1].value;
          mainInputs[3].value = modalInputs[2].value;
          
          closeModal();
        } else {
          alert('업데이트에 실패했습니다. 다시 시도해주세요.');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('오류가 발생했습니다. 다시 시도해주세요.');
      });
    });

    window.onclick = function(event) {
      if (event.target == modal) {
        closeModal();
      }
    }
  </script>
</body>
</html>
