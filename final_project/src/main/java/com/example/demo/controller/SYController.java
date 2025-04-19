<<<<<<< HEAD
package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dto.LoginDTO;
import com.example.demo.dto.MemberDTO;
import com.example.demo.dto.MypageUpDTO;
import com.example.demo.service.SYService;

import jakarta.servlet.http.HttpSession; // spring boot 3.0 버전 이상

@Controller
@RequestMapping("/login")  // 클래스 공통 경로
public class SYController { // 유저 관리 컨트롤러
    
	// Rest API
    @Value("${kakao.client_id}") 
    private String client_id;
    
    // Redirect URI
    @Value("${kakao.redirect_uri}")
    private String redirect_uri;
    
    // Member service
    @Autowired
    private SYService service;

    // 로그인 페이지 
    // http://localhost:8080/login
    @GetMapping("")
    public String loginpage(Model model) {
        // kakao 로그인 성공 시, URL 생성 후 login.jsp로 전달
        String location = "https://kauth.kakao.com/oauth/authorize?response_type=code"
                        + "&client_id=" + client_id // REST API 키
                        + "&redirect_uri=" + redirect_uri; // Redirect URI
        model.addAttribute("location", location); 

        return "login"; // /WEB-INF/jsp/login.jsp
    }
    
    // kakao 로그인 redirect 
    // http://localhost:8080/login/kakaologin?code=...
    @GetMapping("/kakaologin")
    public String kakaologin(@RequestParam("code") String code, Model model) {
        // TODO: 카카오 access_token 요청 및 사용자 정보 처리
        model.addAttribute("msg", "카카오 로그인 성공! 받은 code: " + code);
        // 메인 페이지로 이동 
        return "redirect:/project1"; //  /WEB-INF/jsp//project1.jsp
    }
    

    // 회원가입 페이지
    @GetMapping("/join")
    public String joinpage() {
        return "/Membership_managemen"; // /WEB-INF/jsp/Membership_managemen.jsp
    }
        
    // 로그인 유효성 검사 (아이디, 비밀번호) 
    @PostMapping("/member")
    public String login(LoginDTO loginRequest, HttpSession session, Model model) {
    	 MemberDTO response = service.login(loginRequest); // db 일치 여부 확인
    	 
    	 // 로그인 성공 
    	 if (response != null) {
             model.addAttribute("msg", "로그인 성공!"); // 성공 메세지 
             model.addAttribute("member", response); 
             session.setAttribute("SessionMember", response);  // 세션에 member 저장
             return "mypage"; // /WEB-INF/jsp/project1.jsp
             
         // 로그인 실패     
         } else {
             model.addAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
             return "login"; // /WEB-INF/jsp/login.jsp
         }
   
   }
    
