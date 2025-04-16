<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>더미 로그인</title>
</head>
<body>
<h2>더미 로그인</h2>
<form action="/dummylogin" method="post">
    <label for="email">이메일:</label>
    <input type="email" id="email" name="email" required />
    <button type="submit">로그인</button>
</form>
</body>
</html>
