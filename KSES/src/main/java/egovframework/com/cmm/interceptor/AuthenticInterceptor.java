package egovframework.com.cmm.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpStatus;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import egovframework.com.cmm.EgovWebUtil;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import lombok.extern.slf4j.Slf4j;

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
 *  Spring security 적용으로 사용하지 않음
 */
@Slf4j
public class AuthenticInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		if (EgovWebUtil.isAjaxRequest(request)) {
			String requestUrl = StringUtils.isEmpty(request.getQueryString()) ? request.getRequestURI() : request.getRequestURI() +"?"+ request.getQueryString();
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			log.info(" ("+ requestUrl+ ") ===============>> isAuthenticated: "+ isAuthenticated);
			if (!isAuthenticated) {
				response.sendError(HttpStatus.SC_FORBIDDEN);
			}
			return true;
		}
		
		return super.preHandle(request, response, handler);
	}
	
}
