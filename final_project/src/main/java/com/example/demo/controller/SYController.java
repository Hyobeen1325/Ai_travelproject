package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.dto.LoginDTO;
import com.example.demo.dto.MemberDTO;
import com.example.demo.dto.MypageUpDTO;
import com.example.demo.dto.UpdatePwdDTO;
import com.example.demo.dto.AdminUpDTO;
import com.example.demo.dto.FindIDDTO;
import com.example.demo.dto.FindPwdDTO;

import com.example.demo.service.SYService; // member service 
import jakarta.servlet.http.HttpSession; // 세션 관리
import jakarta.validation.Valid; // 의존성 주입


@Controller
@RequestMapping("/login") // 클래스 공통 경로
public class SYController { // 유저 관리 컨트롤러

    // Rest API
    @Value("${kakao.client_id}")
    private String client_id;

    // Redirect URI
    @Value("${kakao.redirect_uri}")
    private String redirect_uri;

    // Member Service
    @Autowired
    private SYService service;
    
    // 관리자 아이디 설정 
    private static final String Admin_Email = "admin@email.com";
    // 관리자 권한 확인 
    private boolean isAdmin(MemberDTO AdminMember) {
        return AdminMember != null && AdminMember.getEmail().equals(Admin_Email);
    }

    
    // 로그인 페이지
    // http://localhost:8080/login
    
    // kakao 통합 로그인 페이지
    @GetMapping("")
    public String loginpage(Model model) {
        // kakao 로그인 성공 시, URL 생성 후 login.jsp로 전달
        String location = "https://kauth.kakao.com/oauth/authorize?response_type=code"
                + "&client_id=" + client_id // REST API 키
                + "&redirect_uri=" + redirect_uri; // Redirect URI
        model.addAttribute("location", location); // location로 생성된 URL 전달
        return "login"; // /WEB-INF/jsp/login.jsp
    }

    // kakao 통합 로그인 계정 정보
    // http://localhost:8080/login/kakaologin?code=...
    @GetMapping("/kakaologin")
    public String kakaologin(@RequestParam("code") String code, HttpSession session, Model model) {
        // 카카오 access_token 요청 및 사용자 정보 처리
        System.out.print("kakao 로그인 성공"); // 확인 메세지
        model.addAttribute("msg", "카카오 로그인 성공! 받은 code: " + code); // code 확인 메세지
        session.setAttribute("kakaologin", true); // 세션에 kakako 계정 정보 저장
        return "project1"; //  /WEB-INF/jsp//project1.jsp
    }
    
    // 회원가입 페이지
    @GetMapping("/register")
    public String joinpage() {
        return "register"; // /WEB-INF/jsp/register.jsp
    }

    
    // 아이디 찾기/비밀번호 찾기 페이지 
    // http://localhost:8080/login/find
    @GetMapping("/find")
    public String findpage() {
    	return "find"; // /WEB-INF/jsp/find.jsp
    }
    
    // 아이디 찾기 유효성 검사 (이름, 전화번호) 
    @PostMapping("/findid")
    public String findid(@RequestParam("name") String name, @RequestParam("phon_num") String phon_num, 
    					HttpSession session, Model model) {
    	
    	// null 또는 공백인 경우 
    	if(name == null || name.trim().isEmpty() || phon_num == null || phon_num.trim().isEmpty()) {
    		// trim() : 공백 제거, isEmpty() : 문자길이 체크
    		model.addAttribute("msg", "이름과 전화번호 둘다 입력해주세요."); // 알림 메세지
    		return "find"; 
    	} 
    	
    	// 아이디 찾기 
    	FindIDDTO findIDRequest = new FindIDDTO();
    	findIDRequest.setName(name); // 이름 
    	findIDRequest.setPhon_num(phon_num); // 전화번호
    	
    	String foundID = service.findID(findIDRequest); 
    	
    	// 아이디 찾기 성공 
    	if(foundID!= null && !foundID.isEmpty()) {
    		System.out.print("아이디 찾기 성공"); // 확인 메세지 
    		model.addAttribute("msg", "아이디 찾기 성공!"); // 알림 메세지 
    		model.addAttribute("foundid",foundID); 
    		session.invalidate(); // 세션으로 member 무효화
    		return "foundid";  // /WEB-INF/jsp/findid.jsp
    		
    	// 아이디 찾기 실패
    	}else{
    		System.out.print("아이디 찾기 실패"); // 확인 메세지 
    		model.addAttribute("msg", "아이디 찾기 실패"); // 알림 메세지 
    		return "find"; 
    	}
    	
    }
    
    
    // 비밀번호 찾기 유효성 검사 (이메일) 
    @PostMapping("/findpwd")
    public String findpwd(@Valid FindPwdDTO findpwd, BindingResult bindingResult, Model model) {
    	// Valid : 유효성 검사, BindingResult : 유효성 결과 및 오류 확인
    	if(bindingResult.hasErrors()) {
    		System.out.print("이메일 유효성 검사 실패"); // 확인 메세지 
    		model.addAttribute("msg", "이메일 유효성 검사 실패"); // 알림 메세지
    		model.addAttribute("msg", bindingResult.getFieldError("email").getDefaultMessage());
    		return "find";
    	}
    	
    	String resultMsg = service.findPwd(findpwd);
    	model.addAttribute("msg", resultMsg);
    	
    	// 발송 성공 
    	if(resultMsg.contains("발송 완료")) { 
    		System.out.print("임시 비밀번호 발송 성공!"); // 확인 메세지 
    		model.addAttribute("msg","임시 비밀번호 발송 성공"); // 알림 메세지
    		return "login";
    		
    	// 발송 실패 	
			} else {
				System.out.print("임시 비밀번호 발송 실패"); // 확인 메세지 
				model.addAttribute("msg","임시 비밀번호 발송 실패"); // 알림 메세지
    		return "find";
    	}
    	
    }
    
    
    // 로그인 유효성 검사 (아이디, 비밀번호)
    @PostMapping("/member")
    public String login(LoginDTO loginRequest, HttpSession session, Model model) {
        MemberDTO response = service.login(loginRequest); 

        // 로그인 성공
        if (response != null) {
            System.out.print("로그인 성공"); // 확인 메세지
            model.addAttribute("msg", "로그인 성공!"); // 성공 메세지
            model.addAttribute("member", response); // member 정보
            session.setAttribute("SessionMember", response);  // 세션에 member 저장
            session.setAttribute("kakaologin", false); // kakao 계정 일반로그인 거부 설정
            return "project1"; 

        // 로그인 실패
        } else {
            model.addAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "login"; 
        }
    }

