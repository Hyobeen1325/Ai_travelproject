<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %> <%-- 데이터 처리를 위한 ArrayList 등을 사용하기 위해 추가 --%>
<%-- 실제 회원 정보를 담을 DTO 클래스나 Map 등을 사용할 수 있습니다. --%>
<%-- 만약 MemberDTO 클래스를 사용한다면 아래 주석을 해제하고 패키지명을 맞추세요. --%>
<%-- <%@ page import="your.package.MemberDTO" %> --%>
<%
    // 여기에 데이터베이스에서 회원 목록을 조회하는 로직을 추가해야 합니다.
    // 검색어 처리
    String searchKeyword = request.getParameter("searchKeyword");
    if (searchKeyword == null) {
        searchKeyword = "";
    } else {
        searchKeyword = searchKeyword.trim();
    }

    // 페이지 번호 처리
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            // 유효하지 않은 페이지 번호 처리 (기본값 1 유지)
        }
    }

    // 예시: List<MemberDTO> memberList = getMemberListFromDB(currentPage, membersPerPage, searchKeyword);
    // 임시 데이터 (실제 구현 시 DB에서 가져와야 함)
    List<Map<String, String>> memberList = new ArrayList<>();
    // 검색어가 있을 경우 필터링 (간단 예시)
    if (searchKeyword.isEmpty() || "홍길동".contains(searchKeyword) || "hong@naver.com".contains(searchKeyword)) {
        Map<String, String> member1 = new HashMap<>();
        member1.put("no", "1");
        member1.put("name", "홍길동");
        member1.put("email", "hong@naver.com");
        member1.put("phone", "010-1234-5678");
        member1.put("joinDate", "24-04-04");
        member1.put("modifyDate", "24-04-04");
        memberList.add(member1);
    }
    if (searchKeyword.isEmpty() || "김철수".contains(searchKeyword) || "jo1004@gmail.com".contains(searchKeyword)) {
        Map<String, String> member2 = new HashMap<>();
        member2.put("no", "2");
        member2.put("name", "김철수");
        member2.put("email", "jo1004@gmail.com");
        member2.put("phone", "010-9000-2222");
        member2.put("joinDate", "24-04-04");
        member2.put("modifyDate", "24-04-04");
        memberList.add(member2);
    }
    // ... DB 조회 결과에 따라 더 많은 회원 추가 ...

    // 페이지네이션 관련 변수 (DB 조회 결과 기반으로 설정해야 함)
    int totalMembers = 15; // 예: 검색 결과 포함 총 회원 수 (DB에서 가져와야 함)
    int membersPerPage = 10; // 페이지당 회원 수
    int totalPages = (int) Math.ceil((double) totalMembers / membersPerPage);

    // 현재 페이지 번호 유효성 검사
    if (currentPage < 1) currentPage = 1;
    if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;


