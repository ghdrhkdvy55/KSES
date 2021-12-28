package egovframework.let.uat.uia.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.google.gson.Gson;
import com.kses.backoffice.bas.menu.service.MenuInfoService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.let.uat.uap.service.EgovLoginPolicyService;
import egovframework.let.uat.uia.service.EgovLoginService;
import egovframework.let.utl.sim.service.EgovClntInfo;
import egovframework.rte.fdl.cmmn.trace.LeaveaTrace;
import egovframework.rte.fdl.property.EgovPropertyService;


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
@Controller
public class EgovLoginController {

	
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovLoginController.class);
	
	
	/** EgovLoginService */
	@Autowired
	private EgovLoginService loginService;

	/** EgovMessageSource */
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;

	/** EgovLoginPolicyService */
	
	@Autowired
	EgovLoginPolicyService egovLoginPolicyService;

	/** EgovPropertyService */
	
	@Autowired
	protected EgovPropertyService propertiesService;
	
	@Autowired
	private MenuInfoService  menuService;

	/** TRACE */
	@Resource(name = "leaveaTrace")
	LeaveaTrace leaveaTrace;

	/**
	 * 로그인 화면으로 들어간다
	 * @param vo - 로그인후 이동할 URL이 담긴 LoginVO
	 * @return 로그인 페이지
	 * @exception Exception
	 */
	@RequestMapping(value = "/backoffice/login.do")
	public String loginUsrView(@ModelAttribute("loginVO") LoginVO loginVO, 
			                   HttpServletRequest request, 
			                   HttpServletResponse response, 
			                   ModelMap model) throws Exception {
		return "/backoffice/login";
	}

	/**
	 * 일반(스프링 시큐리티) 로그인을 처리한다
	 * @param vo - 아이디, 비밀번호가 담긴 LoginVO
	 * @param request - 세션처리를 위한 HttpServletRequest
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
	@RequestMapping(value = "/backoffice/actionSecurityLogin.do")
	public String actionSecurityLogin(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		// 접속IP
		String userIp = EgovClntInfo.getClntIP(request);
		
		// 1. 일반 로그인 처리
		LoginVO resultVO = loginService.actionLogin(loginVO);
		LOGGER.debug("==========================================================");
		LOGGER.debug("userIp:" + userIp);
		resultVO.setIp(userIp);
		LOGGER.debug("==========================================================");
		boolean loginPolicyYn = true;
		
		
        /* 로그인 정책 할건지 확인 필요 
         * 
         * 
		LoginPolicyVO loginPolicyVO = new LoginPolicyVO();
		loginPolicyVO.setEmplyrId(resultVO.getAdminId());
		loginPolicyVO = egovLoginPolicyService.selectLoginPolicy(loginPolicyVO);

		if (loginPolicyVO == null) {
			loginPolicyYn = true;
		} else {
			if (loginPolicyVO.getLmttAt().equals("Y")) {
				if (!userIp.equals(loginPolicyVO.getIpInfo())) {
					loginPolicyYn = false;
				}
			}
		}
		*/
		
		if (resultVO != null && resultVO.getAdminId() != null && !resultVO.getAdminId().equals("") && loginPolicyYn) {
			HttpSession session = request.getSession();
			
			// 2. spring security 연동
			session.setAttribute("LoginVO", resultVO);
			
			//메뉴 가지고 오기 
			List<Map<String, Object>> menuList = menuService.selectMainMenuLeft(resultVO.getAdminId());
			session.setAttribute("Menu", menuList);
			session.setAttribute("MenuJson", new Gson().toJson(menuList));

			ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
			Map<String, UsernamePasswordAuthenticationFilter> beans = act.getBeansOfType(UsernamePasswordAuthenticationFilter.class);
			
			UsernamePasswordAuthenticationFilter springSecurity = null;
			if (beans.size() > 0) {
				springSecurity = (UsernamePasswordAuthenticationFilter) beans.values().toArray()[0];
				springSecurity.setUsernameParameter("egov_security_username");
				springSecurity.setPasswordParameter("egov_security_password");
				springSecurity.setRequiresAuthenticationRequestMatcher(new AntPathRequestMatcher(request.getServletContext().getContextPath() +"/egov_security_login", "POST"));
				
			} else {
				throw new IllegalStateException("No AuthenticationProcessingFilter");
			}
					
			springSecurity.doFilter(new RequestWrapperForSecurity(request, resultVO.getAdminId() , resultVO.getAdminPwd()), response, null);
						
			return "forward:/backoffice/actionMain.do"; // 성공 시 페이지.. (redirect 불가)
		} else {
			return "redirect:/backoffice/login.do?login_error=1";
		}
	}
	
	/**
	 * 로그인 후 메인화면으로 들어간다
	 * @param
	 * @return 로그인 페이지
	 * @exception Exception
	 */
	@RequestMapping(value="/backoffice/actionMain.do")
	public String actionMain( HttpServletRequest request, ModelMap model)  {
    	try{
		    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    	if(!isAuthenticated) {
	    		LOGGER.debug("=== fail:" + isAuthenticated);
	    		throw new Exception();
	    	}
	    	return "forward:/backoffice/index.do";
    	} catch(Exception e){
        	return "redirect:/backoffice/login.do?login_error=2";
    	}
	}

	/**
	 * 로그아웃한다.
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/backoffie/actionLogout.do")
	public String actionLogout(HttpServletRequest request, ModelMap model) throws Exception {
		request.getSession().setAttribute("LoginVO", null);
		
		return "redirect:/egov_security_logout";
	}
	
	@RequestMapping(value="/backoffice/index.do")
	public String index(ModelMap model) {
		return "/backoffice/index";
	}
}

class RequestWrapperForSecurity extends HttpServletRequestWrapper {
	private String username = null;
	private String password = null;

	public RequestWrapperForSecurity(HttpServletRequest request, String username, String password) {
		super(request);

		this.username = username;
		this.password = password;
	}
	
	@Override
	public String getServletPath() {		
		return ((HttpServletRequest) super.getRequest()).getContextPath() + "/egov_security_login";
	}

	@Override
	public String getRequestURI() {		
		return ((HttpServletRequest) super.getRequest()).getContextPath() + "/egov_security_login";
	}

	@Override
	public String getParameter(String name) {
		if (name.equals("egov_security_username")) {
			return username;
		}

		if (name.equals("egov_security_password")) {
			return password;
		}

		return super.getParameter(name);
	}
}