<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%-- JSTL core 태그 라이브러리 선언 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI 응답 페이지</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dcd5c4bab6de479a15aa752115990e79&autoload=false"></script> <%-- TODO: 카카오 앱 키를 실제 값으로 변경하세요 --%>
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
            width: 30%;
            display: flex;
            flex-direction: column;
            background-color: #fff;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        }

        /* 지도 컨테이너 (이전과 동일) */
        .map-container {
            height: 30%;
            width: 100%;
            position: relative;
            border-bottom: 1px solid #eaeaea;
        }

        /* 여행 정보 섹션 (이전과 동일) */
        .travel-info {
            height: 50%;
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
		    max-height: 200px;  /* 높이 제한 */
		    overflow-y: auto;   /* 스크롤 생김 */
		    padding-right: 10px;
		}

		.history-group {
		    margin-bottom: 15px;
		}

		.reg-date {
		    font-weight: bold;
		    font-size: 14px;
		    color: #555;
		    margin-bottom: 5px;
		}

        /* 이전 버튼 (이전과 동일) */
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

        /* 검색 결과 섹션 (이전과 동일) */
        .query-result {
            width: 45%; /* 필요시 조정 */
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
            left: 30px;  /* 왼쪽 정렬 */
            right: 30px; /* 오른쪽 간격 */
            width: calc(100% - 60px); /* 양쪽 패딩 고려 */
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
                    <!-- 원형 일정 (하드코딩 유지) -->
                    <div class="schedule-circle">당일</div>

                    <!-- 파란색 여행 코스 박스 -->
                    <div class="course-box">
                        <%-- EL과 JSTL을 사용하여 사용자 이름 표시 (없으면 '사용자') --%>
                        <h2>
                            <c:choose>
                                <c:when test="${not empty sessionScope.username}">
                                    <c:out value="${sessionScope.username}"/>님을 위한 여행 코스
                                </c:when>
                                <c:otherwise>
                                    사용자님을 위한 여행 코스
                                </c:otherwise>
                            </c:choose>
                        </h2>
                        <!-- 여행 상세 정보 (하드코딩 유지) -->
                        <div class="travel-details">
                            <div class="detail-item">
                                <span>총 이동거리:</span>
                                <span>4.2km</span>
                            </div>
                            <div class="detail-item">
                                <span>이동 지역:</span>
                                <span>서울시 강남구 역삼동</span>
                            </div>
                            <div class="detail-item">
                                <span>추천 여행지:</span>
                                <span>강남역, 선릉역, 역삼역</span>
                            </div>
                        </div>
                    </div>
                </div>

				<!-- 이전 검색 기록 섹션 -->
				<div class="search-history-section">
				    <h3>이전 검색 기록</h3>

				    <div class="search-history-scroll">
				        <c:forEach var="history" items="${historyList}">
				            <div class="history-group">
				                <div class="reg-date">${history.regDate}</div>
				                <ul class="search-history-list">
				                    <c:forEach var="title" items="${history.titles}">
				                        <li><c:out value="${title}" /></li>
				                    </c:forEach>
				                </ul>
				            </div>
				        </c:forEach>
				    </div>
				</div>

                <!-- 이전 화면 버튼 -->
                <button class="back-button" onclick="location.href='index.jsp'">
                    이전
                </button>
            </div>
        </div>

        <!-- 검색 결과 섹션 -->
        <div class="query-result">
            <%-- c:out을 사용하여 XSS 방지 --%>
            <p>검색어: <c:out value="${param.query}" default="질문 없음"/></p>
            <div class="ai-response">
                <h3>AI 응답:</h3>
                <div class="response-content">
                    <%-- 컨트롤러에서 전달된 aiResponse 출력 (백엔드에서 <br> 처리했으므로 escapeXml=false) --%>
                    <c:out value="${requestScope.aiResponse}" escapeXml="false" default="이곳에 AI 모델의 응답이 표시됩니다."/>
                </div>
            </div>

            <!-- 검색 폼 (위치 조정됨) -->
            <div class="search-form-wrapper">
                <form action="chat.do" method="get">
                    <div class="search-container">
                        <%-- 입력값 유지 시에도 c:out 사용 --%>
                        <input type="text" name="query" class="search-input" placeholder="무엇이든 물어보세요" value="<c:out value="${param.query}"/>">
                        <button type="submit" class="search-button">검색</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
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
    </script>
</body>
</html>