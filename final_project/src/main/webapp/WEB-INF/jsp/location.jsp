<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>세부 지역 선택</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f3925101927bde5acf150ddd5f551f63&libraries=services"></script>
    <style>
        /* 기존 스타일 유지 */
        .page { width: 100%; height: 100vh; display: flex; justify-content: center; align-items: center; }
        .container { width: 90%; max-width: 1400px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .logo { width: 100px; }
        .page-indicator { font-size: 18px; }
        .content-section { text-align: center; }
        .title { font-size: 28px; margin-bottom: 30px; }
        
        /* 레이아웃 수정 */
        .main-content {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .left-panel {
            flex: 1;
        }
        
        .right-panel {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .location-grid { 
            display: grid; 
            grid-template-columns: repeat(4, 1fr); 
            gap: 15px; 
            margin-bottom: 30px; 
        }
        
        .location-item { 
            padding: 15px; 
            background: #f5f5f5; 
            border-radius: 8px; 
            cursor: pointer; 
            transition: all 0.3s; 
        }
        
        .location-item:hover { background: #e0e0e0; }
        .location-item.selected { background: #007bff; color: white; }
        .location-item.deselecting { background: #f5f5f5; color: black; }
        
        .map-container {
            width: 100%;
            height: 400px;
            border-radius: 8px;
            overflow: hidden;
        }
        
        .info-panel {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            max-height: 300px;
            overflow-y: auto;
        }
        
        .navigation { display: flex; justify-content: center; gap: 20px; }
        .nav-button { 
            padding: 10px 20px; 
            background: #007bff; 
            color: white; 
            border: none; 
            border-radius: 5px; 
            cursor: pointer; 
        }
        .nav-button:hover { background: #0056b3; }
        
        .place-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .place-item {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            cursor: pointer;
        }
        
        .place-item:hover {
            background: #f0f0f0;
        }
        
        .transport-info {
            margin-top: 20px;
            padding: 15px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .loading {
            display: none;
            text-align: center;
            padding: 20px;
        }
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

                <div class="main-content">
                    <div class="left-panel">
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
                    </div>
                    
                    <div class="right-panel">
                        <div class="map-container" id="map"></div>
                        <div class="info-panel">
                            <h3>주변 관광지</h3>
                            <div class="loading" id="loading">검색중...</div>
                            <ul class="place-list" id="placeList"></ul>
                            <div class="transport-info" id="transportInfo"></div>
                        </div>
                    </div>
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
        let map;
        let markers = [];
        
        const KAKAO_API_KEY = 'f3925101927bde5acf150ddd5f551f63';
        const ODSAY_API_KEY = '8ph%2FjNSbi1RGUdtqnZ0%2BX1XZjeDsZNNu5V7rUAbQTps';
        
        // 카카오맵 초기화
        window.onload = function() {
            const container = document.getElementById('map');
            const options = {
                center: new kakao.maps.LatLng(37.5665, 126.9780),
                level: 3
            };
            map = new kakao.maps.Map(container, options);
        };
        
        // 마커 생성 함수
        function createMarker(place) {
            const marker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(place.y, place.x),
                map: map
            });
            
            const infowindow = new kakao.maps.InfoWindow({
                content: `<div style="padding:5px;font-size:12px;">${place.place_name}</div>`
            });
            
            kakao.maps.event.addListener(marker, 'mouseover', function() {
                infowindow.open(map, marker);
            });
            
            kakao.maps.event.addListener(marker, 'mouseout', function() {
                infowindow.close();
            });
            
            return marker;
        }
        
        // 장소 검색 함수 (카카오맵 API 직접 호출)
        async function searchPlaces(locationName) {
            const loading = document.getElementById('loading');
            loading.style.display = 'block';
            
            try {
                const response = await fetch(`https://dapi.kakao.com/v2/local/search/keyword.json?query=${encodeURIComponent(locationName + ' 관광지')}`, {
                    headers: {
                        'Authorization': `KakaoAK ${KAKAO_API_KEY}`
                    }
                });
                
                const data = await response.json();
                
                // 기존 마커 제거
                markers.forEach(marker => marker.setMap(null));
                markers = [];
                
                // 검색 결과 표시
                const bounds = new kakao.maps.LatLngBounds();
                const placeList = document.getElementById('placeList');
                placeList.innerHTML = '';
                
                if (data.documents.length > 0) {
                    data.documents.slice(0, 5).forEach(place => {
                        // 마커 생성
                        const marker = createMarker(place);
                        markers.push(marker);
                        bounds.extend(new kakao.maps.LatLng(place.y, place.x));
                        
                        // 장소 리스트 추가
                        const li = document.createElement('li');
                        li.className = 'place-item';
                        li.innerHTML = `
                            <strong>${place.place_name}</strong><br>
                            <small>${place.address_name}</small>
                        `;
                        li.addEventListener('click', () => {
                            map.setCenter(new kakao.maps.LatLng(place.y, place.x));
                            map.setLevel(3);
                            searchTransportation(place);
                        });
                        placeList.appendChild(li);
                    });
                    
                    map.setBounds(bounds);
                } else {
                    placeList.innerHTML = '<p>검색 결과가 없습니다.</p>';
                }
            } catch (error) {
                console.error('Error searching places:', error);
                document.getElementById('placeList').innerHTML = '<p>검색 중 오류가 발생했습니다.</p>';
            } finally {
                loading.style.display = 'none';
            }
        }
        
        // 대중교통 정보 검색 함수 (ODsay API 직접 호출)
        async function searchTransportation(place) {
            const transportInfo = document.getElementById('transportInfo');
            transportInfo.innerHTML = '<h4>대중교통 정보 검색중...</h4>';
            
            try {
                // 서울역 기준으로 목적지까지의 경로 검색 (예시)
                const startX = '126.972559'; // 서울역 경도
                const startY = '37.555062';  // 서울역 위도
                
                const response = await fetch(`https://api.odsay.com/v1/api/searchPubTransPath?apiKey=${ODSAY_API_KEY}&SX=${startX}&SY=${startY}&EX=${place.x}&EY=${place.y}&SearchType=0`);
                
                const data = await response.json();
                
                if (data.result) {
                    const path = data.result.path[0];
                    transportInfo.innerHTML = `
                        <h4>대중교통 정보 (서울역 출발 기준)</h4>
                        <p>총 소요시간: ${path.info.totalTime}분</p>
                        <p>총 요금: ${path.info.payment}원</p>
                        <p>총 거리: ${(path.info.totalDistance / 1000).toFixed(1)}km</p>
                    `;
                } else {
                    transportInfo.innerHTML = '<h4>대중교통 정보를 찾을 수 없습니다.</h4>';
                }
            } catch (error) {
                console.error('Error searching transportation:', error);
                transportInfo.innerHTML = '<h4>대중교통 정보 검색 중 오류가 발생했습니다.</h4>';
            }
        }

        // 지역 선택 이벤트 리스너
        document.querySelectorAll('.location-item').forEach(item => {
            item.addEventListener('click', function() {
                if (selectedLocation === this) {
                    this.classList.add('deselecting');
                    this.classList.remove('selected');
                    setTimeout(() => {
                        this.classList.remove('deselecting');
                    }, 300);
                    selectedLocation = null;
                } else {
                    if (selectedLocation) {
                        selectedLocation.classList.add('deselecting');
                        selectedLocation.classList.remove('selected');
                        setTimeout(() => {
                            selectedLocation.classList.remove('deselecting');
                        }, 300);
                    }
                    this.classList.remove('deselecting');
                    this.classList.add('selected');
                    selectedLocation = this;
                    
                    // 선택된 지역으로 장소 검색
                    searchPlaces(this.textContent);
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
            
            localStorage.setItem('selectedDetailLocation', selectedLocation.textContent);
            
            setTimeout(() => {
                location.href = '/page2';
            }, 500);
        });

        // 이전 버튼 클릭 이벤트
        document.getElementById('prevBtn').addEventListener('click', function() {
            location.href = '/page0';
        });

        // 페이지 로드 시 이전 선택 복원
        window.addEventListener('load', function() {
            const savedLocation = localStorage.getItem('selectedDetailLocation');
            if (savedLocation) {
                document.querySelectorAll('.location-item').forEach(item => {
                    if (item.textContent === savedLocation) {
                        item.classList.add('selected');
                        selectedLocation = item;
                        searchPlaces(savedLocation);
                    }
                });
            }
        });
    </script>
</body>
</html>