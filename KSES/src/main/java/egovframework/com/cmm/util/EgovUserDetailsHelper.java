package egovframework.com.cmm.util;

import java.util.List;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovUserDetailsService;

/**
 * EgovUserDetails Helper 클래스
 * 
 * @author sjyoon
 * @since 2009.06.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    -------------    ----------------------
 *   2009.03.10  sjyoon    최초 생성
 *   2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성
 *
 * </pre>
 */
public class EgovUserDetailsHelper {
	
	static EgovUserDetailsService egovUserDetailsService;
	
	public EgovUserDetailsService getEgovUserDetailsService() {
		return egovUserDetailsService;
	}

	public void setEgovUserDetailsService(EgovUserDetailsService egovUserDetailsService) {
		EgovUserDetailsHelper.egovUserDetailsService = egovUserDetailsService;
	}
	
	/**
	 * 인증된 사용자객체를 VO형식으로 가져온다.
	 */
	public static Object getAuthenticatedUser() {
		return egovUserDetailsService.getAuthenticatedUser();
	}

	/**
	 * 인증된 사용자의 권한 정보를 가져온다.
	 */
	public static List<String> getAuthorities() {
		return egovUserDetailsService.getAuthorities();
	}

	/**
	 * 인증된 사용자 여부를 체크한다.
	 */
	public static Boolean isAuthenticated() {
		return egovUserDetailsService.isAuthenticated();
	}
	
	/**
	 * 로그인 사용자 아이디를 가져온다.
	 * @return
	 */
	public static String getAuthenticatedUserId() {
		if (egovUserDetailsService.isAuthenticated()) {
			LoginVO loginVO = (LoginVO) egovUserDetailsService.getAuthenticatedUser();
			return loginVO.getAdminId();
		}
		else {
			return null;
		}
	}
}