    // 로그아웃
    @PostMapping("/logout")
    public String logout(HttpSession session, Model model) {
        String response = service.logout();
        
        System.out.print("로그아웃 성공"); // 확인 메세지
        model.addAttribute("msg", "로그아웃 성공! 로그인 창으로 이동합니다."); // 성공 메세지
        model.addAttribute("msg", response); // member 정보
        session.invalidate(); // 세션으로 member 무효화
        return "redirect:/login"; 
    }

    
    // 관리자 페이지
    // http://localhost:8080/login/admin
    @GetMapping("/admin")
    public String adminPage(Model model, @SessionAttribute(name = "SessionMember", required = false) MemberDTO AdminMember) {
        if (!isAdmin(AdminMember)) {
            model.addAttribute("msg", "관리자 권한이 필요합니다.");
            return "redirect:/login";
        }
        List<MemberDTO> memberList = service.adminpage();
        model.addAttribute("member", memberList);
        return "adminpage"; // 관리자 페이지
    }

    // 일부 회원정보 조회 (이름) : 검색용 
    @GetMapping("/admin/name")
    public String AdminMember(@RequestParam("memberName") String memberName, Model model,
                              @SessionAttribute(name = "SessionMember", required = false) MemberDTO AdminMember) {
        if (!isAdmin(AdminMember)) {
            model.addAttribute("msg", "관리자 권한이 필요합니다.");
            return "redirect:/login";
        }
        List<MemberDTO> memberlist = service.adminMemberNeme(memberName);
        model.addAttribute("member", memberlist);
        return "adminpage";
    }

    // 회원정보 조회 (수정)
    @GetMapping("/admin/{memberEmail}")
    public String updateAdminForm(@PathVariable("memberEmail") String memberEmail, Model model,
                                  @SessionAttribute(name = "SessionMember", required = false) MemberDTO AdminMember) {
        if (!isAdmin(AdminMember)) {
            model.addAttribute("msg", "관리자 권한이 필요합니다.");
            return "redirect:/login";
        }
        MemberDTO member = service.mypage(memberEmail); // mypage 메소드 재활용 (단일 회원 조회)
        if (member != null) {
            model.addAttribute("member", member);
            return "admin/updateadmin"; // 수정 폼 페이지
        } else {
            model.addAttribute("msg", "해당 회원의 정보를 찾을 수 없습니다.");
            return "redirect:/login/admin";
        }
    }

    // 회원정보 수정
    @PostMapping("/admin/{memberEmail}")
    public String updateAdmin(@PathVariable("memberEmail") String memberEmail, @ModelAttribute AdminUpDTO updateMember,
                              Model model, @SessionAttribute(name = "SessionMember", required = false) MemberDTO AdminMember) {
        if (!isAdmin(AdminMember)) {
            model.addAttribute("msg", "관리자 권한이 필요합니다.");
            return "redirect:/login";
        }
        MemberDTO updatedMember = service.updateAdminMember(memberEmail, updateMember);
        if (updatedMember != null) {
            model.addAttribute("msg", "회원 정보 수정 성공"); // 성공 메시지 전달
            return "redirect:/login/admin";
        } else {
            model.addAttribute("msg", "회원 정보 수정 실패"); // 실패 메시지 전달
            MemberDTO originalMember = service.mypage(memberEmail);
            model.addAttribute("member", originalMember); // 기존 정보 다시 전달
            return "admin/updateadmin"; // 수정 폼으로 리다이렉트
        }
    }

