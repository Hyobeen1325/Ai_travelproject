<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<jsp:include page="header.jsp" />
<body>
<h1>test2</h1>
</body>
<script type="text/javascript">
    var message = "${msg}";
    if (message != "") {
      alert(message);
    };
</script>
<jsp:include page="header2.jsp" /> 
</html>