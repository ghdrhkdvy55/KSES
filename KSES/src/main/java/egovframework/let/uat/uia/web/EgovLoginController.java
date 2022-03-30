package egovframework.let.uat.uia.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.kses.backoffice.bas.menu.service.MenuInfoService;
import com.kses.backoffice.sym.log.service.LoginLogService;
import com.kses.backoffice.sym.log.vo.LoginLog;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovRequestWrapperForSecurity;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.cmm.web.EgovAuthenticationFailureHandler;
import egovframework.let.uat.uia.service.EgovLoginService;
import egovframework.let.utl.sim.service.EgovClntInfo;
import egovframework.rte.fdl.cmmn.trace.LeaveaTrace;
import lombok.extern.slf4j.Slf4j;

/**
 * 일반 로그인, 인증서 로그인을 처리하는 컨트롤러 클래스
 * @author 공통서비스 개발팀 박지욱
 * @since 2009.03.06
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2009.03.06  박지욱          최초 생성
 *  2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성
 *
 *  </pre>
 */
@Slf4j
@Controller
public class EgovLoginController {
	
	@Autowired
	EgovLoginService loginService;

	@Autowired
	LoginLogService loginLogService;
	
	@Autowired
	MenuInfoService  menuService;

	@Resource(name = "leaveaTrace")
	LeaveaTrace leaveaTrace;

	@Autowired
	EgovAuthenticationFailureHandler egovAuthenticationFailureHandler;
	
	/**
	 * 로그인 화면
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/backoffice/login.do")
	public String loginUsrView() throws Exception {
		return "/backoffice/login";
	}

	/**
	 * 관리자 로그인 처리 - 스프링 시큐리티
	 * @param loginVO
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/backoffice/actionSecurityLogin.do", method = RequestMethod.POST)
	public void actionSecurityLogin(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		String clientIp = EgovClntInfo.getClntIP(request);
		ApplicationContext applicationContext = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
		Map<String, UsernamePasswordAuthenticationFilter> beans = applicationContext.getBeansOfType(UsernamePasswordAuthenticationFilter.class);
		UsernamePasswordAuthenticationFilter springSecurity = null;
		if (beans.size() > 0) {
			springSecurity = (UsernamePasswordAuthenticationFilter) beans.values().toArray()[0];
			springSecurity.setUsernameParameter("egov_security_username");
			springSecurity.setPasswordParameter("egov_security_password");
			springSecurity.setAuthenticationFailureHandler(egovAuthenticationFailureHandler);
			springSecurity.setRequiresAuthenticationRequestMatcher(new AntPathRequestMatcher(request.getServletContext().getContextPath() +"/egov_security_login", "POST"));
		}
		else {
			throw new IllegalStateException("No AuthenticationProcessingFilter");
		}
		springSecurity.doFilter(new EgovRequestWrapperForSecurity(request, loginVO.getAdminId(), SmartUtil.getEncryptSHA256(loginVO.getAdminPwd()), clientIp), response, null);
	}
	
	/**
	 * 로그인 후 권한 체크 분기 처리
	 * @param
	 * @return 로그인 페이지
	 * @exception Exception
	 */
	@RequestMapping(value="/backoffice/actionMain.do")
	public String actionMain(HttpServletRequest request, HttpSession session) throws Exception {
		if (!EgovUserDetailsHelper.isAuthenticated()) {
			return "redirect:/backoffice/login.do?login_error=1";
		}
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		// 메뉴정보 세션에 저장
		List<Map<String, Object>> menuList = menuService.selectMainMenuLeft(loginVO.getAdminId());
		session.setAttribute("MenuJson", new Gson().toJson(menuList));
		// 로그인 성공 기록
		try {
			String clientIp = EgovClntInfo.getClntIP(request);
			LoginLog loginLog = new LoginLog();
			loginLog.setConnectMthd(Globals.LOGIN_CONNECT_MTHD_I);
			loginLog.setConnectId(loginVO.getAdminId());
			loginLog.setConnectIp(clientIp);
			loginLog.setErrorOccrrAt("Y");
			loginLogService.logInsertLoginLog(loginLog);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		
		return "forward:/backoffice/index.do";
	}

	/**
	 * 로그아웃한다.
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/backoffie/actionLogout.do")
	public String actionLogout(HttpServletRequest request, ModelMap model) throws Exception {
		String userIp = EgovClntInfo.getClntIP(request);
		String adminId = EgovUserDetailsHelper.getAuthenticatedUserId();
		
		// 로그아웃 성공 기록
		try {
			LoginLog loginLog = new LoginLog();
			loginLog.setConnectId(adminId);
			loginLog.setConnectIp(userIp);
			loginLog.setConnectMthd(Globals.LOGIN_CONNECT_MTHD_O);
			loginLog.setErrorOccrrAt("N");
			loginLogService.logInsertLoginLog(loginLog);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		
		return "redirect:/egov_security_logout";
	}
	
	/**
	 * 메인 화면 이동
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/backoffice/index.do")
	public ModelAndView index() {
		ModelMap model = new ModelMap();
		log.info("EgovUserDetailsHelper.isAuthenticated(): "+ EgovUserDetailsHelper.isAuthenticated());
		if (EgovUserDetailsHelper.isAuthenticated()) {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			model.addAttribute("usernmae", loginVO.getEmpNm());
			model.addAttribute("authorcode", loginVO.getAuthorCd());
			model.addAttribute("centercode", loginVO.getCenterCd());
			model.addAttribute("adminId", loginVO.getAdminId());
		}
		return new ModelAndView("/backoffice/index", model);
	}
	
}