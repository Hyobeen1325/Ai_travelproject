<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>선택값 CRUD</title>
<script>
    function handleButtonClick(methodP) {
        const idInput = document.getElementById('id');
        
        // 등록 시 ID 필드 비활성화
        if (methodP === 'POST') {
            idInput.disabled = true;
        } else {
            // 수정, 삭제 시 ID 필드 활성화
            idInput.disabled = false;
        }
        
        fetchFunc(methodP) // 패치함수 실행
        
    }
    
    function fetchFunc(methodP) {
        const form = document.getElementById('choose_val_form');
        const formData = new FormData(form); // 폼의 모든 input 데이터를 수집
        const jsonData = {}; // 제이슨 생성
		formData.forEach((value, key) => { // 폼 데이터만큼 반복
			jsonData[key] = value; // 제이슨에 담기
        });
    	fetch(`/choose_val?choose_id=${choose.choose_id}`, {
			method: methodP,
			headers: {
			  "Content-Type": "application/json"
			},
			body: JSON.stringify(jsonData) // 해당 제이슨을 패치로 전송
       	})
        .then(response => {
	        if (!response.ok) {
	            throw new Error(`HTTP 오류! 상태 코드: ${response.status}`);
	        }
	        return response.json();
	    })
        .then(data => {
          alert('서버 응답:'+ data);
       	  href.location="/All"
        })
        .catch(error => {
          console.error('에러 발생:'+ error);
        });
    }

    // 페이지 로드 시 버튼 상태 설정
    window.onload = function() {
    	const message = "${message}"
    	if (message!="") {
    		alert(message)
    	}
    	
        const choose_id = document.getElementById('id').value;
        const isEditMode = choose_id !== '';
        const elements = document.getElementsByClassName('readonlyField');
        
        // 조회 모드일 때 (ID가 있을 때)
        if (isEditMode) {
            document.getElementById('registerButton').style.display = 'none';
            for (let i = 0; i < elements.length; i++) {
                elements[i].style.display = 'block';
            }
            document.getElementById('updateButton').style.display = 'inline';
            document.getElementById('deleteButton').style.display = 'inline';
        } else {
            // 등록 모드일 때
            document.getElementById('registerButton').style.display = 'inline';
            for (let i = 0; i < elements.length; i++) {
                elements[i].style.display = 'none';
            }
            document.getElementById('updateButton').style.display = 'none';
            document.getElementById('deleteButton').style.display = 'none';
        }
    }
</script>
</head>
<body>
	<h2>선택값 정보 입력</h2>
    <form id="choose_val_form" action="/choose_val">
        <div class="readonlyField">
            <label for="id">선택값 ID:</label>
            <input type="text" id="id" name="choose_id" value="${choose.choose_id}" readonly>
        </div>
        <div>
            <label for="high_loc">상위지역:</label>
            <input type="text" id="high_loc" name="high_loc" value="${choose.high_loc}" required>
        </div>
        <div>
            <label for="low_loc">하위지역:</label>
            <input type="text" id="low_loc" name="low_loc" value="${choose.low_loc}">
        </div>
        <div>
            <label for="theme1">테마1:</label>
            <input type="text" id="theme1" name="theme1" value="${choose.theme1}" required>
        </div>
        <div>
            <label for="theme2">테마2:</label>
            <input type="text" id="theme2" name="theme2" value="${choose.theme2}" required>
        </div>
        <div>
            <label for="theme3">테마3:</label>
            <input type="text" id="theme3" name="theme3" value="${choose.theme3}">
        </div>
        <div>
            <label for="theme4">테마4:</label>
            <input type="text" id="theme4" name="theme4" value="${choose.theme4}">
        </div>
        <div>
            <label for="days">여행일자:</label>
            <input type="text" id="days" name="days" value="${choose.days}">
        </div>
        <div class="readonlyField">
            <label for="regdate">등록일:</label>
            <input type="text" id="regdate" value="${choose.regdateS}" readonly/>
        </div>
        <div class="readonlyField">
            <label for="uptdate">수정일:</label>
            <input type="text" id="uptdate" value="${choose.uptdateS}" readonly/>
        </div>
        <div>
            <button type="button" id="registerButton"
				onclick="handleButtonClick('POST')">
				등록</button>
            <button type="button" id="updateButton"
            	onclick="handleButtonClick('PUT')">
            	수정</button>
            <button type="button" id="deleteButton"
            	onclick="handleButtonClick('DELETE')">
            	삭제</button>
        </div>
    </form>
</body>
</html>