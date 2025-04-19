<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: #f0f4f8;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
    }
    
    .container {
        width: 100%;
        max-width: 500px;
        padding: 20px;
    }
    
    .logo {
        text-align: left;
        margin-bottom: 10px;
    }
    
    .logo img {
        max-width: 150px;
    }
    
    h1 {
        text-align: center;
        color: #333;
        margin-bottom: 30px;
        font-size: 24px;
    }
    
    .signup-box {
        background-color: #fff;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    
    .input-group {
        margin-bottom: 20px;
    }
    
    label {
        display: block;
        margin-bottom: 8px;
        color: #333;
        font-size: 14px;
    }
    
    input {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 14px;
    }
    
    .email-group {
        display: flex;
        gap: 10px;
    }
    
    .email-group input {
        flex: 1;
    }
    
    .check-btn {
        padding: 0 20px;
        background-color: #6495ED;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
    }
    
    .button-group {
        display: flex;
        justify-content: space-between;
        margin-top: 30px;
    }
    
    .cancel-btn, .submit-btn {
        padding: 12px 40px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        font-weight: bold;
    }
    
    .cancel-btn {
        background-color: #e0e0e0;
        color: #333;
    }
    
    .submit-btn {
        background-color: #6495ED;
        color: white;
    }
    
    .cancel-btn:hover, .submit-btn:hover, .check-btn:hover {
        opacity: 0.9;
    }
    
    input:focus {
        outline: none;
        border-color: #6495ED;
    } 
</style>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
</head>
<body>
    <div class="container">
        <div class="logo">
            <img src="image/logo.png" alt="로고">
        </div>
        
        <h1>회원가입</h1>
        
        <div class="signup-box">
            <form action="" method="post" id="my_form">
                <div class="input-group">
                    <label for="email">이메일(아이디)</label>
                    <div class="email-group">
                        <input type="email" id="email" name="email" required>
                        <button type="button" class="check-btn">중복확인</button>
                    </div>
                </div>
                
                <div class="input-group">
                    <label for="name">이름</label>
                    <input type="text" id="name" name="name" required>
                </div>
                
                <div class="input-group">
                    <label for="nickname">닉네임</label>
                    <input type="text" id="nickname" name="nickname" required>
                    <button type="button" class="check-btn">중복확인</button>
                </div>
                
                <div class="input-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="pwd" name="pwd" required>
                </div>
                
                <div class="input-group">
                    <label for="phone" >휴대폰 번호</label>
                    <input type="tel" id="phon_num" name="phon_num" required>
                </div>
                
                <div class="button-group">
                    <button type="button" class="cancel-btn" onclick="location.href='login'">취소</button>
                    <button type="button" class="submit-btn" onclick="fetchFunc()">완료</button>
                </div>
            </form>
        </div>
    </div>
    <script type="text/javascript">
	     function fetchFunc() {
	        const form = document.getElementById('my_form');
	        const formData = new FormData(form); // 폼의 모든 input 데이터를 수집
	        const jsonData = {}; // 제이슨 생성
			formData.forEach((value, key) => { // 폼 데이터만큼 반복
				//console.log(JSON.stringify(jsonData)) // 전송된 데이터
				jsonData[key] = value; // 제이슨에 담기
	        });
	    	fetch("http://localhost:8000/auth/register", {
				method: "POST",
				headers: {
				  "Content-Type": "application/json"
				},
				body: JSON.stringify(jsonData) // 해당 제이슨을 패치로 전송
	       	})
	        .then(response => {
		        if (!response.ok) {
		            throw new Error(`HTTP 오류! 상태 코드: ${response.status}`);
		        }
		        return response.json(); // response model이 json 형태로 반환
		    })
	        .then(data => {
	        	alert("회원가입이 성공적으로 완료되었습니다!")
	        	console.log('서버 응답:'+ data);	        	
	          location.href = "/login";
	        })
	        .catch(error => {
	          console.log('에러 발생:'+ error);
	        });
	    } 
    </script>
</body>
</html> 