    // 로그아웃 
    @PostMapping("/logout")
    public String logout(HttpSession session, Model model) {
    	String response = service.logout(); 
    	model.addAttribute("msg","로그아웃 성공! 로그인 창으로 이동합니다.");
    	model.addAttribute("msg", response);
    	session.invalidate(); // 세션으로 member 무효화
    	return "redirect:/login";
    }
    
    
    // 마이 페이지 (내정보 관리)
    // http://localhost:8080/login/mypage
    // 내정보 조회 
    @GetMapping("/mypage/{email}")
    public String mypage(@PathVariable("email") String email, HttpSession session, Model model) {
    	
    	// header 마이페이지 버튼 클릭 시, 세션 유지
    	MemberDTO SessionMember = (MemberDTO) session.getAttribute("SessionMember"); // 세션에 member 정보 저장 
    	if (SessionMember != null &&  SessionMember.getEmail().equals(email)) {
    		model.addAttribute("member", SessionMember); // 세션으 member 유지
    		return "mypage"; // /WEB-INF/jsp/mypage.jsp
    		
    	} else { 
    		
    		// 마이페이지 안의 내정보 데이터 처리 
	    	MemberDTO response = service.mypage(email); // db 일치 여부 확인
	    	// 내정보 조회 성공 
	    	if (response != null) {
	    		model.addAttribute("msg", "내정보 조회 성공!");
	    		model.addAttribute("member", response);
	    		session.setAttribute("SessionMember", response); // 세션 유지
	    		return "mypage"; // /WEB-INF/jsp/login.jsp
	    	
	    	// 내정보 조회 실패 
	    	} else {
	    		model.addAttribute("msg","내정보 조회 실패!"); // 로그아웃
	    		session.invalidate(); // 세션으로 member 무효화
	            return "redirect:/login"; // /WEB-INF/jsp/login.jsp 
	    		
	    	}
	    
	     }
    
  }
    // 내정보 수정
    @PostMapping("/mypage/{email}")
    public String updateMypage(@PathVariable("email") String email, 
            		@ModelAttribute MypageUpDTO updateRequest, HttpSession session,
            		Model model) {
    	// 수정된 member db 저장 후 정보 가져오기
    	MemberDTO response = service.updateMypage(email, updateRequest);  


        if (response != null) { // 내정보 수정 성공 
            model.addAttribute("msg", "내정보 수정 성공!");
            model.addAttribute("member", response); // 수정된 회원 정보 전달
            session.setAttribute("SessionMember", response); // 세션 유지
            return "mypage"; // /WEB-INF/jsp/mypage.jsp
            
        } else { // 내정보 수정 실패 
            model.addAttribute("msg", "내정보 수정 실패!");
            session.invalidate(); // 세션으로 member 무효화
            return "login"; 
       }
   }
    
    
    
    
=======
package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dto.LoginDTO;
import com.example.demo.dto.MemberDTO;
import com.example.demo.dto.MypageUpDTO;
import com.example.demo.service.SYService;

import jakarta.servlet.http.HttpSession; // spring boot 3.0 버전 이상

@Controller
@RequestMapping("/login")  // 클래스 공통 경로
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

    
    // 로그인 페이지 
    // http://localhost:8080/login
    
    // kakao 통합 로그인 
    @GetMapping("")
    public String loginpage(Model model) {
        // kakao 로그인 성공 시, URL 생성 후 login.jsp로 전달
        String location = "https://kauth.kakao.com/oauth/authorize?response_type=code" 
                        + "&client_id=" + client_id // REST API 키
                        + "&redirect_uri=" + redirect_uri; // Redirect URI
        model.addAttribute("location", location); // location로 생성된 URL 전달
        return "login"; // /WEB-INF/jsp/login.jsp
    }
    
    // kakao 통합로그인 계정 정보 
    // http://localhost:8080/login/kakaologin?code=...
    @GetMapping("/kakaologin")
    public String kakaologin(@RequestParam("code") String code, HttpSession session, Model model) {
        // 카카오 access_token 요청 및 사용자 정보 처리
    	System.out.print("kakao 로그인 성공"); // 확인 메세지
        model.addAttribute("msg", "카카오 로그인 성공! 받은 code: " + code);
        session.setAttribute("kakaologin", true); // 세션에 kakako 계정 정보 저장
        // 메인 페이지로 이동 
        return "test2"; //  /WEB-INF/jsp//project1.jsp
    }
    

    // 회원가입 페이지
    @GetMapping("/join")
    public String joinpage() {
        return "Membership_managemen"; // /WEB-INF/jsp/Membership_managemen.jsp
    }
        
