package com.kses.backoffice.sym.log.service;


import javax.annotation.Resource;
import egovframework.com.cmm.LoginVO;
import com.kses.backoffice.sym.log.vo.LoginLog;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

public class LoginLogAspect {

	
	@Resource(name="LoginLogService")
	private LoginLogService loginLogService;

	/**
	 * 로그인 로그정보를 생성한다.
	 * EgovLoginController.actionMain Method
	 *
	 * @param
	 * @return void
	 * @throws Exception
	 */
	public void logLogin() throws Throwable {

		String uniqId = "";
		String ip = "";

		/* Authenticated  */
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
    	if(isAuthenticated.booleanValue()) {
			LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			uniqId = user.getAdminId();
			//uniqId = user.getId();
			ip = user.getIp();
    	}

    	LoginLog loginLog = new LoginLog();
    	loginLog.setConnectId(uniqId);
        loginLog.setConnectIp(ip);
        loginLog.setLoginMthd("I"); // 로그인:I, 로그아웃:O
        loginLog.setErrorOccrrAt("N");
        loginLog.setErrorCode("");
        loginLogService.logInsertLoginLog(loginLog);

	}

	/**
	 * 로그아웃 로그정보를 생성한다.
	 * EgovLoginController.actionLogout Method
	 *
	 * @param
	 * @return void
	 * @throws Exception
	 */
	public void logLogout() throws Throwable {

		String uniqId = "";
		String ip = "";

		/* Authenticated  */
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
    	if(isAuthenticated.booleanValue()) {
			LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			uniqId = user.getAdminId();
			ip = user.getIp();
    	}

    	LoginLog loginLog = new LoginLog();
    	loginLog.setConnectId(uniqId);
        loginLog.setConnectIp(ip);
        loginLog.setLoginMthd("O"); // 로그인:I, 로그아웃:O
        loginLog.setErrorOccrrAt("N");
        loginLog.setErrorCode("");
        loginLogService.logInsertLoginLog(loginLog);
	}
}
