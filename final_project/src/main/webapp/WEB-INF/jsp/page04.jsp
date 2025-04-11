<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>여행 추천 시스템</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dcd5c4bab6de479a15aa752115990e79&autoload=false"></script>
    <style>
        /* 전체 스타일 */
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
        
        /* 왼쪽 섹션 스타일 */
        .left-section {
            width: 30%;
            display: flex;
            flex-direction: column;
            background-color: #fff;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        }
        
        /* 지도 컨테이너 */
        .map-container {
            height: 50%;
            width: 100%;
            position: relative;
            border-bottom: 1px solid #eaeaea;
        }
        
        /* 여행 정보 섹션 */
        .travel-info {
            height: 50%;
            padding: 20px;
            overflow-y: auto;
            position: relative;
        }
        
        /* 여행 코스 스타일 */
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
        
        /* 검색 기록 섹션 */
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
        
        /* 이전 버튼 */
        .back-button {
            position: absolute;
            bottom: 20px;
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
        
        /* 챗봇 섹션 */
        .chatbot-section {
            width: 35%;
            background-color: #fbfbfb;
            padding: 30px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        
        .chatbot-section h2 {
            margin-bottom: 30px;
            color: #333;
            text-align: center;
        }
        
        /* 검색 관련 스타일 */
        .search-container {
            display: flex;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 30px;
            overflow: hidden;
        }
        
        .search-input {
            flex: 1;
            padding: 15px 20px;
            border: none;
            font-size: 16px;
            outline: none;
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
                        <!-- 여행 상세 정보 -->
                        <div class="travel-details">
                            <div class="detail-item">
                                <span>총 이동거리:</span>
                                <span>${totalDistance}</span>
                            </div>
                            <div class="detail-item">
                                <span>이동 지역:</span>
                                <span>${locations}</span>
                            </div>
                            <div class="detail-item">
                                <span>추천 여행지:</span>
                                <span>${recommendedPlaces}</span>
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
        // 카카오맵 초기화 함수
        function initMap() {
            // 지도를 표시할 컨테이너 요소
            var mapContainer = document.getElementById('map');
            if (!mapContainer) {
                console.error('지도 컨테이너를 찾을 수 없습니다.');
                return;
            }

            // 지도 옵션 설정
            var mapOption = {
                center: new kakao.maps.LatLng(37.5012, 127.0396), // 강남역 좌표
                level: 3 // 지도 확대 레벨
            };

            try {
                // 지도 생성
                var map = new kakao.maps.Map(mapContainer, mapOption);

                // 마커 위치 정의
                var positions = [
                    {
                        title: '강남역',
                        latlng: new kakao.maps.LatLng(37.5012, 127.0396)
                    },
                    {
                        title: '선릉역',
                        latlng: new kakao.maps.LatLng(37.5045, 127.0492)
                    },
                    {
                        title: '역삼역',
                        latlng: new kakao.maps.LatLng(37.5004, 127.0367)
                    }
                ];

                // 마커 생성
                positions.forEach(function(position) {
                    var marker = new kakao.maps.Marker({
                        map: map,
                        position: position.latlng,
                        title: position.title
                    });

                    // 인포윈도우 생성
                    var infowindow = new kakao.maps.InfoWindow({
                        content: '<div style="padding:5px;font-size:12px;">' + position.title + '</div>'
                    });

                    // 마커 클릭 이벤트
                    kakao.maps.event.addListener(marker, 'click', function() {
                        infowindow.open(map, marker);
                    });
                });

                // 지도 컨트롤 추가
                var zoomControl = new kakao.maps.ZoomControl();
                map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

                console.log('지도가 성공적으로 로드되었습니다.');
            } catch (error) {
                console.error('지도 초기화 중 오류 발생:', error);
            }
        }

        // 카카오맵 SDK 로드 후 실행
        kakao.maps.load(function() {
            initMap();
        });
    </script>
</body>
</html>