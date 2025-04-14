<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 상단 헤더 -->
<nav>
  <div class="nav-container">
    <a href="/project1"><img src="<c:url value='/image/logo.png'/>" alt="Logo" class="logo-img"></img></a>
    <div class="logo-text" style="color: black;">소담여행</div> <!-- 텍스트 색상 검정색으로 변경 -->
   
    <div class="menu-icon">
      <span onclick="togglePopup()">=</span>
    </div>
  </div>
</nav>

<!-- 오버레이 -->
<div id="overlay"></div>

<!-- 팝업 -->
<div id="popup">
  <h3>메뉴</h3>
  <ul>
    <li><a href="/project1">메인홈</a></li>
    <li><a href="/login/mypage">마이페이지</a></li>  <!-- ("/login/main") : 컨트롤러로 설정 url  -->
    <li><a href="/login">로그아웃</a></li>
  </ul>
  <button class="button" style="color: white;" onclick="togglePopup()">닫기</button> <!-- 버튼 텍스트 색상 하얀색으로 변경 -->
</div>

<!-- 스타일 -->
<style>
/* 상단 네비게이션 */
nav {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 1000;
  background-color: #ffffff;
  padding: 20px 0;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  font-family: 'Noto Sans KR', sans-serif;
}

.nav-container {
  max-width: 1280px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  padding: 0 24px;
}

.logo-img {
  width: 80px;
  height: auto;
  margin-right: 16px;
}

.logo-text {
  font-size: 35px;
  font-weight: 700;
  color: rgb(0, 0, 0); /* 검정색으로 설정 */
  text-align: center;
  flex-grow: 1;
  letter-spacing: -0.5px;
  display: flex;
  justify-content: center;
}

.menu-icon {
  display: flex;
  gap: 8px;
  font-size: 24px;
  cursor: pointer;
}

/* 오버레이 */
#overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: none;
  z-index: 1999; 
}

/* 팝업 전체 화면 */
#popup {
  position: fixed;
  top: 0;
  right: -300px;
  width: 130px;
  height: 100%;
  background-color: #ffffff;
  box-shadow: -2px 0 12px rgba(0, 0, 0, 0.1);
  transition: right 0.3s ease;
  padding: 20px;
  z-index: 2000; 
  display: none;
  overflow-y: auto;
  color: black; /* 텍스트 색상 지정 */
}

/* 팝업 내부 요소 */
#popup h3 {
  margin-bottom: 15px;
  color: black; /* 제목도 검정색으로 명시 */
}

#popup ul {
  list-style-type: none;
  padding: 0;
}

#popup ul li {
  margin: 10px 0;
}

#popup ul li a {
  text-decoration: none;
  color: black; /* 링크 텍스트도 검정색 */
}
/* 버튼 스타일 */
.button {
  align-self: flex-end;
  padding: 8px 16px;
  background-color: #357abd; /* 버튼 배경색을 어두운 파란색으로 변경 */
  color: white; /* 버튼 텍스트 색상 흰색으로 설정 */
  font-size: 12px;
  font-weight: 500;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
  text-decoration: none;
}

.button:hover {
  background-color: #285a8e; /* 마우스 오버시 배경색 변경 */
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(74, 144, 226, 0.2);
}
</style>

<!-- 스크립트 -->
<script>
function togglePopup() {
  const popup = document.getElementById('popup');
  const overlay = document.getElementById('overlay');

  // 팝업이 닫혀 있는 경우
  if (popup.style.right === '-300px' || popup.style.right === '') {
    popup.style.display = 'block';
    overlay.style.display = 'block';
    setTimeout(() => {
      popup.style.right = '0';
    }, 10);
  } else {
    // 팝업 닫기
    popup.style.right = '-300px';
    setTimeout(() => {
      popup.style.display = 'none';
      overlay.style.display = 'none';
    }, 300);
  }
}
</script>
