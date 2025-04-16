 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>여행 추천 시스템</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dcd5c4bab6de479a15aa752115990e79&autoload=false"></script>
	<style>
	    body {
	        font-family: 'Noto Sans KR', sans-serif;
	        margin: 0;
	        padding: 0;
	        background-color: #f0f2f5;
	    }

	    .container {
	        display: flex;
	        height: 100vh;
	        overflow: hidden;
	        background-color: #f5f5f5;
	    }

	    /* 왼쪽 섹션 */
	    .left-section {
	        width: 40%;
	        display: flex;
	        flex-direction: column;
	        background-color: #fff;
	        box-shadow: 2px 0 8px rgba(0, 0, 0, 0.05);
	    }

	    /* 지도 영역 */
	    .map-container {
	        height: 50%;
	        border-bottom: 1px solid #e0e0e0;
	    }

	    /* 여행 정보 (AI 응답 출력) */
	    .travel-info {
	        height: 50%;
	        padding: 20px;
	        overflow-y: auto;
	    }

	    .course-box {
	        background-color: #1a73e8;
	        color: white;
	        border-radius: 12px;
	        padding: 20px;
	        box-shadow: 0 3px 12px rgba(0, 0, 0, 0.08);
	    }

	    .course-box h2 {
	        margin: 0 0 15px 0;
	        font-size: 18px;
	    }

	    .travel-details {
	        white-space: pre-wrap;
	        font-size: 14px;
	        line-height: 1.6;
	        background-color: rgba(255, 255, 255, 0.1);
	        padding: 10px;
	        border-radius: 8px;
	    }

	    /* 반응형 처리 */
	    @media (max-width: 768px) {
	        .container {
	            flex-direction: column;
	        }

	        .left-section {
	            width: 100%;
	            height: auto;
	        }

	        .map-container,
	        .travel-info {
	            height: auto;
	        }
	    }
	</style>

</head>
<body>
    <div class="container">
        <!-- 왼쪽 섹션 -->
        <div class="left-section">
            <!-- 지도 -->
            <div class="map-container" id="map"></div>

			<!-- 여행 정보 -->
			<div class="travel-info">
			    <!-- 여행 코스 컨테이너 -->
			    <div class="course-container">
			        <!-- 원형 일정 -->
			        <div class="schedule-circle">당일</div>
			        
			        <!-- 파란색 여행 코스 박스 -->
			        <div class="course-box">
			            <h2>${username}님을 위한 여행 코스</h2>

			            <!-- AI 응답 내용만 출력 -->
			            <div class="travel-details">
			                <pre style="white-space: pre-wrap; font-size: 14px; color: #333;">
			${aiResponse2}
			                </pre>
			            </div>
			        </div>
			    </div>
			</div>


                <!-- 이전 검색 기록 섹션 -->
                <div class="search-history-section">
                    <h3>이전 검색 기록</h3>
                    <ul class="search-history-list">
                        <li>검색어 1</li>
                        <li>검색어 2</li>
                        <li>검색어 3</li>
                        <li>검색어 4</li>
                        <li>검색어 5</li>
                        <li>검색어 6</li>
                        <li>검색어 7</li>
                        <li>검색어 8</li>
                        <li>검색어 9</li>
                        <li>검색어 10</li>
                    </ul>
                </div>

                <!-- 이전 화면 버튼 -->
                <button class="back-button" onclick="history.back()">
                    이전
                </button>
            </div>
        </div>

        <!-- 챗봇 섹션 -->
        <div class="chatbot-section">
            <h2>${searchTitle}</h2>
			<form action="/ask" method="post" style="position: relative; bottom: 20px; width: 100%; left: 50%;">
			    <div class="search-container">
			        <input type="text" name="message" class="search-input" placeholder="무엇이든 물어보세요">
			        <button type="submit" class="search-button">검색</button>
			    </div>
			</form>

        </div>
    </div>

	<script>
	    kakao.maps.load(function () {
	        initMap();
	    });

	    function initMap() {
	        var mapContainer = document.getElementById('map');
	        if (!mapContainer) {
	            console.error('지도 컨테이너를 찾을 수 없습니다.');
	            return;
	        }

	        // 컨트롤러에서 넘어온 좌표값 (JSP Expression 사용)
	        var latitude = ${latitude != null ? latitude : 'null'};
	        var longitude = ${longitude != null ? longitude : 'null'};

	        if (latitude === null || longitude === null) {
	            mapContainer.innerHTML = '<p>지도 좌표 정보가 없습니다.</p>';
	            return;
	        }

	        // 지도 옵션 설정 - 전달된 좌표 중심
	        var mapOption = {
	            center: new kakao.maps.LatLng(latitude, longitude),
	            level: 3
	        };

	        try {
	            var map = new kakao.maps.Map(mapContainer, mapOption);

	            // 마커 생성
	            var markerPosition = new kakao.maps.LatLng(latitude, longitude);
	            var marker = new kakao.maps.Marker({
	                position: markerPosition,
	                map: map,
	                title: '추천 위치'
	            });

	            // 인포윈도우 추가
	            var infowindow = new kakao.maps.InfoWindow({
	                content: '<div style="padding:5px;font-size:13px;">추천 위치</div>'
	            });
	            infowindow.open(map, marker);

	            // 확대/축소 컨트롤 추가
	            var zoomControl = new kakao.maps.ZoomControl();
	            map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

	            console.log('동적 좌표로 지도 로드 완료');

	        } catch (error) {
	            console.error('지도 초기화 중 오류 발생:', error);
	        }
	    }
	</script>
</body>
</html>