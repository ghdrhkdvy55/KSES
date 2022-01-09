package egovframework.com.cmm.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import com.kses.backoffice.sym.log.service.LoginLogService;
import com.kses.backoffice.sym.log.vo.LoginLog;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovRequestWrapperForSecurity;
import egovframework.let.uat.uia.service.EgovLoginService;
import egovframework.rte.fdl.security.config.SecurityConfig;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class EgovAuthenticationFailureHandler implements AuthenticationFailureHandler {
	
	@Autowired
	EgovLoginService loginService;
	
	@Autowired
	LoginLogService loginLogService;
	
	@Autowired
	SecurityConfig securityConfig;
	
	/**
	 *  로그인 실패 Handler
	 *  - 전자정부시큐리티간소화는 다양하게 Exception 처리할 수 없음
	 *  case "org.springframework.security.authentication.BadCredentialsException": // 비밀번호 미인증 -> 간소화: 사용자가 없거나 비밀번호가 틀림
	 *  case "org.springframework.security.authentication.AccountExpiredException": // 계정 만료 -> 간소화: 지원하지 않음
	 *  case "org.springframework.security.authentication.CredentialsExpiredException": // 비밀번호 만료 -> 간소화: 지원하지 않음
	 *  case "org.springframework.security.authentication.DisabledException": // 계정 비활성화 -> 간소화: 지원하지 않음
	 *  case "org.springframework.security.authentication.LockedException": // 계정잠김 -> 간소화 지원하지 않음
	 */
	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {
		
		// TODO: 전자정부시큐리티간소화는 다양하게 Exception 처리할 수 없음, 로그인 실패 후 해당 로직에서 추가 상세 구현 필요.
		// 계정 비활성화: 관리자 관리에서 비활성화
		// 계정 잠김: 비밀번호 수회 틀릴 시 (예: 5회)
		final EgovRequestWrapperForSecurity egovRequestWrapperForSecurity = (EgovRequestWrapperForSecurity) request;
		final String adminId = egovRequestWrapperForSecurity.getUsername();
		
		String redirectUrl = "";
		int errorCode = 0;
		try {
			if (exception instanceof BadCredentialsException) {
				
				// 간소화 서비스는 대부분 해당 Exception만 발생하므로 분기 처리 위해 다시 조회.
				final LoginVO adminVO = loginService.findById(adminId);
				
				// 계정 없음
				if (adminVO == null) {
					errorCode = HttpStatus.NOT_FOUND.value();
					redirectUrl = securityConfig.getLoginFailureUrl();
				}
				// 계정 비활성화
				else if (adminVO != null && adminVO.getUseYn().equals("N")) {
					errorCode = HttpStatus.NOT_ACCEPTABLE.value();
					redirectUrl = securityConfig.getAccessDeniedUrl();
				}
				// 계정 잠김
				else if (adminVO != null && adminVO.getAdminLockyn().equals("Y")) {
					errorCode = HttpStatus.LOCKED.value();
					redirectUrl = securityConfig.getAccessDeniedUrl();
				}
				// 비밀번호 미인증
				else {
					errorCode = HttpStatus.UNAUTHORIZED.value();
					redirectUrl = securityConfig.getLoginFailureUrl();
				}
			}
			else {
				errorCode = HttpStatus.FORBIDDEN.value();
				redirectUrl = securityConfig.getAccessDeniedUrl();
			}
		} catch (Exception e) {
			log.error(e.getMessage());
			errorCode = HttpStatus.INTERNAL_SERVER_ERROR.value();
		} finally {
			try {
				LoginLog loginLog = new LoginLog();
				loginLog.setConnectMthd(Globals.LOGIN_CONNECT_MTHD_I);
				loginLog.setConnectId(adminId);
				loginLog.setConnectIp(egovRequestWrapperForSecurity.getClientIp());
				loginLog.setErrorOccrrAt("Y");
				loginLog.setErrorCode(String.valueOf(errorCode));
				loginLogService.logInsertLoginLog(loginLog);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		
		response.sendRedirect(redirectUrl);
	}
	
}
