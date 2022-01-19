package com.kses.front.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.front.annotation.LoginUncheck;
import com.kses.front.annotation.ReferrerUncheck;
import com.kses.front.login.vo.UserLoginInfo;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;

public class FrontLoginInterceptor extends HandlerInterceptorAdapter{
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(FrontLoginInterceptor.class);
	
	@Override
	@NoLogging
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ModelAndViewDefiningException {
		LOGGER.debug("--------------------------FrontLoginInterceptor Controller Process End--------------------------");
		HandlerMethod handlerMethod = (HandlerMethod)handler;

		ReferrerUncheck referrerUncheck = handlerMethod.getMethodAnnotation(ReferrerUncheck.class);
		LoginUncheck loginUncheck = handlerMethod.getMethodAnnotation(LoginUncheck.class);
		
		ModelAndView model = new ModelAndView("/front/main/mainpage");
		HttpSession httpSession = request.getSession();

		// Referrer Check
		if(referrerUncheck == null && !this.isAjaxRequest(request)) {
			String referer = request.getHeader("referer");
			if(referer == null) {
				LOGGER.info("REFERER ERROR");
				model.addObject(Globals.STATUS, Globals.STATUS_REFERRERFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.referrer"));
				throw new ModelAndViewDefiningException(model);
			}
		} 
		
		// Login Check		
		if (loginUncheck == null) {
			if(request.getRequestedSessionId() != null && request.isRequestedSessionIdValid()) {
				UserLoginInfo userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
				//String compareUserId = request.getParameter("userId") != null ? request.getParameter("userId") : "";
				//if(userLoginInfo != null && userLoginInfo.getUserId().equals(compareUserId)) {
				if(userLoginInfo != null) {
					// Check Success
				} else {
					LOGGER.info("LOGIN INFO ERROR");
					model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));	
					throw new ModelAndViewDefiningException(model);
				}
			} else {
				model.addObject(Globals.STATUS, Globals.STATUS_SESSIONFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.session"));	
				throw new ModelAndViewDefiningException(model);
			}
		} 
		
		return true;
	}
	
	private boolean isAjaxRequest(HttpServletRequest request) {
		final String header = request.getHeader("AJAX");
		if(header != null && header.equals("true")) {
			return true;
		}
		return false;
 	}
}