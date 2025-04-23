<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- JSTL core 태그 라이브러리 선언 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AI 응답 페이지</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f3925101927bde5acf150ddd5f551f63"></script>
<%-- TODO: 카카오 앱 키를 실제 값으로 변경하세요 --%>
<style>
/* 전체 스타일 (이전과 동일) */
body {
	font-family: 'Noto Sans KR', sans-serif;
	margin: 0;
	padding: 0;
	background-color: #f5f5f5;
}

.container {
	display: flex;
	height: 100vh;
	overflow: hidden;
}

/* 왼쪽 섹션 스타일 (이전과 동일) */
.left-section {
	width: 33%;
	display: flex;
	flex-direction: column;
}

.middle-section {
	width: 33%;
	display: flex;
	flex-direction: column;
}

/* 지도 컨테이너 (이전과 동일) */
.map-container {
	position: relative;
	height: 50%;
	width: 100%;
	position: relative;
	border-bottom: 1px solid #eaeaea;
}

.kakaoMarkerContent {
	padding: 5px;
	font-size: 12px;
	text-align: center;
	width: 100px;
}

/* 여행 정보 섹션 (이전과 동일) */
.travel-info {
	position: relative;
	height: 90%;
	padding: 20px;
	overflow-y: auto;
	position: relative;
}

/* 여행 코스 스타일 (이전과 동일) */
.course-container {
	position: relative;
	margin-bottom: 20px;
}