    // 로그인 유효성 검사 (아이디, 비밀번호) 
    @PostMapping("/member")
    public String login(LoginDTO loginRequest, HttpSession session, Model model) {
    	 MemberDTO response = service.login(loginRequest); // db 일치 여부 확인
    	 
    	 // 로그인 성공 
    	 if (response != null) {
    		 System.out.print("로그인 성공"); // 확인 메세지
             model.addAttribute("msg", "로그인 성공!"); // 성공 메세지 
             model.addAttribute("member", response); // member 정보
             session.setAttribute("SessionMember", response);  // 세션에 member 저장
             session.setAttribute("kakaologin", false); // kakao 계정 로그인 거부
             return "mypage"; // /WEB-INF/jsp/project1.jsp
             
         // 로그인 실패     
         } else {
             model.addAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
             return "login"; // /WEB-INF/jsp/login.jsp
         }
   
   }
    
    // 로그아웃 
    @PostMapping("/logout")
    public String logout(HttpSession session, Model model) {
    	String response = service.logout();
    	System.out.print("로그아웃 성공"); // 확인 메세지
    	model.addAttribute("msg","로그아웃 성공! 로그인 창으로 이동합니다."); // 성공 메세지
    	model.addAttribute("msg", response); // member 정보
    	session.invalidate(); // 세션으로 member 무효화
    	return "redirect:/login"; // /WEB-INF/jsp/login.jsp
    }
    
    
    // 마이 페이지 (내정보 관리)
    // http://localhost:8080/login/mypage
    // 내정보 조회 
    @GetMapping("/mypage/{email}")
    public String mypage(@PathVariable("email") String email, HttpSession session, Model model) {
    	// header 마이페이지 버튼 클릭 시, 세션 유지
    	MemberDTO SessionMember = (MemberDTO) session.getAttribute("SessionMember"); // 세션에 member 정보 저장 
    	if (SessionMember != null &&  SessionMember.getEmail().equals(email)) {
    		model.addAttribute("member", SessionMember); // 세션으로 로그인 중인 member 유지
    		return "mypage"; // /WEB-INF/jsp/mypage.jsp
    		
    	} else { 		
    		// 마이페이지 안의 내정보 데이터 처리 
	    	MemberDTO response = service.mypage(email); // db 일치 여부 확인
	    	// 내정보 조회 성공 
	    	if (response != null) {
	    		System.out.print("마이페이지 조회 성공"); // 확인 메세지
	    		model.addAttribute("msg", "내정보 조회 성공!");
	    		model.addAttribute("member", response);
	    		session.setAttribute("SessionMember", response); // 세션 유지
	    		return "mypage"; // /WEB-INF/jsp/mypage.jsp
	    	
	    	// 내정보 조회 실패 
	    	} else {
	    		System.out.print("마이페이지 조회 실패"); // 확인 메세지
	    		model.addAttribute("msg","내정보 조회 실패!"); // 로그아웃
	    		session.invalidate(); // 세션으로 member 무효화
	            return "redirect:/login"; // /WEB-INF/jsp/login.jsp 
	    		
	    	}
	    
	     }
    
  }
    // 내정보 수정
    @PostMapping("/mypage/{email}")
    public String updateMypage(@PathVariable("email") String email, 
            		@ModelAttribute MypageUpDTO updateRequest, 
            		HttpSession session, Model model) {
    	// 수정된 member db 저장 후 정보 가져오기
    	MemberDTO response = service.updateMypage(email, updateRequest);  

    	// 내정보 수정 성공 
        if (response != null) { 
        	System.out.print("마이페이지 수정 성공"); // 확인 메세지
            model.addAttribute("msg", "내정보 수정 성공!");
            model.addAttribute("member", response); // 수정된 회원 정보 전달
            session.setAttribute("SessionMember", response); // 세션 유지
            return "mypage"; // /WEB-INF/jsp/mypage.jsp
       
        // 내정보 수정 실패 
        } else { 
        	System.out.print("마이페이지 수정 실패"); // 확인 메세지
            model.addAttribute("msg", "내정보 수정 실패!");
            session.invalidate(); // 세션으로 member 무효화
            return "login";  // /WEB-INF/jsp/login.jsp
       }
   }
 
>>>>>>> branch 'develop' of https://github.com/Hyobeen1325/Ai_travelproject.git
}