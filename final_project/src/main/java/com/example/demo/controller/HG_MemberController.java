package com.example.demo.controller;

import com.example.demo.dao.HG_MemberDAO;
import com.example.demo.dto.HG_MemberDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
//http://localhost:8080/admin/member/
@WebServlet("/admin/member/*")
public class HG_MemberController extends HttpServlet {
    private HG_MemberDAO memberDAO;

    @Override
    public void init() throws ServletException {
        memberDAO = new HG_MemberDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        switch (pathInfo) {
            case "/list":
                listMembers(request, response);
                break;
            case "/edit":
                showEditForm(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/member/list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        switch (pathInfo) {
            case "/delete":
                deleteMember(request, response);
                break;
            case "/update":
                updateMember(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/member/list");
                break;
        }
    }

    private void listMembers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 페이지네이션 처리
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            currentPage = Integer.parseInt(pageParam);
        }

        // 검색어 처리
        String searchKeyword = request.getParameter("searchKeyword");
        if (searchKeyword == null) {
            searchKeyword = "";
        }

        int membersPerPage = 10;
        int totalMembers = memberDAO.getTotalMembers(searchKeyword);
        int totalPages = (int) Math.ceil((double) totalMembers / membersPerPage);

        List<HG_MemberDTO> memberList = memberDAO.getMembers(currentPage, membersPerPage, searchKeyword);

        request.setAttribute("memberList", memberList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchKeyword", searchKeyword);

        request.getRequestDispatcher("/WEB-INF/views/admin/Membership_management.jsp")
               .forward(request, response);
    }

    private void deleteMember(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int memberId = Integer.parseInt(request.getParameter("memberId"));
        boolean success = memberDAO.deleteMember(memberId);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\": " + success + "}");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int memberId = Integer.parseInt(request.getParameter("memberId"));
        HG_MemberDTO member = memberDAO.getMemberById(memberId);
        
        request.setAttribute("member", member);
        request.getRequestDispatcher("/WEB-INF/views/admin/editMember.jsp")
               .forward(request, response);
    }

    private void updateMember(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	HG_MemberDTO member = new HG_MemberDTO();
        member.setMemberId(Integer.parseInt(request.getParameter("memberId")));
        member.setName(request.getParameter("name"));
        member.setEmail(request.getParameter("email"));
        member.setPhone(request.getParameter("phone"));
        
        boolean success = memberDAO.updateMember(member);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/member/list");
        } else {
            request.setAttribute("error", "회원 정보 수정에 실패했습니다.");
            showEditForm(request, response);
        }
    }
}