.schedule-circle {
	position: absolute;
	top: -15px;
	left: 20px;
	width: 60px;
	height: 60px;
	background-color: #ff6b6b;
	color: white;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: bold;
	z-index: 1;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.course-box {
	background-color: #1a73e8;
	color: white;
	border-radius: 10px;
	padding: 20px;
	padding-top: 30px;
	margin-top: 15px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.course-box h2 {
	margin-top: 0;
	font-size: 18px;
}

.travel-details {
	margin-top: 15px;
}

.detail-item {
	display: flex;
	justify-content: space-between;
	margin-bottom: 8px;
}

/* 검색 기록 섹션 (이전과 동일 - 하드코딩된 상태) */
.search-history-section {
	background-color: #f9f9f9;
	border-radius: 8px;
	padding: 15px;
	margin-top: 20px;
}

.search-history-section h3 {
	margin-top: 0;
	font-size: 16px;
	color: #333;
}

.search-history-list {
	list-style-type: none;
	padding: 0;
	margin: 0;
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}

.search-history-list li {
	background-color: #eef2ff;
	padding: 5px 10px;
	border-radius: 15px;
	font-size: 14px;
	color: #4a4a4a;
	cursor: pointer;
}

.search-history-scroll {
	max-height: 200px; /* 높이 제한 */
	overflow-y: auto; /* 스크롤 생김 */
	padding-right: 10px;
}

.history-group {
	margin-bottom: 15px;
}

.chatList-title {
	font-weight: bold;
	font-size: 14px;
	color: #555;
	margin-bottom: 5px;
}

/* 이전 버튼 (이전과 동일) */
.back-button {
	position: relative;
	bottom: 0px;
	right: 20px;
	padding: 10px 20px;
	background-color: #f0f0f0;
	color: #333;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	transition: background-color 0.3s;
}

.back-button:hover {
	background-color: #e0e0e0;
}

/* 검색 결과 섹션 (이전과 동일) */
.query-result {
	width: 33%; /* 필요시 조정 */
	padding: 30px;
	display: flex;
	flex-direction: column;
	position: relative; /* 하단 검색창 고정을 위해 */
	height: calc(100vh - 60px); /* padding 고려 */
	box-sizing: border-box;
}

.query-result p {
	margin-bottom: 20px;
	color: #555;
}

.ai-response {
	background-color: #f8f9fa;
	border-radius: 10px;
	padding: 20px;
	margin-bottom: 20px; /* 검색창과의 간격 */
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
	flex-grow: 1;
	overflow-y: auto; /* 내용 길어질 시 스크롤 */
}

.ai-response h3 {
	color: #1a73e8;
	margin-top: 0;
	margin-bottom: 15px;
	border-bottom: 1px solid #e0e0e0;
	padding-bottom: 10px;
}

.response-content {
	color: #333;
	line-height: 1.6;
}

/* 검색 관련 스타일 (이전과 동일) */
.search-container {
	display: flex;
	width: 100%;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
	border-radius: 30px;
	overflow: hidden;
	background-color: #fff; /* 배경 추가 */
}

.search-input {
	flex: 1;
	padding: 15px 20px;
	border: none;
	font-size: 16px;
	outline: none;
}

/* 검색 폼 위치 조정 */
.search-form-wrapper {
	position: absolute;
	bottom: 30px; /* 하단 간격 */
	left: 30px; /* 왼쪽 정렬 */
	right: 30px; /* 오른쪽 간격 */
	width: calc(100% - 60px); /* 양쪽 패딩 고려 */
}

.search-button {
	padding: 15px 25px;
	background-color: #1a73e8;
	color: white;
	border: none;
	cursor: pointer;
	font-weight: bold;
	transition: background-color 0.3s;
}

.search-button:hover {
	background-color: #155fba;
}

/* 검색 폼 위치 조정 */
.search-form-wrapper {
	position: absolute;
	bottom: 30px; /* 하단 간격 */
	left: 30px; /* 왼쪽 정렬 */
	right: 30px; /* 오른쪽 간격 */
	width: calc(100% - 60px); /* 양쪽 패딩 고려 */
}

.travelAreaInfo {
	padding: 0;
	margin: 0;
}
/* 이미지 스피너 */
.image-container {
	position: relative;
}

.spinner-overlay {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	display: flex;
	justify-content: center;
	align-items: center;
	z-index: 10;
}

.image {
	object-fit: cover;
	display: none; /* 로딩 전까지 숨김 */
}
</style>
</head>
<body>
	<jsp:include page="header.jsp" />
	<div class="container">
		<!-- 왼쪽 섹션 -->
		<div class="left-section">
			<!-- 지도 -->
			<div class="map-container" id="map"></div>
			<!-- 이전 검색 기록 섹션 -->
			<div class="search-history-section">
				<h3>이전 검색 기록</h3>

				<div class="search-history-scroll">
					<c:forEach var="chatList" items="${chatList}" varStatus="status">
						<div class="qna-box">
							<div class="chatList-date">
								<c:out value="${dateLabels[status.index]}" />
							</div>
							<div class="chatList-title"
								data-chat-id="${chatList.chat_log_id}">
								<c:out value="${chatList.title}" />
							</div>
						</div>
					</c:forEach>
				</div>
			</div>
		</div>
		<!-- 가운데 섹션 -->
		<div class="middle-section">
			<!-- 여행 정보 -->
			<div class="travel-info">
				<!-- 여행 코스 컨테이너 -->
				<div class="course-container">
					<!-- 원형 일정 (하드코딩 유지) -->
					<div class="schedule-circle">당일</div>

					<!-- 파란색 여행 코스 박스 -->
					<div class="course-box">
						<h2>${sessionScope.SessionMember.email}님을위한여행코스</h2>
						<div class="travel-details">
							<%-- 컨트롤러에서 전달된 AI 응답 (여행 코스 관련) --%>
							<c:forEach var="location" items="${areaListO}" varStatus="status">
								<hr>
								<div class="travelAreaInfo">${status.index+1}번째여행지</div>
								<div class="travelAreaInfo">${location.title}</div>
								<div class="travelAreaInfo">${location.addr1}</div>
								<div class="image-container">
									<div class="spinner-overlay">
										<div class="spinner-border" role="status">
											<span class="visually-hidden">Loading...</span>
										</div>
									</div>
									<img class="image" src="${location.firstimage}" alt="여행 이미지"
										width="270" />
								</div>
								<c:if test="${status.last}">
									<hr>
								</c:if>
							</c:forEach>
						</div>
					</div>
				</div>



				<!-- 이전 화면 버튼 -->
				<button class="back-button" onclick="location.href='project1'">
					메인페이지로 이동</button>
			</div>
		</div>
		<!-- 검색 결과 섹션 -->
		<div class="query-result">
			<%-- c:out을 사용하여 XSS 방지 --%>
			<p>
				검색어:
				<c:out value="${param.query}" default="질문 없음" />
			</p>
			<div class="ai-response">
				<h3>AI 응답:</h3>
				<!--<div class="response-content" id="aiResponseContainer">
					<%-- 컨트롤러에서 전달된 aiResponse 출력 (백엔드에서 <br> 처리했으므로 escapeXml=false) --%>
					<c:out value="${requestScope.aiResponse}" escapeXml="false"
						default="이곳에 AI 모델의 응답이 표시됩니다." />
				</div>-->
				<!-- 채팅 로그 영역 -->


				<!-- QnA 리스트 영역 (필요한 경우 추가) -->
				<div id="qnaContainer"></div>
			</div>

			<!-- 검색 폼 (위치 조정됨) -->
			<div class="search-form-wrapper">
				<div class="search-container">
					<%-- 입력값 유지 시에도 c:out 사용 --%>
					<input type="text" id="query" class="search-input"
						placeholder="무엇이든 물어보세요" value="<c:out value='${param.query}'/>">
					<button type="button" class="search-button" id="searchButton">검색</button>
				</div>
			</div>
		</div>
	</div>

	<script>
		$(document).ready(function () {
		    // chatList.title 클릭 이벤트 핸들링
		    $(document).on("click", ".chatList-title", function () {
		        const chatLogId = $(this).data("chat-id");

		        if (!chatLogId) {
		            alert("chat_log_id가 존재하지 않습니다.");
		            return;
		        }

		        $.ajax({
		            url: "/callQna", // SpringBoot Controller의 매핑 주소
		            method: "GET",
		            data: { chatLogId: chatLogId },
		            dataType: "json",
		            success: function (response) {
		                if (response.qnaList && response.qnaList.length > 0) {
		                    let qnaHtml = "<ul>";
		                    response.qnaList.forEach(function (qnaItem) {
		                        qnaHtml += "<li><strong>" + qnaItem.question + ":</strong> " + qnaItem.answer + "</li>";
		                    });
		                    qnaHtml += "</ul>";
		                    $("#qnaContainer").html(qnaHtml);
		                } else {
		                    $("#qnaContainer").html("<p>해당 대화에 대한 QnA가 없습니다.</p>");
		                }
		            },
		            error: function () {
		                alert("QnA 데이터를 불러오는 중 오류가 발생했습니다.");
		            }
		        });
		    });
		}); 
		// 검색 버튼 클릭 시 AJAX 요청을 보냄
				        $("#searchButton").on("click", function() {
				            var query = $("#query").val().trim();

				            if (query === "") {
				                alert("질문을 입력해주세요.");
				                return;
				            }

				            // 비동기적으로 서버에 요청 보내기
				            $.ajax({
				                url: "/chat.do",  // JHController에서 처리되는 URL
				                method: "GET",
				                data: { query: query },  // query 파라미터 전송
				                dataType: "json",  // 응답 형식 JSON
				                success: function(response) {
				                    // 응답 받은 데이터를 사용해 페이지 업데이트
				                    if (response.aiResponse) {
				                        $("#aiResponseContainer").html(response.aiResponse);
				                    }

				                    if (response.chatList && response.chatList.length > 0) {
				                        var chatHtml = "<ul>";
				                        response.chatList.forEach(function(chatItem) {
				                            chatHtml += "<li>" + chatItem.message + "</li>";
				                        });
				                        chatHtml += "</ul>";
				                        $("#chatLogContainer").html(chatHtml);
				                    }

				                    // 추가적으로 QnA 리스트가 있다면 표시
				                    if (response.qnaList && response.qnaList.length > 0) {
				                        var qnaHtml = "<ul>";
				                        response.qnaList.forEach(function(qnaItem) {
				                            qnaHtml += "<li><strong>" + qnaItem.question + ":</strong> " + qnaItem.answer + "</li>";
				                        });
				                        qnaHtml += "</ul>";
				                        $("#qnaContainer").html(qnaHtml);
				                    }
				                },
				                error: function() {
				                    alert("응답 처리 중 오류가 발생했습니다.");
				                }
				            });
							
				        });
						// Enter 키를 눌렀을 때 검색 버튼 클릭 이벤트 발생
						   $("#query").on("keypress", function(e) {
						       if (e.which === 13) {  // Enter 키의 keyCode는 13
						           $("#searchButton").click();  // 검색 버튼 클릭
						       }
						   }); 
	
	var locations = [
		<c:forEach var="location" items="${areaListO}"  varStatus="status">
			{
				title : "${location.title}",
				mapx : ${location.mapx},
	    		mapy : ${location.mapy}
			}<c:if test="${!status.last}">,</c:if>
		</c:forEach>
	];
	var sumX = 0
	//console.log("1 :"+sumX)
	var sumY = 0
	
	for (var i = 0; i < locations.length; i++) {
		sumX += locations[i]["mapx"];
		//console.log("2 :"+sumX)
		sumY += locations[i]["mapy"];
	}
	
	var X = sumX/(locations.length);
	//console.log("3 :"+X)
	var Y = sumY/(locations.length);
	
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	mapOption = { 
    	center: new kakao.maps.LatLng(Y, X), // 지도의 중심좌표
    	level: 11 // 지도의 확대 레벨
	};

	//지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
	var map = new kakao.maps.Map(mapContainer, mapOption);
	
	for (var i = 0; i < locations.length; i++) {
		/*
	    var sx = locations[i]["mapx"];  // lng
	    var sy = locations[i]["mapy"];  // lat
		//길찾기 API 호출
	    drawKakaoMarker(sx,sy);
		*/
	    //길찾기 API 호출
	    drawKakaoMarker(locations[i]["mapx"],locations[i]["mapy"],locations[i]["title"]);
	}
	
	// 지도위 마커 표시해주는 함수
	function drawKakaoMarker(x,y,message){
		var marker = new kakao.maps.Marker({
		    position: new kakao.maps.LatLng(y, x),
		    map: map
		});
		var iwContent = '<div style="padding: 5px; text-align: center;">'+message+'</div>'; // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다

		// 인포윈도우를 생성합니다
		var infowindow = new kakao.maps.InfoWindow({
		    content : iwContent
		});
		// 마커에 마우스오버 이벤트를 등록합니다
		kakao.maps.event.addListener(marker, 'mouseover', function() {
		  // 마커에 마우스오버 이벤트가 발생하면 인포윈도우를 마커위에 표시합니다
		    infowindow.open(map, marker);
		});

		// 마커에 마우스아웃 이벤트를 등록합니다
		kakao.maps.event.addListener(marker, 'mouseout', function() {
		    // 마커에 마우스아웃 이벤트가 발생하면 인포윈도우를 제거합니다
		    infowindow.close();
		});
	}

    // 지도 컨트롤 추가
    var mapTypeControl = new kakao.maps.MapTypeControl();
    map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
    var zoomControl = new kakao.maps.ZoomControl();
    map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
		
		const containers = document.querySelectorAll(".image-container");

		containers.forEach(container => {
		  const img = container.querySelector("img.image");
		  const spinner = container.querySelector("div.spinner-overlay");

		  img.onload = () => {
		    spinner.style.display = 'none';
		    img.style.display = 'block';
		  };

		  img.onerror = () => {
		    spinner.innerHTML = '<span class="text-danger"></span>';
		  };
		});
    </script>
	<jsp:include page="header2.jsp" />
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>