<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>길찾기 결과 지도에 표출하기</title>
</head>
<body>
<div id="map" style="width:100%;height:350px;"></div>
// 카카오 맵 API 사용
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f3925101927bde5acf150ddd5f551f63"></script>

<script>
 
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	mapOption = { 
    	center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
    	level: 3 // 지도의 확대 레벨
	};

	//지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
	var map = new kakao.maps.Map(mapContainer, mapOption); 
	
	var sx = 126.83737555322481;
	var sy = 37.55525165729346;
	
	var ex = 126.88265238619182;
	var ey = 37.481440035175375;
	
	var gx = 126.74265238619182;
	var gy = 37.521440035175375;
	
	
	
	function searchPubTransPathAJAX(ax,ay,bx,by) {
		var xhr = new XMLHttpRequest();
		//ODsay apiKey 입력
		var url = "https://api.odsay.com/v1/api/searchPubTransPathT?SX="+ax+"&SY="+ay+"&EX="+bx+"&EY="+by+"&apiKey=8ph%2FjNSbi1RGUdtqnZ0%2BX1XZjeDsZNNu5V7rUAbQTps";
		xhr.open("GET", url, true);
		xhr.send();
		xhr.onreadystatechange = function() {
			if (xhr.readyState == 4 && xhr.status == 200) {
			console.log( JSON.parse(xhr.responseText) ); // <- xhr.responseText 로 결과를 가져올 수 있음
			//노선그래픽 데이터 호출
			callMapObjApiAJAX((JSON.parse(xhr.responseText))["result"]["path"][0].info.mapObj,ax,ay,bx,by);
			}
		}
	}
	
	//길찾기 API 호출
	searchPubTransPathAJAX(sx,sy,ex,ey);

	searchPubTransPathAJAX(ex,ey,gx,gy);
	
	function callMapObjApiAJAX(mabObj,ax,ay,bx,by){
		var xhr = new XMLHttpRequest();
		//ODsay apiKey 입력
		var url = "https://api.odsay.com/v1/api/loadLane?mapObject=0:0@"+mabObj+"&apiKey=8ph%2FjNSbi1RGUdtqnZ0%2BX1XZjeDsZNNu5V7rUAbQTps";
		xhr.open("GET", url, true);
		xhr.send();
		xhr.onreadystatechange = function() {
			if (xhr.readyState == 4 && xhr.status == 200) {
				var resultJsonData = JSON.parse(xhr.responseText);
				drawKakaoMarker(ax,ay);					// 출발지 마커 표시
				drawKakaoMarker(bx,by);					// 도착지 마커 표시
				drawKakaoPolyLine(resultJsonData);		// 노선그래픽데이터 지도위 표시
				// boundary 데이터가 있을경우, 해당 boundary로 지도이동
				if(resultJsonData.result.boundary){
						var boundary = new kakao.maps.LatLngBounds(
				                new kakao.maps.LatLng(resultJsonData.result.boundary.top, resultJsonData.result.boundary.left),
				                new kakao.maps.LatLng(resultJsonData.result.boundary.bottom, resultJsonData.result.boundary.right)
				                );
						map.setBounds(boundary);
				}
			}
		}
	}
	
	// 지도위 마커 표시해주는 함수
	function drawKakaoMarker(x,y){
		var marker = new kakao.maps.Marker({
		    position: new kakao.maps.LatLng(y, x),
		    map: map
		});
	}
	
	// 노선그래픽 데이터를 이용하여 지도위 폴리라인 그려주는 함수
	function drawKakaoPolyLine(data){
		var lineArray;
		
		for(var i = 0 ; i < data.result.lane.length; i++){
			for(var j=0 ; j <data.result.lane[i].section.length; j++){
				lineArray = null;
				lineArray = new Array();
				for(var k=0 ; k < data.result.lane[i].section[j].graphPos.length; k++){
					lineArray.push(new kakao.maps.LatLng(data.result.lane[i].section[j].graphPos[k].y, data.result.lane[i].section[j].graphPos[k].x));
				}
				
			//지하철결과의 경우 노선에 따른 라인색상 지정하는 부분 (1,2호선의 경우만 예로 들음)
				if(data.result.lane[i].type == 1){
					var polyline = new kakao.maps.Polyline({
					    map: map,
					    path: lineArray,
					    strokeWeight: 3,
					    strokeColor: '#003499'
					});
				}else if(data.result.lane[i].type == 2){
					var polyline = new kakao.maps.Polyline({
					    map: map,
					    path: lineArray,
					    strokeWeight: 3,
					    strokeColor: '#37b42d'
					});
				}else{
					var polyline = new kakao.maps.Polyline({
					    map: map,
					    path: lineArray,
					    strokeWeight: 3
					});
				}
			}
		}
	}
</script>
</body>
</html>