<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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
				<img src="image/logo.png" class="logo" alt="로고" class="logo">
				<div class="page-indicator">
					<strong>01 02 03 -----</strong>
				</div>
			</div>

			<div class="content-section">
				<h1 class="title">여행에서 원하는 테마를 지정해 주세요.</h1>
				<h3 class="subtitle">(최소 2개 ~ 최대 4개)</h3>

                <div class="location-grid">
                    <div class="location-item">자연</div>
                    <div class="location-item">액티비티</div>
                    <div class="location-item">축제</div>
                    <div class="location-item">쇼핑</div>
                    <div class="location-item">음식점</div>
                    <div class="location-item">문화예술역사</div>
                    <div class="location-item">캠핑</div>
                    <div class="location-item">가족</div>
                    <div class="location-item">나홀로</div>
                </div>
                <form id="choose_form" action="/cwtestAPIre" method="post">
                	<input type="hidden" name="high_loc" value="${param.areaCode}"/>
                	<input type="hidden" name="low_loc" value="${param.sigunguCode}"/>
                	<input type="hidden" name="days" value="${param.days}"/>
                </form>

				<input type="hidden" id="selectedThemes" name="themes" value="">

    <script>
    	const areaCodeP = "${param.areaCode}"
        const sigunguCodeP = "${param.sigunguCode}"
        const daysP = "${param.days}"
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

            const form = document.getElementById('choose_form'); // 전송할 폼
            
            const page = document.querySelector('.page');
            page.classList.add('slide-out');
            
            selectedThemes.forEach(function(theme){
            	//자연 액티비티 축제 쇼핑 음식점 문화예술역사 캠핑 가족 나홀로
            	if(theme=="자연"){
                    const input1 = document.createElement("input"); // 추가할 내용
                    input1.name = "theme"
            		input1.value = "A01"
            		form.appendChild(input1)
            	}
            	if(theme=="액티비티"){
                    const input2 = document.createElement("input"); // 추가할 내용
                    input2.name = "theme"
            		input2.value = "A03"
            		form.appendChild(input2)
            	}
            	if(theme=="축제"){
                    const input3 = document.createElement("input"); // 추가할 내용
                    input3.name = "theme"
            		input3.value = "A0207"
            		form.appendChild(input3)
            		
                    const input4 = document.createElement("input"); // 추가할 내용
                    input4.name = "theme"
            		input4.value = "A0208"
            		form.appendChild(input4)
            	}
            	if(theme=="쇼핑"){
                    const input5 = document.createElement("input"); // 추가할 내용
                    input5.name = "theme"
            		input5.value = "A04"
            		form.appendChild(input5)
            	}
            	if(theme=="음식점"){
            		const input6 = document.createElement("input"); // 추가할 내용
                    input6.name = "theme"
            		input6.value = "A05"
            		form.appendChild(input6)
            		const input7 = document.createElement("input"); // 추가할 내용
                    input7.name = "theme"
            		input7.value = "C0117"
            		form.appendChild(input7)
            	}
            	if(theme=="문화예술역사"){
            		const input8 = document.createElement("input"); // 추가할 내용
                    input8.name = "theme"
            		input8.value = "A0201"
            		form.appendChild(input8)
            		const input9 = document.createElement("input"); // 추가할 내용
                    input9.name = "theme"
            		input9.value = "A0202"
            		form.appendChild(input9)
            		const input10 = document.createElement("input"); // 추가할 내용
                    input10.name = "theme"
            		input10.value = "A0203"
            		form.appendChild(input10)
            		const input11 = document.createElement("input"); // 추가할 내용
                    input11.name = "theme"
            		input11.value = "A0204"
            		form.appendChild(input11)
            		const input12 = document.createElement("input"); // 추가할 내용
                    input12.name = "theme"
            		input12.value = "A0205"
            		form.appendChild(input12)
            		const input13 = document.createElement("input"); // 추가할 내용
                    input13.name = "theme"
            		input13.value = "A0206"
            		form.appendChild(input13)
            	}
            	if(theme=="캠핑"){
            		const input14 = document.createElement("input"); // 추가할 내용
                    input14.name = "theme"
            		input14.value = "C0116"
            		form.appendChild(input14)
            	}
            	if(theme=="가족"){
            		const input15 = document.createElement("input"); // 추가할 내용
                    input15.name = "theme"
            		input15.value = "C0112"
            		form.appendChild(input15)
            	}
            	if(theme=="나홀로"){
            		const input16 = document.createElement("input"); // 추가할 내용
                    input16.name = "theme"
            		input16.value = "C0113"
            		form.appendChild(input16)
            	}

        		form.submit();
            })
            
            // 선택된 테마 정보를 localStorage에 저장
            // localStorage.setItem('selectedThemes', JSON.stringify([...selectedThemes]));
            
            // setTimeout(() => {
            //     location.href = '/ask';
            // }, 500);
        });

        // 이전 버튼 클릭 이벤트
        document.getElementById('prevBtn').addEventListener('click', function() {
            location.href = '/page2?areaCode='+areaCodeP
            		+'&sigunguCode='+sigunguCodeP
            		+'&days='+daysP;
        });
/*         // 페이지 로드 시 이전에 선택한 테마가 있다면 표시
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
        }); */
    </script>
</body>
</html>
