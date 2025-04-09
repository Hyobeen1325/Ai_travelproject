<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>테마 선택</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #e6f3ff;
            overflow-x: hidden;
        }
        .container {
            width: 60%;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
        }
        .logo {
            width: 150px;
            height: auto;
        }
        .page-indicator {
            font-size: 18px;
            color: #666;
        }
        .content-section {
            background-color: white;
            border-radius: 20px;
            padding: 40px;
            margin: 20px 0;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .title {
            text-align: center;
            font-size: 24px;
            margin-bottom: 10px;
            color: #333;
        }
        .subtitle {
            text-align: center;
            font-size: 20px;
            margin-bottom: 40px;
            color: #333;
        }
        .location-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }
        .location-item {
            background-color: white;
            padding: 15px 20px;
            border-radius: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid #e0e0e0;
            position: relative;
            overflow: hidden;
        }
        .location-item:hover {
            transform: translateY(-3px);
            background-color: rgba(74, 144, 226, 0.1);
            box-shadow: 0 3px 10px rgba(74, 144, 226, 0.2);
        }
        .location-item.selected {
            background-color: #87CEEB;
            color: white;
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(135, 206, 235, 0.3);
            border: 2px solid #4a90e2;
        }
        .location-item.selected::after {
            content: '✓';
            position: absolute;
            top: 5px;
            right: 5px;
            font-size: 12px;
            color: #fff;
            opacity: 0;
            transform: scale(0);
            transition: all 0.3s ease;
        }
        .location-item.selected::after {
            opacity: 1;
            transform: scale(1);
        }
        .location-item.deselecting {
            animation: deselect 0.3s ease forwards;
        }
        @keyframes deselect {
            0% {
                transform: translateY(-5px);
            }
            100% {
                transform: translateY(0);
                background-color: white;
                color: initial;
                border: 1px solid #e0e0e0;
            }
        }
        .navigation {
            display: flex;
            justify-content: space-between;
            padding: 20px;
        }
        .nav-button {
            padding: 12px 40px;
            font-size: 18px;
            background-color: #4a90e2;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .nav-button:hover {
            background-color: #357abd;
            transform: translateY(-2px);
        }
        .page {
            min-height: 100vh;
            transition: transform 0.5s ease;
        }
        .slide-out {
            transform: translateY(-100%);
        }
    </style>
</head>
<body>
    <div class="page">
        <div class="container">
            <div class="header">
                <img src="image/logo.png" class="logo" alt="로고" class="logo">
                <div class="page-indicator"><strong>01 02 03 -----</strong></div>
            </div>

            <div class="content-section">
                <h1 class="title">여행에서 원하는 테마를 지정해 주세요.</h1>
                <h3 class="subtitle">(최소 2개 ~ 최대 4개)</h3>

                <div class="location-grid">
                    <div class="location-item">산</div>
                    <div class="location-item">실내 여행지</div>
                    <div class="location-item">액티비티</div>
                    <div class="location-item">문화,역사</div>
                    <div class="location-item">테마파크</div>
                    <div class="location-item">카페</div>
                    <div class="location-item">전통 시장</div>
                    <div class="location-item">축제</div>
                </div>

                <div class="navigation">
                    <button class="nav-button" id="prevBtn">이전</button>
                    <button class="nav-button" id="nextBtn">다음</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        let selectedThemes = new Set();

        // 테마 선택 이벤트 리스너 추가
        document.querySelectorAll('.location-item').forEach(item => {
            item.addEventListener('click', function() {
                if (this.classList.contains('selected')) {
                    // 선택 해제
                    this.classList.add('deselecting');
                    this.classList.remove('selected');
                    setTimeout(() => {
                        this.classList.remove('deselecting');
                    }, 300);
                    selectedThemes.delete(this.textContent);
                } else {
                    // 새로운 테마 선택
                    if (selectedThemes.size >= 4) {
                        alert('가장 원하는 테마 2개~4개를 선택해주세요 :)');
                        return;
                    }
                    this.classList.remove('deselecting');
                    this.classList.add('selected');
                    selectedThemes.add(this.textContent);
                }
            });
        });

        // 다음 버튼 클릭 이벤트
        document.getElementById('nextBtn').addEventListener('click', function() {
            if (selectedThemes.size < 2 || selectedThemes.size > 4) {
                alert('가장 원하는 테마 2개~4개를 선택해주세요 :)');
                return;
            }

            const page = document.querySelector('.page');
            page.classList.add('slide-out');
            
            // 선택된 테마 정보를 localStorage에 저장
            localStorage.setItem('selectedThemes', JSON.stringify([...selectedThemes]));
            
            setTimeout(() => {
                location.href = '#';
            }, 500);
        });

        // 이전 버튼 클릭 이벤트
        document.getElementById('prevBtn').addEventListener('click', function() {
            location.href = '/page2';
        });

        // 페이지 로드 시 이전에 선택한 테마가 있다면 표시
        window.addEventListener('load', function() {
            const savedThemes = JSON.parse(localStorage.getItem('selectedThemes') || '[]');
            if (savedThemes.length > 0) {
                document.querySelectorAll('.location-item').forEach(item => {
                    if (savedThemes.includes(item.textContent)) {
                        item.classList.add('selected');
                        selectedThemes.add(item.textContent);
                    }
                });
            }
        });
    </script>
</body>
</html> 