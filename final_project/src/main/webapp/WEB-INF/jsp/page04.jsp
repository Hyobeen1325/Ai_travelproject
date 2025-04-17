<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%-- JSTL 사용을 위해 추가 --%>
<%
    // 세션에서 email 가져오기 (실제 로그인 구현에 따라 키가 다를 수 있음)
    String username = (String) session.getAttribute("email");
    // email이 없으면 기본값 또는 로그인 페이지로 리다이렉트 등의 처리 필요
    if (username == null) {
        username = "방문자"; // 예시 기본값
    }
    request.setAttribute("username", username);

    // 더미 데이터 또는 컨트롤러에서 전달된 데이터 (실제로는 컨트롤러에서 모델에 담아 전달)
    // request.setAttribute("aiResponse2", "AI 응답 내용..."); // 여행 코스 박스용 AI 응답
    // request.setAttribute("latitude", 37.5665); // 예시 위도
    // request.setAttribute("longitude", 126.9780); // 예시 경도
    // request.setAttribute("searchTitle", "여행 챗봇");
    // request.setAttribute("aiResponse", "챗봇 응답 내용..."); // 챗봇 섹션용 AI 응답

    // 검색 기록 (실제로는 컨트롤러에서 모델에 담아 전달)
    // java.util.List<com.yourpackage.dto.HistoryGroup> historyList = new java.util.ArrayList<>();
    // com.yourpackage.dto.HistoryGroup group1 = new com.yourpackage.dto.HistoryGroup("2023-10-27");
    // group1.addTitle("서울 맛집");
    // group1.addTitle("부산 1박2일");
    // historyList.add(group1);
    // com.yourpackage.dto.HistoryGroup group2 = new com.yourpackage.dto.HistoryGroup("2023-10-26");
    // group2.addTitle("강릉 당일치기");
    // historyList.add(group2);
    // request.setAttribute("historyList", historyList);

    // --- 더미 데이터 객체 (위 historyList 예시를 위해) ---
    // 실제 프로젝트에서는 해당 클래스가 존재해야 합니다.
    /*
    package com.yourpackage.dto;
    import java.util.ArrayList;
    import java.util.List;
    public class HistoryGroup {
        private String regDate;
        private List<String> titles = new ArrayList<>();
        public HistoryGroup(String regDate) { this.regDate = regDate; }
        public String getRegDate() { return regDate; }
        public List<String> getTitles() { return titles; }
        public void addTitle(String title) { this.titles.add(title); }
    }
    */

