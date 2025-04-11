<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시/군/구 선택</title>
    <style>
        .page {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: transform 0.5s;
        }
        
        .container {
            width: 80%;
            max-width: 1200px;
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
            height: 50px;
        }

        .subregion-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }

        .subregion-item {
            padding: 15px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .subregion-item:hover {
            background-color: #f0f0f0;
            transform: scale(1.05);
        }

        .subregion-item.selected {
            background-color: #4CAF50;
            color: white;
        }

        .navigation {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }

        .nav-button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            background-color: #4CAF50;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .nav-button:hover {
            background-color: #45a049;
        }

        .slide-out {
            transform: translateX(-100%);
        }
    </style>
</head>
<body>
    <div class="page">
        <div class="container">
            <div class="header">
                <img src="image/logo.png" alt="로고" class="logo">
                <div class="page-indicator"><strong>01 ----- 02 03</strong></div>
            </div>

            <div class="content-section">
                <h1 class="title">세부 지역을 선택해 주세요</h1>
                 <div id="subregion-grid" class="subregion-grid">
                    <script>
                    // API로 지역 데이터 불러오기
                    async function fetchAreaData() {
                        const selectedLocation = localStorage.getItem('selectedLocation');
                        if (selectedLocation) {
                            const areaCode = areaCodeMap[selectedLocation];
                            const serviceKey = 'zobQk13tnvYbo%2Fm%2Ff73cuxwgSffsJEm60Y%2FpBKm2hjfetSQd55bSILGX1Nq9vBi9PEGinACney4ZcjXkgXWL4A%3D%3D';
                            const apiUrl = `https://apis.data.go.kr/B551011/KorService1/areaCode1?serviceKey=${serviceKey}&MobileApp=AppTest&MobileOS=ETC&pageNo=1&numOfRows=10&areaCode=${areaCode}`;

                            try {
                                const response = await fetch(apiUrl);
                                const data = await response.json();
                                const areas = data.response.body.items.item;
                                
                                const subregionGrid = document.getElementById('subregion-grid');
                                subregionGrid.innerHTML = ''; // 기존 내용 초기화

                                areas.forEach(area => {
                                    const areaDiv = document.createElement('div');
                                    areaDiv.className = 'subregion-item';
                                    areaDiv.textContent = area.name;
                                    areaDiv.dataset.code = area.code;
                                    
                                    // 지역 선택 이벤트
                                    areaDiv.addEventListener('click', function() {
                                        const allAreas = document.querySelectorAll('.subregion-item');
                                        allAreas.forEach(item => item.classList.remove('selected'));
                                        this.classList.add('selected');
                                        localStorage.setItem('selectedSubregion', JSON.stringify({
                                            name: area.name,
                                            code: area.code
                                        }));
                                    });

                                    subregionGrid.appendChild(areaDiv);
                                });
                            } catch (error) {
                                console.error('API 데이터 로드 실패:', error);
                            }
                        }
                    }

                    // 페이지 로드 시 실행
                    window.addEventListener('load', fetchAreaData);
                    </script>
                </div>

                <div class="navigation">
                    <button class="nav-button" id="prevBtn">이전</button>
                    <button class="nav-button" id="nextBtn">다음</button>
                </div>
            </div>
        </div>
    </div>

    <script>
    const areaCodeMap = {
    	    '서울': 1, '인천': 2, '대전': 3, '대구': 4, '광주': 5,
    	    '부산': 6, '울산': 7, '세종': 8, '경기': 31, '강원': 32,
    	    '충북': 33, '충남': 34, '경북': 35, '경남': 36, '전북': 37,
    	    '전남': 38, '제주': 39
    	};

    	let selectedSubregion = null;

    	async function loadSubregions(areaCode) {
    	    const url = `/area/subregions?areaCode=${areaCode}`; // ✅ Spring 프록시 사용

    	    try {
    	        const response = await fetch(url);
    	        const xmlText = await response.text();
    	        const parser = new DOMParser();
    	        const xmlDoc = parser.parseFromString(xmlText, "application/xml");

    	        const items = xmlDoc.getElementsByTagName("item");
    	        const grid = document.getElementById('subregion-grid');
    	        grid.innerHTML = '';

    	        for (let item of items) {
    	            const name = item.getElementsByTagName("name")[0].textContent;
    	            const code = item.getElementsByTagName("code")[0].textContent;

    	            const div = document.createElement('div');
    	            div.className = 'subregion-item';
    	            div.textContent = name;
    	            div.dataset.code = code;

    	            div.addEventListener('click', function () {
    	                if (selectedSubregion) {
    	                    selectedSubregion.classList.remove('selected');
    	                }
    	                this.classList.add('selected');
    	                selectedSubregion = this;

    	                localStorage.setItem('selectedSubregion', name);
    	                localStorage.setItem('selectedSubregionCode', code);
    	            });

    	            grid.appendChild(div);
    	        }

    	    } catch (error) {
    	        console.error('서버 호출 실패:', error);
    	    }
    	}

    	window.addEventListener('load', function () {
    	    const savedLocation = localStorage.getItem('selectedLocation');
    	    if (savedLocation) {
    	        const areaCode = areaCodeMap[savedLocation];
    	        if (areaCode) {
    	            loadSubregions(areaCode);
    	        }
    	    }
    	});
    	
	    document.getElementById('nextBtn').addEventListener('click', function () {
	        if (!selectedSubregion) {
	            alert('세부 지역을 선택해 주세요.');
	            return;
	        }
	
	        const page = document.querySelector('.page');
	        page.classList.add('slide-out');
	
	        localStorage.setItem('selectedSubregion', selectedSubregion.textContent);
	        localStorage.setItem('selectedSubregionCode', selectedSubregion.dataset.code);
	
	        setTimeout(() => {
	            location.href = '/page2';
	        }, 500);
	    });
	
	    document.getElementById('prevBtn').addEventListener('click', function () {
	        location.href = '/page0';
	    });
</script>
    
</body>
</html>
