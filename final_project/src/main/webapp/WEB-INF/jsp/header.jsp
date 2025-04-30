<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>메뉴</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        nav {
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
            max-width: 1300px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            padding: 0 24px;
        }

        .logo-img {
            width: 70px;
            height: auto;
            margin-right: 16px;
        }

        .logo-text {
            font-size: 35px;
            font-weight: 700;
            color: rgb(0, 0, 0);
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
            width: 180px; /* Adjusted width to accommodate admin link */
            height: 100%;
            background-color: #ffffff;
            box-shadow: -2px 0 12px rgba(0, 0, 0, 0.1);
            transition: right 0.3s ease;
            padding: 20px;
            z-index: 2000;
            display: none;
            overflow-y: auto;
            color: black;
        }

        /* 팝업 내부 요소 */
        #popup h3 {
            margin-bottom: 15px;
            color: black;
        }

        #popup ul {
            list-style-type: none;
            padding: 0;
        }

        #popup ul li {
            margin: 10px 0;
        }

        #popup ul li a {
            display: block;
            padding: 10px 15px;
            text-decoration: none;
            color: black;
            transition: background-color 0.3s ease;
        }

        #popup ul li a:hover {
            background-color: #f0f0f0;
        }

        .logout-link {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .fa-sign-out-alt {
            font-size: 16px;
        }

        /* 버튼 스타일 */
        .button {
            padding: 8px 16px;
            background-color: #357abd;
            color: white;
            font-size: 12px;
            font-weight: 500;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
			align-self: flex-end; /* 버튼 오른쪽 정렬 */
            margin-top: auto; /* 버튼을 하단에 붙임 */
        }

        .button:hover {
            background-color: #285a8e;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.2);
        }

        .admin-link {
            color: #dc3545;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <nav>
        <div class="nav-container">
            <a href="/project1"><img src="<c:url value='/image/logo.png'/>" alt="Logo" class="logo-img"></img></a>
            <div class="logo-text" style="color: black;">소담여행</div>
            <div class="menu-icon">
                <span onclick="togglePopup()">=</span>
            </div>
        </div>
    </nav>

    <div id="overlay"></div>

    <div id="popup">
        <h3>메뉴</h3>
        <ul>
            <li><a href="/project1">메인홈</a></li>
            <li>
            <c:choose>
                <%-- kakao 계정 자체적인 세션 처리 불가능으로, 접근 거부로 설정함. --%>
                <c:when test="${sessionScope.kakaologin == true}">
                    <a onclick="alert('kakao 계정은 마이페이지에 대한 접근 권한이 없습니다.'); location.href='/login'; return false;">마이페이지</a>
                </c:when>
                <c:otherwise>
                    <a href="/login/mypage/${sessionScope.SessionMember.email}">마이페이지</a>
                </c:otherwise>
            </c:choose>
            </li>
            <c:if test="${sessionScope.SessionMember.email == 'admin@email.com'}">
                <li><a href="/login/admin" class="admin-link">관리자 페이지</a></li>
                </c:if>
            <li>
                <a onclick="document.forms['logoutForm'].submit();" class="logout-link">
                    <i class="fas fa-sign-out-alt"></i> 로그아웃
                </a>
                <form name="logoutForm" action="<c:url value='/login/logout'/>" method="post" style="display: none;"></form>
            </li>
        </ul>
        <button class="button" style="color: white;" onclick="togglePopup()">닫기</button>
    </div>
    <script>
        function togglePopup() {
            const popup = document.getElementById('popup');
            const overlay = document.getElementById('overlay');

            if (popup.style.right === '-300px' || popup.style.right === '') {
                popup.style.display = 'block';
                overlay.style.display = 'block';
                setTimeout(() => {
                    popup.style.right = '0';
                }, 10);
            } else {
                popup.style.right = '-300px';
                setTimeout(() => {
                    popup.style.display = 'none';
                    overlay.style.display = 'none';
                }, 300);
            }
        };
    </script>
</body>
</html>