%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>여행 추천 시스템</title>
    <%-- 카카오 지도 API 키. 실제 키로 교체해야 합니다. --%>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dcd5c4bab6de479a15aa752115990e79&autoload=false"></script>
    <style>
        /* 전체 스타일 */
        body {
            font-family: 'Noto Sans KR', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            height: 100vh; /* 추가: body 높이 100% */
            display: flex; /* 추가: body를 flex 컨테이너로 */
        }

        .container {
            display: flex;
            /* height: 100vh; 제거: body에서 높이 관리 */
            flex-grow: 1; /* 추가: body의 남은 공간 모두 차지 */
            overflow: hidden;
            gap: 10px;
            padding: 10px;
            box-sizing: border-box;
        }

        .left-section {
            width: 30%;
            min-width: 350px; /* 너비 약간 조정 */
            display: flex;
            flex-direction: column;
            background-color: #fff;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            /* overflow-y: auto; 제거: 내부 스크롤 관리 */
            border-radius: 10px;
            height: calc(100vh - 20px); /* 컨테이너 패딩 고려 */
        }

        .map-container {
            height: 30%;
            min-height: 200px; /* 최소 높이 지정 */
            width: 100%;
            position: relative;
            border-bottom: 1px solid #eaeaea;
            background-color: #e9e9e9; /* 지도 로딩 전 배경색 */
        }
        .map-container p { /* 지도 정보 없을 때 메시지 스타일 */
            text-align: center;
            padding-top: 80px;
            color: #777;
        }

        .travel-info {
            /* height: 50%; 제거: flex-grow로 관리 */
            flex-grow: 1; /* 남은 공간 차지 */
            padding: 20px;
            overflow-y: auto; /* 내용 많으면 스크롤 */
            position: relative; /* 이전 버튼 기준점 */
            display: flex; /* 내부 요소 정렬 위해 */
            flex-direction: column; /* 세로 정렬 */
        }

        .course-container {
            position: relative;
            margin-bottom: 20px;
        }

        .schedule-circle {
            position: absolute;
            top: -15px; /* 박스보다 위로 */
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
            padding-top: 50px; /* schedule-circle 공간 확보 */
            margin-top: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .course-box h2 {
            margin-top: 0;
            margin-bottom: 15px; /* 추가: 제목 아래 여백 */
            font-size: 18px;
        }

        .travel-details {
            /* margin-top: 15px; 제거: h2 아래 여백으로 조정 */
        }

        .travel-details pre { /* pre 태그 스타일 명시 */
            white-space: pre-wrap;
            word-wrap: break-word; /* 긴 단어 줄바꿈 */
            font-size: 14px;
            color: #ffffff; /* course-box 안이므로 흰색 */
            line-height: 1.6;
            margin: 0; /* pre 태그 기본 마진 제거 */
        }

        /* 검색 기록 섹션 */
        .search-history-section {
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 15px;
            margin-top: auto; /* 위 요소들을 밀어내고 아래쪽에 위치 */
            /* max-height: 250px; */ /* 최대 높이 제한 - 필요시 활성화 */
            /* overflow-y: auto; */ /* 최대 높이 제한 시 스크롤 */
        }

        .search-history-section h3 {
            margin-top: 0;
            margin-bottom: 10px; /* 제목 아래 여백 */
            font-size: 16px;
            color: #333;
            border-bottom: 1px solid #eee; /* 구분선 */
            padding-bottom: 8px; /* 구분선과의 여백 */
        }

        .search-history-scroll {
            max-height: 150px; /* 스크롤 영역 높이 제한 */
            overflow-y: auto;
            padding-right: 5px; /* 스크롤바 공간 */
        }
         /* 스크롤바 스타일 (선택적) */
        .search-history-scroll::-webkit-scrollbar {
            width: 6px;
        }
        .search-history-scroll::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 3px;
        }
        .search-history-scroll::-webkit-scrollbar-thumb {
            background: #ccc;
            border-radius: 3px;
        }
        .search-history-scroll::-webkit-scrollbar-thumb:hover {
            background: #aaa;
        }

        .history-group {
            margin-bottom: 15px;
        }
        .history-group:last-child {
            margin-bottom: 0; /* 마지막 그룹 아래 여백 제거 */
        }

        .reg-date {
            font-weight: bold;
            font-size: 13px; /* 약간 작게 */
            color: #555;
            margin-bottom: 8px; /* 리스트와의 간격 */
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
            padding: 6px 12px; /* 패딩 조정 */
            border-radius: 15px;
            font-size: 13px; /* 약간 작게 */
            color: #4a4a4a;
            cursor: pointer;
            transition: background-color 0.2s;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .search-history-list li:hover {
             background-color: #dbe4ff;
        }

        .back-button-container { /* 버튼을 감싸는 컨테이너 */
             padding: 15px 20px; /* travel-info 패딩과 맞춤 */
             text-align: right; /* 오른쪽 정렬 */
             border-top: 1px solid #eee; /* 구분선 */
             margin-top: 10px; /* 검색 기록 섹션과의 간격 */
        }

        .back-button {
            /* position: absolute; 제거 */
            /* bottom: 20px; 제거 */
            /* right: 20px; 제거 */
            padding: 10px 20px;
            background-color: #f0f0f0;
            color: #333;
            border: 1px solid #ddd; /* 테두리 추가 */
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-size: 14px;
        }

        .back-button:hover {
            background-color: #e0e0e0;
        }

        /* 챗봇 섹션 */
        .chatbot-section {
            width: 70%;
            min-width: 400px;
            background-color: #fafafa;
            padding: 30px;
            display: flex;
            flex-direction: column; /* 세로 배치 */
            /* justify-content: space-between; 제거 */
            box-sizing: border-box;
            border-radius: 10px;
            overflow-y: auto; /* 전체 섹션 스크롤 */
            flex-grow: 1; /* 남은 공간 채우도록 */
            height: calc(100vh - 20px); /* 컨테이너 패딩 고려 */
			
			
        }

        .chatbot-section h2 {
            font-size: 22px;
            color: #333;
            margin-top: 0; /* 추가 */
            margin-bottom: 20px;
        }

        /* 챗봇 form 스타일 */
        .chatbot-section form {
            margin-top: 0; /* h2 아래 여백으로 조정했으므로 제거 */
            margin-bottom: 30px; /* AI 응답 영역과의 여백 */
            width: 100%; /* 부모 요소 너비에 맞춤 */
        }

        .search-container {
            display: flex;
            width: 100%; /* form 너비에 맞춤 */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 30px;
            overflow: hidden;
            background-color: #fff;
        }

        .search-input {
            flex: 1;
            padding: 15px 20px;
            border: none;
            font-size: 16px;
            outline: none;
            border-radius: 30px 0 0 30px; /* 왼쪽만 둥글게 */
        }

        .search-button {
            padding: 15px 25px;
            background-color: #1a73e8;
            color: white;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
            border-radius: 0 30px 30px 0; /* 오른쪽만 둥글게 */
        }

        .search-button:hover {
            background-color: #155fba;
        }

        /* AI 응답 섹션 */
        .ai-response {
            background-color: #ffffff; /* 배경색 변경 */
            border: 1px solid #e0e0e0; /* 테두리 추가 */
            border-radius: 10px;
            padding: 20px;
            /* margin-bottom: 20px; 제거 */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            flex-grow: 1; /* 남은 세로 공간을 채우도록 */
            overflow-y: auto; /* 내용 길면 스크롤 */
            margin-top: 0; /* form 과의 여백은 form의 margin-bottom으로 조절 */
        }

        .ai-response h3 {
            color: #1a73e8;
            margin-top: 0;
            margin-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
            padding-bottom: 10px;
            font-size: 18px; /* 추가 */
        }

        .response-content {
            color: #333;
            line-height: 1.7; /* 줄 간격 조정 */
            font-size: 15px; /* 글자 크기 조정 */
            white-space: pre-wrap; /* 추가: AI 응답 내 줄바꿈 유지 */
            word-wrap: break-word; /* 추가: 긴 단어 줄바꿈 */
        }

        /* .search-form-wrapper 는 사용되지 않으므로 제거 */

    </style>

</head>
<body>
    <div class="container">
        <!-- 왼쪽 섹션 -->
        <div class="left-section">
            <!-- 지도 -->
            <div class="map-container" id="map">
                <%-- 지도는 아래 스크립트에서 로드됩니다 --%>
            </div>

            <!-- 여행 정보 -->
            <div class="travel-info">
                <!-- 여행 코스 컨테이너 -->
                <div class="course-container">
                    <!-- 원형 일정 -->
                    <div class="schedule-circle">
                        <%-- 일정 정보가 있다면 표시 (예: ${scheduleInfo}) --%>
                        정보
                    </div>

                    <!-- 파란색 여행 코스 박스 -->
                    <div class="course-box">
                        <h2>${username}님을 위한 여행 코스</h2>
                        <div class="travel-details">
                            <%-- 컨트롤러에서 전달된 AI 응답 (여행 코스 관련) --%>
                            <pre>${aiResponse2}</pre>
                        </div>
                    </div>
                </div>

                <!-- 이전 검색 기록 섹션 -->
                <div class="search-history-section">
                    <h3>이전 검색 기록</h3>
					<div class="search-history-scroll">
											<c:forEach var="chatlog" items="${chatList}">
											    <div class="qna-box">
											        <div class="chatlog-title"><c:out value="${chatlog.title}" /></div>
											        <div class="chatlog-date"><c:out value="${chatlog.uptDate}" /></div>   
											    </div>
											</c:forEach>
									    </div>
									</div>
                        <%-- 기록이 없을 경우 메시지 표시 (선택적) --%>
                        <c:if test="${empty historyList}">
                            <p style="text-align: center; color: #888; font-size: 14px;">검색 기록이 없습니다.</p>
                        </c:if>
                    </div>
					<%-- 이전 화면 버튼은 travel-info의 일부가 아닌 left-section의 마지막 요소로 이동 --%>
								<div class="back-button-container">
								                <button class="back-button" onclick="goBack()">
								                    이전
								                </button>
				</div>
                </div>

               
            </div>
             
        </div>

        <!-- 챗봇 섹션 -->
        <div class="chatbot-section">
            <h2>${searchTitle != null ? searchTitle : '여행 챗봇'}</h2> <%-- 기본 제목 제공 --%>
            <form action="/ask" method="post" id="chatbot-form">
                <div class="search-container">
                    <input type="text" id="message-input" name="message" class="search-input" placeholder="무엇이든 물어보세요">
                    <%-- email 필드 추가 (hidden) --%>
                    <input type="hidden" name="email" value="${username}">
                    <button type="submit" class="search-button">검색</button>
                </div>
            </form> 
        </div>
    </div>

    <script>
       /* // 카카오 지도 초기화 함수
        function initMap() {
            var mapContainer = document.getElementById('map');
            if (!mapContainer) {
                console.error('지도 컨테이너를 찾을 수 없습니다.');
                return;
            }

            // 컨트롤러에서 넘어온 좌표값 (JSP Expression 사용, null 처리 강화)
            var latitude = ${latitude != null ? latitude : 'null'};
            var longitude = ${longitude != null ? longitude : 'null'};

            // 좌표값이 유효하지 않으면 기본 위치(예: 서울 시청) 또는 메시지 표시
            if (typeof latitude !== 'number' || typeof longitude !== 'number') {
                console.warn('유효한 좌표값이 없습니다. 기본 위치로 지도를 표시하거나 메시지를 출력합니다.');
                // 예: 기본 위치 설정
                latitude = 37.5665;
                longitude = 126.9780;
                 mapContainer.innerHTML = '<p style="text-align:center; padding-top: 80px; color: #777;">표시할 위치 정보가 없습니다.</p>';
                 return; // 지도를 로드하지 않음

                // 또는 메시지만 표시
                // mapContainer.innerHTML = '<p style="text-align:center; padding-top: 80px; color: #777;">표시할 위치 정보가 없습니다.</p>';
                // return;
            }

            var mapOption = {
                center: new kakao.maps.LatLng(latitude, longitude), // 유효한 좌표로 중심 설정
                level: 7 // 레벨 조정 (값이 클수록 넓은 지역 표시)
            };

            try {
                var map = new kakao.maps.Map(mapContainer, mapOption);

                // 마커 생성
                var markerPosition = new kakao.maps.LatLng(latitude, longitude);
                var marker = new kakao.maps.Marker({
                    position: markerPosition,
                    map: map,
                    // title: '추천 위치' // title 속성은 기본적으로 표시되지 않음
                });

                // 인포윈도우 내용 (간단하게)
                var iwContent = '<div style="padding:5px; font-size:12px; text-align:center; width: 150px;">추천 위치</div>';
                var iwPosition = new kakao.maps.LatLng(latitude, longitude);

                // 인포윈도우 생성
                var infowindow = new kakao.maps.InfoWindow({
                    position : iwPosition,
                    content : iwContent
                });

                // 마커 위에 인포윈도우 표시 (마우스오버 이벤트 등 제거하고 바로 표시)
                infowindow.open(map, marker);

                // 지도 컨트롤 추가
                var mapTypeControl = new kakao.maps.MapTypeControl();
                map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
                var zoomControl = new kakao.maps.ZoomControl();
                map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

                console.log('지도 로드 완료. 중심 좌표:', latitude, longitude);

            } catch (error) {
                console.error('지도 초기화 중 오류 발생:', error);
                 mapContainer.innerHTML = '<p style="text-align:center; padding-top: 80px; color: #777;">지도를 불러오는 중 오류가 발생했습니다.</p>';
            }
        }

        // 카카오맵 SDK 로드 후 지도 초기화
        kakao.maps.load(function () {
            console.log('카카오 지도 SDK 로드 완료');
            initMap();
        });
*/
		// 카카오맵 로드 함수 (이전과 동일 - 하드코딩된 상태)
        function loadKakaoMap() {
            kakao.maps.load(function() {
                var mapContainer = document.getElementById('map');
                var mapOption = {
                    center: new kakao.maps.LatLng(37.5012, 127.0396),
                    level: 3
                };

                try {
                    var map = new kakao.maps.Map(mapContainer, mapOption);

                    // 마커 위치 정의
                    var positions = [
                        { title: '강남역', latlng: new kakao.maps.LatLng(37.5012, 127.0396) },
                        { title: '선릉역', latlng: new kakao.maps.LatLng(37.5045, 127.0492) },
                        { title: '역삼역', latlng: new kakao.maps.LatLng(37.5004, 127.0367) }
                    ];

                    // 마커 생성
                    positions.forEach(function(position) {
                        var marker = new kakao.maps.Marker({ map: map, position: position.latlng, title: position.title });
                        var infowindow = new kakao.maps.InfoWindow({ content: '<div style="padding:5px;font-size:12px;">' + position.title + '</div>' });
                        kakao.maps.event.addListener(marker, 'click', function() { infowindow.open(map, marker); });
                    });
                } catch (e) {
                    console.error('지도 로드 실패:', e);
                }
            });
        }

        // 페이지 로드 시 지도 초기화
        window.onload = function() {
            loadKakaoMap();
        };
        // 뒤로 가기 함수
        function goBack() {
            history.back();
        }

        // 검색 기록 클릭 시 입력 필드 채우기 함수
        function searchHistoryItem(title) {
            const messageInput = document.getElementById('message-input');
            if (messageInput) {
                messageInput.value = title;
                messageInput.focus(); // 입력 필드에 포커스
                // 선택적으로 바로 검색 실행
                // document.getElementById('chatbot-form').submit();
            }
        }

    </script>
</body>
</html>