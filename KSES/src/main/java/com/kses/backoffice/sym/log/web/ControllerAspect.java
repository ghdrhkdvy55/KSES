package com.kses.backoffice.sym.log.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Before;
import org.mybatis.spring.MyBatisSystemException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.sym.log.service.EgovSysLogService;
import com.kses.backoffice.sym.log.service.ParamToJson;
import com.kses.backoffice.sym.log.vo.SysLog;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.exception.CustomerExcetion;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;



//@Aspect 
//@ControllerAdvice
public class ControllerAspect {

	private final Logger LOGGER = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private EgovSysLogService sysLogService;
	/**
	 * Controller 요청
	 * @param joinPoint
	 * @throws Exception
	 */
	@Before("execution( public * egovframework.let..web.Controller.*Update(..))  "
			     + " or execution(public * aten.com.backoffice..web.*Controller.*Update(..)) " 
			     + " or execution(public * aten.com.backoffice..web.*Controller.*Delete(..)) " 
			     + " and  !@target(aten.com.backoffice.sym.log.annotation.NoLogging) "
			     + " and  !@annotation(aten.com.backoffice.sym.log.annotation.NoLogging) )")
	public void before(JoinPoint joinPoint) throws Exception {
		Class<?> clazz = joinPoint.getTarget().getClass();
		LOGGER.info(" [" + clazz.getSimpleName() + "] ---------------------------------------------------------------------------------//");
		for (Object arg : joinPoint.getArgs()) {
			if (arg instanceof Map) {
				LOGGER.info(" (" + joinPoint.getSignature().getName() + ") Controller Parameters: " + arg);
			}
		}
		Object sqlid  = null; 		
		Object[] methodArgs = joinPoint.getArgs();
		if (methodArgs.length > 0){
			sqlid = methodArgs[0];
		}
		
		SysLog sysLog = new SysLog();
        String processSeCode =  ParamToJson.JsonKeyToString(sqlid, "mode").equals("Ins") ? "I" : "U";
		String className = joinPoint.getTarget().getClass().getName();
		String methodName = joinPoint.getSignature().getName();
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
		sysLog.setSearchIp(ip);
		sysLog.setSearchId(uniqId);
		sysLog.setFirstIndex(0);
		sysLog.setRecordCountPerPage(20);
		
		List<Map<String, Object>> sysLists = sysLogService.selectSysLogListCnt(sysLog);
		int dupCnt = 0;
		for(Map<String, Object> log : sysLists){
			if ( log.get("method_nm").toString().equals( methodName)){
				dupCnt +=1;					
			}
			LOGGER.debug("dupCnt"+ dupCnt + ":" +  log.get("method_nm").toString()+":" +methodName);
			if (dupCnt > 0){
				LOGGER.debug("3번 중복 행위 함");
				//return "redirect:/";
				throw new CustomerExcetion();
				
				//throw new CustomerExcetion("중복 애러 확인");
			}
		}
		
	}
	
	/**
	 * Controller 응답
	 * @param joinPoint
	 * @param result
	 */		
	@AfterReturning(pointcut = "execution(public * egovframework.let..web.Controller.*Update(..)) "
			+ " || execution(public * aten.com.backoffice..web.*Controller.*Update(..))   "
			+ " || execution(public * aten.com.backoffice..web.*Controller.*Delete(..)) "  
			+ " &&  !@target(aten.com.backoffice.sym.log.annotation.NoLogging) "
            + " &&  !@annotation(aten.com.backoffice.sym.log.annotation.NoLogging) )"  , returning = "result")
	public void afterReturning(JoinPoint joinPoint, Object result) throws Throwable{
		
		LOGGER.info(" [" + joinPoint.getTarget().getClass().getSimpleName() + "] ---------------------------------------------------------------------------------//");
		
		SysLog sysLog = new SysLog();
 		Object sqlid  = ""; 		
 		
		try {
			
			for (Object arg : joinPoint.getArgs()) {
				if (arg instanceof Map) {
					LOGGER.info(" (" + joinPoint.getSignature().getName() + ") Controller Parameters: " + arg);
					sqlid += arg.toString();
				}
			}
		} catch (Throwable e) {
			throw e;
		} finally {
			//paramToJson 나중에 수정하기 
			LOGGER.debug("sqlid----------------------------------------------------------------------------"+ sqlid);
			sysLog.setSqlParam(ParamToJson.paramToJson(sqlid));
			
			String processSeCode =  ParamToJson.JsonKeyToString(sqlid, "mode").equals("Ins") ? "I" : "U";
			String className = joinPoint.getTarget().getClass().getName();
			String methodName = joinPoint.getSignature().getName();
			String uniqId = "";
			String ip = "";
			
	        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();	        
	    	if(isAuthenticated.booleanValue()) {
	    		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
				uniqId = user.getAdminId();// .getUniqId();
				ip = user.getIp() == null ? "": user.getIp();
	    	}
	    	sysLog.setErrorCode("200");
			sysLog.setSrvcNm(className);
			sysLog.setMethodNm(methodName);
			sysLog.setProcessSeCode(processSeCode);
			sysLog.setProcessTime("0");
			sysLog.setRqesterId(uniqId);
			sysLog.setRqesterIp(ip);
			sysLog.setMethodResult("");
			
			
			sysLogService.logInsertSysLog(sysLog);
		
 
		}
	}
	
	/**
	 * Controller 응답 오류
	 * @param joinPoint
	 * @param error
	 */
	@AfterThrowing(pointcut = "execution(* spring.solum..*Controller.*(..))", throwing = "error")
	public void afterThrowing(JoinPoint joinPoint, Throwable error) {
		/*if (error instanceof BizException) {
			LOGGER.error(" (" + joinPoint.getSignature().getName() + ") Controller Throwable: " + ((BizException)error).getMessage());
		} else {*/
			if (error.getClass().equals(MyBatisSystemException.class) 
					|| error.getClass().getName().contains("org.springframework.jdbc")) {
				LOGGER.error(" (" + joinPoint.getSignature().getName() + ") Controller Throwable: " + error.getMessage());
			} else {
				LOGGER.error(" (" + joinPoint.getSignature().getName() + ") Controller Throwable: " + error);
			}
		/*}*/
		LOGGER.info(" [" + joinPoint.getTarget().getClass().getSimpleName() + "] ---------------------------------------------------------------------------------//");
	}
	
	/**
	 * ControllerAdvice Exception Handler
	 */
	@ExceptionHandler(value = Exception.class)
	public Object handlerError(HttpServletRequest request, Exception e) {
		ModelAndView mav = null;
		
		LOGGER.error("handlerError ==============================================================================");
		LOGGER.error("handlerError " + e.toString());
		
		
		if (request.getHeader("AJAX") != null && e.toString().equals("egovframework.com.cmm.exception.CustomerExcetion")) {
			mav = new ModelAndView(Globals.JSONVIEW);
			mav.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			mav.addObject(Globals.STATUS_MESSAGE, "자동 공격이 의심 됩니다.");
			return mav;
		} else if (request.getHeader("AJAX") != null && !e.toString().equals("egovframework.com.cmm.exception.CustomerExcetion")) {
			mav = new ModelAndView(Globals.JSONVIEW);
			mav.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			mav.addObject(Globals.STATUS_MESSAGE, "errors.system.500");
			return mav;
		} else if (request.getHeader("AJAX") == null && e.toString().equals("egovframework.com.cmm.exception.CustomerExcetion")) {
			
			mav = new ModelAndView("/cmm/error/duplication");
			return mav;
		} else {
			mav = new ModelAndView("/cmm/error/egovError");
			return mav;
		}
	}
}
