package com.example.demo.controller;

import com.example.demo.dao.HG_MemberDAO;
import com.example.demo.dto.HG_MemberDTO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
// http://localhost:8080/join
@RequestMapping("/join")
public class HG_JoinController {
//    
//    private final HG_MemberDAO memberDAO;
//    
//    public HG_JoinController() {
//        memberDAO = new HG_MemberDAO();
//    }
//    
    @GetMapping("")
    public String showJoinForm() {
        // 회원가입 폼 표시
        return "join_member"; // join_member.jsp를 호출
    }
    
//    @PostMapping
//    public String processJoin(
//            @RequestParam("name") String name,
//            @RequestParam("nickname") String nickname,
//            @RequestParam("email") String email,
//            @RequestParam("phone") String phone,
//            @RequestParam("password") String password,
//            Model model,
//            RedirectAttributes redirectAttributes) {
//        
//        // 회원가입 처리
//        HG_MemberDTO member = new HG_MemberDTO();
//        member.setName(name);
//        member.setNickname(nickname);
//        member.setEmail(email);
//        member.setPhone(phone);
//        member.setPassword(password); // 실제 구현시 암호화 필요
//        
//        try {
//            // 유효성 검사
//            if (!validateMemberInput(member)) {
//                model.addAttribute("error", "입력값이 올바르지 않습니다.");
//                return "join_member";
//            }
//            
//            // 중복 확인
//            if (memberDAO.isEmailExists(member.getEmail())) {
//                model.addAttribute("error", "이미 사용 중인 이메일입니다.");
//                return "join_member";
//            }
//            
//            // 회원가입 처리
//            boolean success = memberDAO.insertMember(member);
//            
//            if (success) {
//                // 회원가입 성공 시 로그인 페이지로 리다이렉트
//                redirectAttributes.addFlashAttribute("message", "회원가입이 성공적으로 완료되었습니다.");
//                return "redirect:/login";
//            } else {
//                throw new Exception("회원가입 처리 중 오류가 발생했습니다.");
//            }
//        } catch (Exception e) {
//            model.addAttribute("error", e.getMessage());
//            return "join_member";
//        }
//    }
//    
//    private boolean validateMemberInput(HG_MemberDTO member) {
//        // 이름 검사
//        if (member.getName() == null || member.getName().trim().isEmpty()) {
//            return false;
//        }
//        
//        // 이메일 형식 검사
//        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
//        if (member.getEmail() == null || !member.getEmail().matches(emailRegex)) {
//            return false;
//        }
//        
//        // 전화번호 형식 검사
//        String phoneRegex = "^010-\\d{4}-\\d{4}$";
//        if (member.getPhone() == null || !member.getPhone().matches(phoneRegex)) {
//            return false;
//        }
//        
//        // 비밀번호 검사 (8자 이상)
//        if (member.getPassword() == null || member.getPassword().length() < 8) {
//            return false;
//        }
//        
//        return true;
//    }
}