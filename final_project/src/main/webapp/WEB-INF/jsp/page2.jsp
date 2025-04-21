<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>기간 선택</title>
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
	<div class="header">
	 	<jsp:include page="header.jsp" />	      
	</div>
	<div class="page">
		<div class="container">			

			<div class="content-section">
				<h1 class="title">여행을 떠나고 싶은 일자를 선택해 주세요</h1>
				<form id="locationForm" action="/page4" method="post">
					<input type="hidden" id="selectedDuration" name="duration" value="">

                <div class="location-grid">
                    <div id="oneDay" class="location-item">당일 여행</div>
                    <div id="twoDay" class="location-item">1박 2일</div>
                    <div id="triDay" class="location-item">2박 3일</div>
                </div>

					<script>
			        function selectDuration(element) {
			            const selectedValue = parseInt(element.getAttribute('value'));
			            document.getElementById('selectedDuration').value = selectedValue;
			        }
			    </script>
				</form>
					<div class="navigation">
						<button class="nav-button" id="prevBtn">이전</button>
						<button class="nav-button" id="nextBtn">다음</button>
					</div>
			</div>
		</div>
	</div>

	<script>
        let selectedLocation = null;
    	const areaCodeP = "${param.areaCode}"
        const areaCodeSP = "${param.areaCodeS}"
        const sigunguCodeP = "${param.sigunguCode}"
        const sigunguCodeSP = "${param.sigunguCodeS}"
        const daysP = "${param.days}"

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
                    //console.log(selectedLocation.textContent)
                }
            });
        });

        // 다음 버튼 클릭 이벤트
        document.getElementById('nextBtn').addEventListener('click', function() {
            if (!selectedLocation) {
                alert('일정을 선택해 주세요.');
                return;
            }
            const page = document.querySelector('.page');
            page.classList.add('slide-out');
            
            let days = 0;
        	const daysS = selectedLocation.textContent
            if(selectedLocation.textContent=="당일 여행"){
            	days = 1;
            }else if(selectedLocation.textContent=="1박 2일"){
            	days = 2;
            }else if(selectedLocation.textContent=="2박 3일"){
            	days = 3;
            }
            
            // 선택된 일정 정보를 localStorage에 저장
            //localStorage.setItem('selectedDuration', selectedLocation.textContent);
            localStorage.setItem('selectedAreaCode', selectedLocation.textContent);
            //localStorage.setItem('selectedAreaCode', areaCode);
            setTimeout(() => {
                location.href = '/page3?areaCode='+areaCodeP+"&areaCodeS="+areaCodeSP
                		+"&sigunguCode="+sigunguCodeP+"&sigunguCodeS="+sigunguCodeSP
                		+"&days="+days;
            }, 500);
        });

        // 이전 버튼 클릭 이벤트
        document.getElementById('prevBtn').addEventListener('click', function () {
            //const areaCode = localStorage.getItem('selectedMainAreaCode');

            if(sigunguCodeSP){
                setTimeout(() => {
                	location.href = '/area/subregions?areaCode='+ areaCodeP
        					+ "&areaCodeS=" + areaCodeSP
                			+ "&sigunguCodeS=" + sigunguCodeSP;
                }, 500);
            }else{
                setTimeout(() => {
                	location.href = '/mainarea/regions?areaCodeS='+ areaCodeSP;
                }, 500);
            }
        });

         // 페이지 로드 시 이전에 선택한 일정이 있다면 표시
        window.addEventListener('load', function() {
            //const savedDuration = localStorage.getItem('selectedDuration');
            if (daysP==1) {
            	document.getElementById("oneDay").classList.add('selected');
            }else if (daysP==2) {
            	document.getElementById("twoDay").classList.add('selected');
            }else if (daysP==3) {
            	document.getElementById("triDay").classList.add('selected');
            }
            /*
            if (savedDuration) {
                document.querySelectorAll('.location-item').forEach(item => {
                    if (item.textContent.trim() === daysSP.trim()) {//savedDuration
                        item.classList.add('selected');
                        selectedLocation = item;
                    }
                });
            }
            */
        }); 
    </script>   
    <jsp:include page="header2.jsp" />	      
</body>
</html>
