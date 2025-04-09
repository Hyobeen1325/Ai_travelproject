package com.example.demo.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.example.demo.dto.HG_MemberDTO;

public class HG_MemberDAO {
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/sodamdb?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "password";

    static {
        try {
            Class.forName(JDBC_DRIVER);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }



    // 회원 목록 조회 (페이지네이션, 검색 포함)
    public List<HG_MemberDTO> getMembers(int currentPage, int membersPerPage, String searchKeyword) {
        List<HG_MemberDTO> memberList = new ArrayList<>();
        int start = (currentPage - 1) * membersPerPage;
        
        String sql = "SELECT * FROM members WHERE (name LIKE ? OR email LIKE ?) " +
                    "ORDER BY join_date DESC LIMIT ?, ?";
                    
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchKeyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setInt(3, start);
            pstmt.setInt(4, membersPerPage);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                	HG_MemberDTO member = new HG_MemberDTO();
                    member.setMemberId(rs.getInt("member_id"));
                    member.setName(rs.getString("name"));
                    member.setNickname(rs.getString("nickname"));
                    member.setEmail(rs.getString("email"));
                    member.setPhone(rs.getString("phone"));
                    member.setJoinDate(rs.getTimestamp("join_date"));
                    member.setModifyDate(rs.getTimestamp("modify_date"));
                    memberList.add(member);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return memberList;
    }

    // 전체 회원 수 조회 (검색 조건 포함)
    public int getTotalMembers(String searchKeyword) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM members WHERE name LIKE ? OR email LIKE ?";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchKeyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return total;
    }

    // 회원 상세 정보 조회
    public HG_MemberDTO getMemberById(int memberId) {
    	HG_MemberDTO member = null;
        String sql = "SELECT * FROM members WHERE member_id = ?";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    member = new HG_MemberDTO();
                    member.setMemberId(rs.getInt("member_id"));
                    member.setName(rs.getString("name"));
                    member.setNickname(rs.getString("nickname"));
                    member.setEmail(rs.getString("email"));
                    member.setPhone(rs.getString("phone"));
                    member.setJoinDate(rs.getTimestamp("join_date"));
                    member.setModifyDate(rs.getTimestamp("modify_date"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return member;
    }

    // 회원 등록
    public boolean insertMember(HG_MemberDTO member) {
        String sql = "INSERT INTO members (name, nickname, email, phone, password, join_date) " +
                    "VALUES (?, ?, ?, ?, ?, NOW())";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, member.getName());
            pstmt.setString(2, member.getNickname());
            pstmt.setString(3, member.getEmail());
            pstmt.setString(4, member.getPhone());
            pstmt.setString(5, hashPassword(member.getPassword())); // 비밀번호 암호화
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 회원 정보 수정
    public boolean updateMember(HG_MemberDTO member) {
        String sql = "UPDATE members SET name = ?, nickname = ?, email = ?, " +
                    "phone = ?, modify_date = NOW() WHERE member_id = ?";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, member.getName());
            pstmt.setString(2, member.getNickname());
            pstmt.setString(3, member.getEmail());
            pstmt.setString(4, member.getPhone());
            pstmt.setInt(5, member.getMemberId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 회원 삭제
    public boolean deleteMember(int memberId) {
        String sql = "DELETE FROM members WHERE member_id = ?";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 이메일 중복 확인
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM members WHERE email = ?";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    // 비밀번호 암호화 메서드
    private String hashPassword(String password) {
        // 실제 구현시에는 BCrypt나 다른 암호화 알고리즘을 사용해야 합니다.
        // 예시로 간단한 해시 처리만 구현
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            
            return hexString.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}