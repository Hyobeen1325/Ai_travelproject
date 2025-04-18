<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>세부 지역 선택</title>
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
            transition: all 0.3s ease;
            border: 1px solid #e0e0e0;
            position: relative;
            overflow: hidden;
        }
        .location-item:hover {
            transform: translateY(-5px);
            background-color: #4a90e2;
            color: white;
            box-shadow: 0 5px 15px rgba(74, 144, 226, 0.3);
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
				<img src="/image/logo.png" alt="로고" class="logo">
				<div class="page-indicator">
					<strong>01 ----- 02 03</strong>
				</div>
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
								<div class="location-item" data-code="${item.code}">${item.name}</div>
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
    	const areaCodeP = "${param.areaCode}"
        const areaCodeSP = "${param.areaCodeS}"
        const sigunguCodeSP = "${param.sigunguCodeS}"
        
	    window.addEventListener('load', function () {
	        let selectedLocation = null;
	
	        // 이전에 선택한 지역 표시
	        // const savedLocation = localStorage.getItem('selectedDetailLocation');
	        // if (savedLocation) {
	        if (sigunguCodeSP) {
	            document.querySelectorAll('.location-item').forEach(item => {
	                if (item.textContent.trim() === sigunguCodeSP.trim()) { // savedLocation.trim()
	                    item.classList.add('selected');
	                    selectedLocation = item;
	                }
	            });
	        }
	
	        // 지역 선택 이벤트
	        document.querySelectorAll('.location-item').forEach(item => {
	            item.addEventListener('click', function () {
	                if (selectedLocation === this) {
	                    this.classList.remove('selected');
	                    selectedLocation = null;
	                } else {
	                    if (selectedLocation) {
	                        selectedLocation.classList.remove('selected');
	                    }
	                    this.classList.add('selected');
	                    selectedLocation = this;
	                }
	            });
	        });
	
	        // 다음 버튼 클릭 시
	        document.getElementById('nextBtn').addEventListener('click', function () {
	            if (!selectedLocation) {
	                alert('지역을 선택해 주세요.');
	                return;
	            }
	            const sigunguCode = selectedLocation.getAttribute('data-code');
	            const sigunguCodeS = selectedLocation.textContent;
	            //localStorage.setItem('selectedDetailLocation', selectedLocation.textContent.trim());
	
	            // 이동 처리
                setTimeout(() => {
                    location.href = '/page2?areaCode='+ areaCodeP + "&areaCodeS=" + areaCodeSP
                    		+'&sigunguCode='+sigunguCode +'&sigunguCodeS='+sigunguCodeS;
                }, 500);
	        });
	
	        // 이전 버튼 클릭 시
	        document.getElementById('prevBtn').addEventListener('click', function () {
	        	//const numOfRows = localStorage.getItem('selectedDetailLocation');
	        	//const numOfRows = '${numOfRows}';
                //setTimeout(() => {
                    location.href = '/mainarea/regions?areaCodeS=' + areaCodeSP;
                //}, 500);
	        	// window.location.href = '/mainarea/regions?numOfRows=' + numOfRows;
	        });
	    });
	</script>

</body>
</html>