    // 회원탈퇴 (삭제)
/*
    @DeleteMapping("/admin/{memberEmail}")
    public String deleteAdmin(@PathVariable("memberEmail") String memberEmail,
                              @SessionAttribute(name = "SessionMember", required = false) MemberDTO AdminMember,
                              RedirectAttributes redirectAttributes,
                              Model model) {
        if (!isAdmin(AdminMember)) {
            redirectAttributes.addFlashAttribute("msg", "관리자 권한이 필요합니다.");
            return "redirect:/login";
        }
        boolean deleted = service.deleteAdminMember(memberEmail);
        if (deleted) {
            model.addAttribute("msg", "회원탈퇴 성공");
            redirectAttributes.addFlashAttribute("msg", "회원탈퇴 성공");
        } else {
            model.addAttribute("msg", "회원탈퇴 실패");
            redirectAttributes.addFlashAttribute("msg", "회원탈퇴 실패");

        }
        return "redirect:/login/admin";
    }
*/


    
    // 마이페이지 
    // 내정보 조회
    @GetMapping("/mypage/{email}")
    public String mypage(@PathVariable("email") String email, HttpSession session, Model model) {
        // header 마이페이지 버튼 클릭 시, 세션 유지
        MemberDTO SessionMember = (MemberDTO) session.getAttribute("SessionMember");
        
        if (SessionMember != null && SessionMember.getEmail().equals(email)) {
            model.addAttribute("member", SessionMember); // 세션으로 로그인 중인 member 유지
            return "mypage"; // /WEB-INF/jsp/mypage.jsp
            
        } else {
            // 마이페이지 안의 내정보 데이터 처리
            MemberDTO response = service.mypage(email); // db 일치 여부 확인
            // 조회 성공 
            if (response != null) {
                System.out.print("내정보 조회 성공"); // 확인 메세지 
                model.addAttribute("msg", "내정보 조회 성공!"); // 알림 메세지 
                model.addAttribute("member", response); // member 정보
                session.setAttribute("SessionMember", response); // 세션 유지
                return "mypage"; 
                
            // 조회 실패 
            } else { 
                System.out.print("내정보 조회 실패"); // 확인 메세지 
                model.addAttribute("msg", "내정보 조회 실패!"); // 적절한 실패 메시지
                session.invalidate(); // 세션 무효화
                return "redirect:/login"; 
            }
        }
    }

    // 내정보 수정
    @PostMapping("/mypage/{email}")
    public String updateMypage(@PathVariable("email") String email, @ModelAttribute MypageUpDTO updateRequest,
                               HttpSession session, Model model) {

        // 수정 후에도 현재 로그인 중인 member 세션 유지 
        MemberDTO SessionMember = (MemberDTO) session.getAttribute("SessionMember");
        if (SessionMember == null || !SessionMember.getEmail().equals(email)) { // 세션이 유효하지 않은 경우 
            model.addAttribute("msg", "다시 로그인해주세요.");
            return "redirect:/login"; 
        }

        MemberDTO response = service.updateMypage(email, updateRequest);
        
        // 이메일 중복 확인 
        if (response == null) { // 이메일 수정 실패
            model.addAttribute("msg", "이미 사용 중인 이메일 입니다. 다른 이메일을 입력해주세요.");
            model.addAttribute("member", SessionMember); // 기존 정보 유지
            return "mypage"; 
            
        // 수정 성공
        } else { 
            System.out.print("내정보 수정 성공"); // 확인 메세지 
            model.addAttribute("msg", "내정보 수정 성공!"); // 알림 메세지
            model.addAttribute("member", response); // 수정 정보 갱신
            session.setAttribute("SessionMember", response); // 세션 갱신
            return "mypage"; 
        }
    }

    // 비밀번호 변경
    @PostMapping("/mypage/{email}/pwd")
    public String updatePwd(@PathVariable("email") String email,@ModelAttribute UpdatePwdDTO updateRequest,
                            HttpSession session, Model model) {
        // 현재 로그인 중인 member 세션 유지
        MemberDTO SessionMember = (MemberDTO) session.getAttribute("SessionMember");

        // 로그인 변경 대상 member 유효성 검사
        if (SessionMember == null || !SessionMember.getEmail().equals(email)) { // 세션이 유효하지 않을 경우
            model.addAttribute("msg", "다시 로그인해주세요.");
            return "login"; 
        }

        // 비밀번호 변경 서비스 호출
        MemberDTO response = service.updatePwd(email, updateRequest);

        if (response != null) { // 비밀번호 변경 성공 
            System.out.print("비밀번호 변경 성공");
            model.addAttribute("msg", "비밀번호 수정 성공");
            model.addAttribute("member", response); // 변경된 정보 갱신 (이름, 닉네임, 전화번호 그대로 유지)
            session.setAttribute("SessionMember", response); // 세션 갱신
            return "mypage";
             
        } else { // 비밀번호 변경 실패 
            System.out.print("비밀번호 변경 실패");
            model.addAttribute("msg", "현재 비밀번호가 일치하지 않거나, 비밀번호 변경에 실패했습니다.");
            model.addAttribute("member", SessionMember); // 기존 정보 유지
            return "mypage";
        }
    }
}