%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원관리 - 관리자 페이지</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            margin: 20px;
            background-color: #f5f7ff;
        }

        .container {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        h1 {
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .icon {
            font-size: 24px;
        }

        .search-box {
            display: flex;
            margin-bottom: 20px;
            gap: 10px;
        }

        .search-box form { /* form 요소 스타일 추가 */
            display: flex;
            flex: 1; /* input과 button을 포함하도록 */
            gap: 10px;
        }

        .search-input {
            flex: 1;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .search-button {
            padding: 8px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            vertical-align: middle; /* 셀 내용 세로 중앙 정렬 */
        }

        th {
            background-color: #f8f9fa;
            font-weight: bold;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .edit-btn, .delete-btn {
            padding: 5px 10px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 12px; /* 버튼 글자 크기 조정 */
            white-space: nowrap; /* 버튼 내 글자 줄바꿈 방지 */
        }

        .edit-btn {
            background-color: #4CAF50;
            color: white;
        }

        .delete-btn {
            background-color: #f44336;
            color: white;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            gap: 5px; /* 간격 조정 */
        }

        .pagination a, .pagination span { /* 페이지 링크 스타일 */
            padding: 8px 12px;
            border: 1px solid #ddd;
            background-color: white;
            cursor: pointer;
            text-decoration: none;
            color: #333;
            border-radius: 3px; /* 모서리 둥글게 */
            font-size: 14px; /* 폰트 크기 조정 */
        }

        .pagination a:hover {
             background-color: #f5f5f5; /* 호버 효과 */
        }

        .pagination .active { /* 현재 페이지 스타일 */
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: default;
        }

        .pagination .disabled { /* 비활성화된 버튼 스타일 */
             color: #ccc;
             cursor: default;
             border-color: #eee;
             background-color: #f9f9f9; /* 약간의 배경색 추가 */
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>
            <span>Membership management</span>
            <span class="icon">📋</span>
        </h1>

        <div class="search-box">
            <form action="Membership_management.jsp" method="get"> <%-- 검색 폼 추가 --%>
                <input type="text" class="search-input" name="searchKeyword" placeholder="회원 이름 또는 이메일 검색" value="<%= searchKeyword %>">
                <button type="submit" class="search-button">검색</button>
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th>No</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>전화번호</th>
                    <th>가입일자</th>
                    <th>수정일자</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <%-- 회원 목록 출력 --%>
                <% if (memberList == null || memberList.isEmpty()) { %>
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 20px;">
                            <% if (!searchKeyword.isEmpty()) { %>
                                '<%= searchKeyword %>'에 대한 검색 결과가 없습니다.
                            <% } else { %>
                                등록된 회원이 없습니다.
                            <% } %>
                        </td>
                    </tr>
                <% } else { %>
                    <% for (Map<String, String> member : memberList) { %>
                        <tr>
                            <td><%= member.get("no") %></td>
                            <td><%= member.get("name") %></td>
                            <td><%= member.get("email") %></td>
                            <td><%= member.get("phone") %></td>
                            <td><%= member.get("joinDate") %></td>
                            <td><%= member.get("modifyDate") %></td>
                            <td>
                                <div class="action-buttons">
                                    <%-- 수정: 회원 ID(혹은 고유 식별자)를 파라미터로 넘겨 수정 페이지로 이동 --%>
                                    <button class="edit-btn" onclick="location.href='editMember.jsp?memberId=<%= member.get("no") %>' ">수정</button>
                                    <%-- 삭제: 회원 ID를 파라미터로 넘겨 삭제 처리 로직 실행 (JavaScript 확인 후) --%>
                                    <button class="delete-btn" onclick="deleteMember('<%= member.get("no") %>', '<%= member.get("name") %>')">삭제</button>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                <% } %>
            </tbody>
        </table>

        <%-- 페이지네이션 --%>
        <% if (totalPages > 0) { %>
        <div class="pagination">
            <%-- 이전 페이지 그룹 버튼 (선택적 구현) --%>
            <%-- <a href="#">&lt;&lt;</a> --%>

            <%-- 이전 페이지 버튼 --%>
            <% if (currentPage > 1) { %>
                <%-- 검색어 유지하며 이전 페이지로 --%>
                <a href="Membership_management.jsp?page=<%= currentPage - 1 %>&searchKeyword=<%= java.net.URLEncoder.encode(searchKeyword, "UTF-8") %>">◀</a>
            <% } else { %>
                <span class="disabled">◀</span>
            <% } %>

            <%-- 페이지 번호 버튼 (페이지 수가 많을 경우 일부만 표시하는 로직 추가 가능) --%>
            <%
                int startPage = Math.max(1, currentPage - 2); // 현재 페이지 기준 앞 2개
                int endPage = Math.min(totalPages, currentPage + 2); // 현재 페이지 기준 뒤 2개
                if (currentPage <= 3) {
                    endPage = Math.min(totalPages, 5); // 시작 부분일 때 최대 5개
                }
                if (currentPage >= totalPages - 2) {
                    startPage = Math.max(1, totalPages - 4); // 끝 부분일 때 최대 5개
                }

                if (startPage > 1) { // ... 표시 (시작)
                     out.println("<a href='Membership_management.jsp?page=1&searchKeyword=" + java.net.URLEncoder.encode(searchKeyword, "UTF-8") + "'>1</a>");
                     if (startPage > 2) {
                         out.println("<span class='disabled'>...</span>");
                     }
                 }

                for (int i = startPage; i <= endPage; i++) {
            %>
                <% if (i == currentPage) { %>
                    <span class="active"><%= i %></span>
                <% } else { %>
                    <%-- 검색어 유지하며 페이지 이동 --%>
                    <a href="Membership_management.jsp?page=<%= i %>&searchKeyword=<%= java.net.URLEncoder.encode(searchKeyword, "UTF-8") %>"><%= i %></a>
                <% } %>
            <% } %>

            <% if (endPage < totalPages) { // ... 표시 (끝)
                 if (endPage < totalPages - 1) {
                      out.println("<span class='disabled'>...</span>");
                 }
                 out.println("<a href='Membership_management.jsp?page=" + totalPages + "&searchKeyword=" + java.net.URLEncoder.encode(searchKeyword, "UTF-8") + "'>" + totalPages + "</a>");
            } %>


            <%-- 다음 페이지 버튼 --%>
            <% if (currentPage < totalPages) { %>
                <%-- 검색어 유지하며 다음 페이지로 --%>
                <a href="Membership_management.jsp?page=<%= currentPage + 1 %>&searchKeyword=<%= java.net.URLEncoder.encode(searchKeyword, "UTF-8") %>">▶</a>
            <% } else { %>
                <span class="disabled">▶</span>
            <% } %>

             <%-- 다음 페이지 그룹 버튼 (선택적 구현) --%>
             <%-- <a href="#">&gt;&gt;</a> --%>
        </div>
        <% } %>
    </div>

    <script>
        // 삭제 버튼 클릭 이벤트
        function deleteMember(memberId, memberName) {
            if (confirm('회원 [' + memberName + '] (ID: ' + memberId + ') 정말 삭제하시겠습니까?\n삭제 후 복구할 수 없습니다.')) {
                // 삭제 처리 페이지로 폼 제출 또는 AJAX 요청
                // 예시: POST 방식으로 삭제 처리 (CSRF 방지를 위해 권장)
                const form = document.createElement('form');
                form.method = 'post';
                form.action = 'deleteMemberProcess.jsp'; // 실제 삭제 처리 JSP 경로

                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'memberId';
                idInput.value = memberId;
                form.appendChild(idInput);

                // CSRF 토큰이 있다면 추가
                // const csrfInput = document.createElement('input');
                // csrfInput.type = 'hidden';
                // csrfInput.name = 'csrfToken';
                // csrfInput.value = '서버에서 생성된 토큰 값';
                // form.appendChild(csrfInput);

                document.body.appendChild(form);
                form.submit();

                // AJAX 예시 (주석 처리)
                /*
                fetch('deleteMemberProcess.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        // CSRF 토큰 헤더 추가 (필요시)
                    },
                    body: 'memberId=' + encodeURIComponent(memberId) // + '&csrfToken=...'
                })
                .then(response => response.json()) // 서버 응답이 JSON 형태라고 가정
                .then(data => {
                    if (data.success) {
                        alert('회원이 성공적으로 삭제되었습니다.');
                        location.reload(); // 페이지 새로고침
                    } else {
                        alert('회원 삭제 중 오류가 발생했습니다: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('회원 삭제 중 오류가 발생했습니다.');
                });
                */
            }
        }

        // 수정 버튼 클릭 이벤트는 각 버튼의 onclick 속성에서 직접 처리합니다.
        // function editMember(memberId) {
        //     location.href = 'editMember.jsp?memberId=' + memberId;
        // }
    </script>
</body>
</html>