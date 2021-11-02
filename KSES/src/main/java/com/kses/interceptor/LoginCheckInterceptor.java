package com.kses.interceptor;
//package com.kses.interceptor;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//import org.apache.commons.lang.StringUtils;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.method.HandlerMethod;
//import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
//
//import egovframework.com.annotation.LoginUncheck;
//import egovframework.com.annotation.RefererUncheck;
//import egovframework.com.cmm.EgovMessageSource;
//import egovframework.com.cmm.util.SessionUtils;
//import egovframework.com.exception.BizException;
//
//public class LoginCheckInterceptor extends HandlerInterceptorAdapter {
//	private static final Logger logger = LoggerFactory.getLogger(LoginCheckInterceptor.class);
//	
//	@Autowired
//	EgovMessageSource messageSource;
//
//	@Override
//	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
//		String contextPath = request.getContextPath();
//		
//		if(handler instanceof HandlerMethod) {
//			HandlerMethod handlerMethod = (HandlerMethod)handler;
//			
//			LoginUncheck loginUncheck = handlerMethod.getMethodAnnotation(LoginUncheck.class);
//			RefererUncheck lefererUncheck = handlerMethod.getMethodAnnotation(RefererUncheck.class);
//			
//			logger.debug("Header Check. (getRemoteAddr=" + StringUtils.trimToNull(request.getRemoteAddr()) + ")");
//			logger.debug("Header Check. (getRequestUrl=" + StringUtils.trimToNull(request.getRequestURI().substring(contextPath.length())));
//			try {
//				// URL 접속정보
//				String referer = StringUtils.trimToNull(request.getHeader("Referer"));
//				
//				// 리퍼럴 어노테이션이 없고, ajax 통신이 아닌경우만 체크
//				if (lefererUncheck == null && !SessionUtils.isAjaxRequest(request)) {
//					logger.debug("Referer Check Start! (Referer=" + StringUtils.trimToNull(request.getHeader("Referer")) + ")");
//					logger.debug("Referer Check success! (URI=" + request.getRequestURI() + ")");
//					if (StringUtils.isEmpty(referer)) {
//						throw new BizException("ssg.login.service.error.referer");
//					}
//				}
//				
//				// loginUncheck 어노테이션 걸려있는 controller는 제외
//				if (loginUncheck == null) {
//					// 세션 체크
//					if (SessionUtils.isAdminLogin(request)) {
//						// 세션 타임아웃 체크
//						logger.debug("RequestedSessionId: " + request.getRequestedSessionId() + ", isRequestedSessionIdValid: "+ request.isRequestedSessionIdValid());
//						if (request.getRequestedSessionId() != null && !request.isRequestedSessionIdValid()) {
//							throw new BizException("ssg.login.service.error.notlogin");
//						}
//					} else {
//						throw new BizException("ssg.login.service.error.timeout");
//					}
//				} else {
//					// 세션 체크 안함
//				}
//			} catch (BizException be) {
//				logger.error(SessionUtils.setBizExceptionMessage(be.getCode(), request, messageSource));
//				if (SessionUtils.isAjaxRequest(request)) {
//					response.sendError(400);
//				} else {
//					request.getRequestDispatcher(contextPath+ "/cmm/error.jsp").forward(request, response);
//				}
//				return false;
//			} catch (Exception e) {
//				logger.error(e.getMessage());
//				return false;
//			}
//		}
//		
//		return true;
//	}
//
//	@Override
//	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
//		response.setHeader("Cache-Control", "no-store");
//		response.setHeader("Pragma", "no-cache");
//		response.setDateHeader("Expires", 0);
//		if (request.getProtocol().equals("HTTP/1.1")) {
//			response.setHeader("Cache-Control", "no-cache");
//		}
//		super.afterCompletion(request, response, handler, ex);
//	}
//	
//}
