package egovframework.com.cmm.interceptor;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

/**
 * 인증여부 체크 인터셉터
 * @author 공통서비스 개발팀 서준식
 * @since 2011.07.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2011.07.01  서준식          최초 생성
 *  2011.09.07  서준식          인증이 필요없는 URL을 패스하는 로직 추가
 *  2014.06.11  이기하          인증이 필요없는 URL을 패스하는 로직 삭제(xml로 대체)
 *  </pre>
 */

public class AuthenticInterceptor extends WebContentInterceptor {

	/**
	 * 세션에 계정정보(LoginVO)가 있는지 여부로 인증 여부를 체크한다.
	 * 계정정보(LoginVO)가 없다면, 로그인 페이지로 이동한다.
	 */
	private static final Logger LOGGER = LoggerFactory.getLogger(AuthenticInterceptor.class);
	
	
	boolean isPermittedURL = true;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		//String contextPath = request.getContextPath();
	
		if (loginVO.getAdminId() != null  ) {
			LOGGER.debug("true");
			return true;
		} else {
			LOGGER.debug("loginFail Pre");
			//if (!request.getHeader("AJAX").equals("true")){
			if (!isPermittedURL){
				ModelAndView modelAndView = new ModelAndView("redirect:/backoffice/login.do");
				throw new ModelAndViewDefiningException(modelAndView);
				//return false;
			}else {
				//
				return true;
			}
			
				
		}
	}
	@Override
	public void postHandle(HttpServletRequest request,  HttpServletResponse response, Object handler, ModelAndView modeAndView) throws Exception {
 
		//WebLog webLog = new WebLog();
		String reqURL = request.getRequestURI();
		String uniqId = "";
 
    	   
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
    	if(isAuthenticated.booleanValue()) {
    		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			uniqId = user.getAdminId();
			
    	}else {
    		LOGGER.debug("=================================isAuthenticated:" + isAuthenticated);
    	}
    	LOGGER.debug("reqURL:" + reqURL);
    	//  response //쿠키 또는 해더 값 등을 변경 정리 할 수 있다.
    	//handler 객처  
    	LOGGER.debug("handler:" + handler.toString());
    	//결과값
    	//LOGGER.debug("modeAndView:" + modeAndView.toString());

 
		//webLogService.logInsertWebLog(webLog);
 
	}

}
