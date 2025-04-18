<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>지역 관리</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f3925101927bde5acf150ddd5f551f63&libraries=services"></script>
    <style>
        .page { 
            width: 100%; 
            height: 100vh; 
            display: flex; 
            flex-direction: column;
            align-items: center; 
            padding: 20px;
        }
        
        .location-manager {
            width: 100%;
            max-width: 800px;
            margin-bottom: 20px;
            padding: 20px;
            background: #f5f5f5;
            border-radius: 8px;
        }

        .location-input {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .location-input input {
            flex: 1;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .location-input button {
            padding: 8px 16px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .location-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 10px;
        }

        .location-item {
            position: relative;
            padding: 15px;
            background: white;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .location-item:hover {
            background: #e9ecef;
        }

        .location-item.selected {
            background: #007bff;
            color: white;
        }

        .delete-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 12px;
            cursor: pointer;
            display: none;
        }

        .location-item:hover .delete-btn {
            display: block;
        }

        .map-container {
            width: 100%;
            max-width: 800px;
            height: 400px;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .info-panel {
            width: 100%;
            max-width: 800px;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
        }

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

        .loading {
            display: none;
            text-align: center;
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="page">
        <div class="location-manager">
            <h2>지역 관리</h2>
            <div class="location-input">
                <input type="text" id="locationInput" placeholder="새로운 지역 이름을 입력하세요">
                <button onclick="addLocation()">추가</button>
            </div>
            <div class="location-grid">
                <c:forEach var="item" items="${items}">
                    <div class="location-item" onclick="selectLocation(this, '${item.name}')">
                        ${item.name}
                        <button class="delete-btn" onclick="deleteLocation(event, '${item.name}')">×</button>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="map-container" id="map"></div>
        
        <div class="info-panel">
            <h3>주변 관광지</h3>
            <div class="loading" id="loading">검색중...</div>
            <ul class="place-list" id="placeList"></ul>
        </div>
    </div>

    <script>
        let selectedLocation = null;
        let map;
        let markers = [];
        
        const KAKAO_API_KEY = 'f3925101927bde5acf150ddd5f551f63';
        
        // 카카오맵 초기화
        window.onload = function() {
            const container = document.getElementById('map');
            const options = {
                center: new kakao.maps.LatLng(37.5665, 126.9780),
                level: 3
            };
            map = new kakao.maps.Map(container, options);
        };

        // 지역 추가
        async function addLocation() {
            const input = document.getElementById('locationInput');
            const name = input.value.trim();
            
            if (!name) return;
            
            try {
                const response = await fetch('/api/locations?name=' + name, {
                    method: 'POST'
                });
                
                if (response.ok) {
                    location.reload();
                }
            } catch (error) {
                console.error('Error adding location:', error);
            }
        }

        // 지역 삭제
        async function deleteLocation(event, name) {
            event.stopPropagation();
            
            try {
                const response = await fetch('/api/locations/' + name, {
                    method: 'DELETE'
                });
                
                if (response.ok) {
                    location.reload();
                }
            } catch (error) {
                console.error('Error deleting location:', error);
            }
        }

        // 지역 선택
        function selectLocation(element, name) {
            if (selectedLocation) {
                selectedLocation.classList.remove('selected');
            }
            
            element.classList.add('selected');
            selectedLocation = element;
            
            searchPlaces(name);
        }
        
        // 마커 생성 함수
        function createMarker(place) {
            const marker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(place.y, place.x),
                map: map
            });
            
            const infowindow = new kakao.maps.InfoWindow({
                content: '<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>'
            });
            
            kakao.maps.event.addListener(marker, 'mouseover', function() {
                infowindow.open(map, marker);
            });
            
            kakao.maps.event.addListener(marker, 'mouseout', function() {
                infowindow.close();
            });
            
            return marker;
        }
        
        // 장소 검색 함수
        async function searchPlaces(locationName) {
            const loading = document.getElementById('loading');
            loading.style.display = 'block';
            
            try {
                const searchQuery = locationName + ' 관광지';
                const encodedQuery = searchQuery.split(' ').join('+');
                
                const response = await fetch('https://dapi.kakao.com/v2/local/search/keyword.json?query=' + encodedQuery, {
                    headers: {
                        'Authorization': 'KakaoAK ' + KAKAO_API_KEY
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
                        li.innerHTML = 
                            '<strong>' + place.place_name + '</strong><br>' +
                            '<small>' + place.address_name + '</small>';
                        
                        li.addEventListener('click', () => {
                            map.setCenter(new kakao.maps.LatLng(place.y, place.x));
                            map.setLevel(3);
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
    </script>
</body>
</html> 