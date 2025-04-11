<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>세부 지역 선택</title>
    <style>
        /* 기존 스타일 유지 */
        .page { width: 100%; height: 100vh; display: flex; justify-content: center; align-items: center; }
        .container { width: 80%; max-width: 1200px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .logo { width: 100px; }
        .page-indicator { font-size: 18px; }
        .content-section { text-align: center; }
        .title { font-size: 28px; margin-bottom: 30px; }
        .location-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-bottom: 30px; }
        .location-item { padding: 15px; background: #f5f5f5; border-radius: 8px; cursor: pointer; transition: all 0.3s; }
        .location-item:hover { background: #e0e0e0; }
        .location-item.selected { background: #007bff; color: white; }
        .location-item.deselecting { background: #f5f5f5; color: black; }
        .navigation { display: flex; justify-content: center; gap: 20px; }
        .nav-button { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; }
        .nav-button:hover { background: #0056b3; }
    </style>
</head>
<body>
    <div class="page">
        <div class="container">
            <div class="header">
                <img src="/image/logo.png" alt="로고" class="logo">
                <div class="page-indicator"><strong>01 ----- 02 03</strong></div>
            </div>

            <div class="content-section">
                <h1 class="title">여행을 떠나고 싶은 지역을 선택해 주세요</h1>

                <c:if test="${not empty error}">
                    <p style="color: red;">${error}</p>
                </c:if>

                <div class="location-grid">
                    <c:choose>
                        <c:when test="${empty items}">
                            <p>지역 데이터를 불러올 수 없습니다.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${items}">
                                <div class="location-item">${item.name}</div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="navigation">
                    <button class="nav-button" id="prevBtn">이전</button>
                    <button class="nav-button" id="nextBtn">다음</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        let selectedLocation = null;

        // 지역 선택 이벤트 리스너 추가
        document.querySelectorAll('.location-item').forEach(item => {
            item.addEventListener('click', function() {
                if (selectedLocation === this) {
                    // 같은 지역을 다시 클릭하면 선택 해제
                    this.classList.add('deselecting');
                    this.classList.remove('selected');
                    setTimeout(() => {
                        this.classList.remove('deselecting');
                    }, 300);
                    selectedLocation = null;
                } else {
                    // 이전 선택 해제
                    if (selectedLocation) {
                        selectedLocation.classList.add('deselecting');
                        selectedLocation.classList.remove('selected');
                        setTimeout(() => {
                            selectedLocation.classList.remove('deselecting');
                        }, 300);
                    }
                    // 새로운 지역 선택
                    this.classList.remove('deselecting');
                    this.classList.add('selected');
                    selectedLocation = this;
                }
            });
        });

        // 다음 버튼 클릭 이벤트
        document.getElementById('nextBtn').addEventListener('click', function() {
            if (!selectedLocation) {
                alert('지역을 선택해 주세요.');
                return;
            }

            const page = document.querySelector('.page');
            page.classList.add('slide-out');
            
            // 선택된 지역 정보를 localStorage에 저장
            localStorage.setItem('selectedDetailLocation', selectedLocation.textContent);
            
            setTimeout(() => {
                location.href = '/page2';
            }, 500);
        });

        // 이전 버튼 클릭 이벤트
        document.getElementById('prevBtn').addEventListener('click', function() {
            location.href = '/page0';
        });

        // 페이지 로드 시 이전에 선택한 지역이 있다면 표시
        window.addEventListener('load', function() {
            const savedLocation = localStorage.getItem('selectedDetailLocation');
            if (savedLocation) {
                document.querySelectorAll('.location-item').forEach(item => {
                    if (item.textContent === savedLocation) {
                        item.classList.add('selected');
                        selectedLocation = item;
                    }
                });
            }
        });
    </script>
</body>
</html>