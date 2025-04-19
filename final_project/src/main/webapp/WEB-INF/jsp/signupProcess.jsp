<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 문자 인코딩 설정
    request.setCharacterEncoding("UTF-8");

    // 폼에서 전송된 데이터 받기
    String email = request.getParameter("email");
    String name = request.getParameter("name");
    String nickname = request.getParameter("nickname");
    String pwd = request.getParameter("pwd");
    String phon_num = request.getParameter("phon_num");

    // 데이터베이스 연결 정보
    String url = "jdbc:mysql://localhost:3306/192.168.0.46?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
    String dbUsername = "root";
    String dbPassword = "83850064a";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        // JDBC 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // 데이터베이스 연결
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);
        
        // 이메일 중복 체크
        String checkSql = "SELECT COUNT(*) FROM members WHERE email = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setString(1, email);
        rs = pstmt.executeQuery();
        rs.next();
        
        if(rs.getInt(1) > 0) {
            // 중복된 이메일이 존재하는 경우
            %>
            <script>
                alert("이미 사용 중인 이메일입니다.");
                history.back();
            </script>
            <%
            return;
        }
        
        // 회원 정보 삽입
        String sql = "INSERT INTO members (email, name, nickname, pwd, phon_num) VALUES (?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, email);
        pstmt.setString(2, name);
        pstmt.setString(3, nickname);
        pstmt.setString(4, pwd); // 실제 서비스에서는 반드시 암호화하여 저장해야 합니다!
        pstmt.setString(5, phon_num);
        
        int result = pstmt.executeUpdate();
        
        if(result > 0) {
            // 회원가입 성공
            %>
            <script>
                alert("회원가입이 완료되었습니다.");
                location.href = "login.jsp"; // 로그인 페이지로 이동
            </script>
            <%
        } else {
            // 회원가입 실패
            %>
            <script>
                alert("회원가입에 실패했습니다. 다시 시도해주세요.");
                history.back();
            </script>
            <%
        }
        
    } catch(Exception e) {
        // 오류 발생
        %>
        <script>
            alert("오류가 발생했습니다: <%= e.getMessage() %>");
            history.back();
        </script>
        <%
    } finally {
        // 리소스 해제
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%> 