package com.kses.backoffice.sts.error.web;

import java.io.StringWriter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

import com.kses.backoffice.sym.log.service.EgovSysLogService;
import com.kses.backoffice.sym.log.vo.SysLog;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CustomExceptionResolver extends SimpleMappingExceptionResolver {

	private static final Logger LOGGER = LoggerFactory.getLogger(CustomExceptionResolver.class);	 
	
	private Integer defaultStatusCode;

	@Autowired
	private EgovSysLogService sysLogService;
	
	private String exceptionAttribute = DEFAULT_EXCEPTION_ATTRIBUTE;
	
	 @Override
	 public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
		 if (shouldApplyTo(request, handler)) {
				// Log exception, both at debug log level and at warn level, if desired.
				if (LOGGER.isDebugEnabled()) {
					LOGGER.debug("Resolving exception from handler [" + handler + "]: " + ex);
				}
				logException(ex, request);
				prepareResponse(ex, response);
				return doResolveException(request, response, handler, ex);
		 }
		 else {
			 LOGGER.debug("==================================================");
				return null;
		 }
	     //return super.resolveException(request, response, handler, ex);
	 }
	 //ajax Error 체크 하기
	 @Override
	 protected ModelAndView doResolveException( HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
			 // Log exception, both at debug log level and at warn level, if desired.
		     SysLog sysLog = new SysLog();
		     StringWriter sw = new StringWriter(); 
		     
		     sysLog.setMethodResult(sw.toString());
			 if (LOGGER.isDebugEnabled()) {
				 LOGGER.debug("ajax 에러 인지 체크: " + request.getHeader("AJAX"));
				 LOGGER.debug("customer Resolving exception from handler [" + handler + "]: " + ex);
			 }
			 /*
			  *  추후 확인 필요 
			  *
			 String processSeCode =  "E";
	    	 String className = handler.toString().substring( handler.toString().indexOf("ModelAndView") + 13, handler.toString().indexOf("("));
	    	 String methodName = className.substring(className.lastIndexOf(".") + 1, className.length());
	    	 String processTime = "0";
	    	 String uniqId = "";
	    	 String ip = "";
	         Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();	        
	         if(isAuthenticated.booleanValue()) {
	        		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    			uniqId = user.getAdminId();// .getUniqId();
	    			ip = user.getIp() == null ? "": user.getIp();
	         }
	        
	         
			 sysLog.setSrvcNm(className);
	    	 sysLog.setMethodNm(methodName);
	    	 sysLog.setProcessSeCode(processSeCode);
	    	 sysLog.setProcessTime(processTime);
	    	 sysLog.setRqesterId(uniqId);
	    	 sysLog.setRqesterIp(ip);
	    	 
	    	 sysLog.setSqlParam(ex.toString());
	    	
			 
			 */
			 String viewName = super.determineViewName(ex, request);
			 if (viewName != null) {
			      
				  Integer statusCode = super.determineStatusCode(request, viewName);
				  //statusCode 확인 하기 
				  if (statusCode != null) {
				      super.applyStatusCodeIfPossible(request, response, statusCode.intValue());
				  }
				  sysLog.setErrorCode(String.valueOf( statusCode.intValue()));
				  try {
					  LOGGER.debug("sysLog ERROR : " + statusCode.intValue());  
		    		//	sysLogService.logInsertSysLog(sysLog);
		    	  } catch (Exception e) {
		    		  LOGGER.error("sysLog ERROR : " + e.toString());
		    	  }
				  LOGGER.debug("getModelAndView 로 이동");
				  return getModelAndView(viewName, ex, request);
			 }
			 else {
				 LOGGER.debug("NULL로 확인");
			     return null;
			 }
	 }
	 
	@Override
	 protected ModelAndView getModelAndView(String viewName, Exception ex, HttpServletRequest request) {
		    
		   //return getModelAndView(viewName, ex);'
		    ModelAndView mv  = new ModelAndView(viewName);		  
		   LOGGER.error("exceptionAttribute:" + exceptionAttribute + ":" + viewName);
			try{
				if (this.exceptionAttribute != null) {
					LOGGER.error("step01");
					if (logger.isDebugEnabled()) {
						logger.debug("Exposing Exception as model attribute '" + this.exceptionAttribute + "'");
					}
					mv.addObject(this.exceptionAttribute, ex);
					mv.addObject("url", request.getRequestURL());
				}
			}catch(Exception ee){
				LOGGER.error("exceptionAttribute ERROR:" + ee.toString() );
			}
			return mv;
	}
	
}
