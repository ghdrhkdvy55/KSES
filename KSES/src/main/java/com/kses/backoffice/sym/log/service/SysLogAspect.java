package com.kses.backoffice.sym.log.service;


import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.mybatis.spring.MyBatisSystemException;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StopWatch;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.sym.log.vo.SysLog;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.exception.CustomerExcetion;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.let.utl.sim.service.EgovClntInfo;




@Aspect
@Component
@ControllerAdvice
public class SysLogAspect    {
	
	@Autowired
	private EgovSysLogService sysLogService;
 
    
	private static final Logger LOGGER = LoggerFactory.getLogger(SysLogAspect.class);
	public static final String KEY_ECODE = "ecode";
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	
	public Object logSql(ProceedingJoinPoint joinPoint) throws Throwable {
		LOGGER.debug("SqlSession----------------------------------------------------------------------------------------------------------");
		Object[] methodArgs = joinPoint.getArgs(), sqlArgs = null;
		Object retValue = joinPoint.proceed();
		String statement = null;
		String sqlid = methodArgs[0].toString();
		
		
		LOGGER.debug("sqlid:" + sqlid);
		LOGGER.debug("length:" + methodArgs.length);

		for (int i =1, n = methodArgs.length; i < n; i++){
			Object arg = methodArgs[i];
			
			LOGGER.debug("methodArgs:" + methodArgs[i].toString());
			
			if (arg instanceof HashMap){
				@SuppressWarnings("unchecked")
				Map<String, Object> map = (Map<String, Object>)arg;
				
				statement = ((SqlSessionTemplate)joinPoint.getTarget()).getConfiguration().getMappedStatement(sqlid).getBoundSql(map).getSql();
				
				sqlArgs = new Object[map.size()];
				Iterator<String> itr = map.keySet().iterator();
				
				int j = 0;
				while(itr.hasNext()){
					sqlArgs[j++] = map.get(itr.next());
				}
				
			}
			break;
		}
		String completedStatemane = (sqlArgs == null ? statement:fillParameters(statement, sqlArgs));
		LOGGER.debug("completedStatemane:" + completedStatemane);
		return retValue;
	}
	
	/**
	 * 시스템 로그정보를 생성한다.
	 * sevice Class의 update로 시작되는 Method
	 *
	 * @param ProceedingJoinPoint
	 * @return Object
	 * @throws Exception
	 */
	
	//중복 행위 방지를 위해 작업 
	/*@Before("execution( public * egovframework.let..web.Controller.*Update(..))  "
			 + " or execution( public * egovframework.let..web.Controller.*Update(..)) "
		     + " or execution(public * aten.com.backoffice..web.*Controller.*Update(..)) " 
		     + " or execution(public * aten.com.backoffice..web.*Controller.*Delete(..)) " 
		     + " and  !@target(aten.com.backoffice.sym.log.annotation.NoLogging) "
		     + " and  !@annotation(aten.com.backoffice.sym.log.annotation.NoLogging) )")*/
	/*@Before("execution( public * egovframework.let..impl.*Impl.update*(..))  "
				 + " or execution(* aten.com.backoffice..impl.*Impl.update*(..)) "
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
			//throw new CustomerExcetion();
			if (dupCnt > 0){
				LOGGER.debug("3번 중복 행위 함");
				//return "redirect:/";
				throw new CustomerExcetion();
			}
		}
		
	}*/

	@Around("execution(public * egovframework.let..impl.*Impl.update*(..)) "
            + " || execution(public * com.kses..impl.*Impl.update*(..))   "
			+ " &&  !@target(com.kses.backoffice.sym.log.annotation.NoLogging) "
            + " &&  !@annotation(com.kses.backoffice.sym.log.annotation.NoLogging) )" )	
	public Object logUpdate(ProceedingJoinPoint  joinPoint) throws Throwable {
 
		SysLog sysLog = new SysLog();
 		Object sqlid  = null; 		
 		StopWatch stopWatch = new StopWatch();
 		 
		
		try {
			stopWatch.start();
			Object[] methodArgs = joinPoint.getArgs(); //, sqlArgs = null;
			if (methodArgs.length > 0){
				sqlid = methodArgs[0];
			}
			Object retValue = joinPoint.proceed();
			return retValue; 
		} catch (Throwable e) {
			throw e;
		} finally {
			stopWatch.stop();
			//paramToJson 나중에 수정하기 
			
			sysLog.setSqlParam(ParamToJson.paramToJson(sqlid));
			String processSeCode = ParamToJson.JsonKeyToString(sqlid,"mode").equals("Ins") ? "I" : "U"; 
			String className = joinPoint.getTarget().getClass().getName(); 
			String methodName =
			joinPoint.getSignature().getName(); 
			String processTime = Long.toString(stopWatch.getTotalTimeMillis()); 
			String uniqId = ""; 
			String ip = ""; 
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(isAuthenticated.booleanValue()) { 
				 LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser(); 
				 uniqId = user.getAdminId();
				 ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
			     HttpServletRequest request = attr.getRequest();
				 ip = EgovClntInfo.getClntIP(request);
			} 
			sysLog.setErrorCode("200"); 
			sysLog.setSrvcNm(className);
			sysLog.setMethodNm(methodName); 
			sysLog.setProcessSeCode(processSeCode);
			sysLog.setProcessTime(processTime); 
			sysLog.setRqesterId(uniqId);
			sysLog.setRqesterIp(ip); 
			sysLog.setMethodResult("");
			
			sysLog.setSearchIp(ip); 
			sysLog.setSearchId(uniqId); 
			sysLog.setFirstIndex(0);
			sysLog.setRecordCountPerPage(20);
			
			sysLogService.logInsertSysLog(sysLog);
			 
		
 
		}
 
	}
	@Around("execution(public * egovframework.let..impl.*Impl.select*(..)) "
            + " || execution(public * com.kses..impl.*Impl.select*(..))   "
			+ " &&  !@target(com.kses.backoffice.sym.log.annotation.NoLogging) "
            + " &&  !@annotation(com.kses.backoffice.sym.log.annotation.NoLogging) )" )	
	public Object logSelect(ProceedingJoinPoint  joinPoint) throws Throwable {
	
		SysLog sysLog = new SysLog();
		Object sqlid  = null; 		
		StopWatch stopWatch = new StopWatch();
		
		
		try {
			stopWatch.start();
			Object[] methodArgs = joinPoint.getArgs(); //, sqlArgs = null;
			if (methodArgs.length > 0){
			sqlid = methodArgs[0];
		}
			Object retValue = joinPoint.proceed();
			return retValue; 
		} catch (Throwable e) {
		    throw e;
		} finally {
			stopWatch.stop();
			//paramToJson 나중에 수정하기 
			
			sysLog.setSqlParam(ParamToJson.paramToJson(sqlid));
			String processSeCode = "S"; 
			String className = joinPoint.getTarget().getClass().getName(); 
			String methodName =
			joinPoint.getSignature().getName(); 
			String processTime = Long.toString(stopWatch.getTotalTimeMillis()); 
			String uniqId = ""; 
			String ip = ""; 
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(isAuthenticated.booleanValue()) { 
				 LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser(); 
				 uniqId = user.getAdminId();
				 ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
				 HttpServletRequest request = attr.getRequest();
				 ip = EgovClntInfo.getClntIP(request);
			} 
			sysLog.setErrorCode("200"); 
			sysLog.setSrvcNm(className);
			sysLog.setMethodNm(methodName); 
			sysLog.setProcessSeCode(processSeCode);
			sysLog.setProcessTime(processTime); 
			sysLog.setRqesterId(uniqId);
			sysLog.setRqesterIp(ip); 
			sysLog.setMethodResult("");
			
			sysLog.setSearchIp(ip); 
			sysLog.setSearchId(uniqId); 
			sysLog.setFirstIndex(0);
			sysLog.setRecordCountPerPage(20);
			sysLogService.logInsertSysLog(sysLog);
		
		
		
		}
	
	}
	/**
	 * 시스템 로그정보를 생성한다.
	 * sevice Class의 delete로 시작되는 Method
	 *
	 * @param ProceedingJoinPoint
	 * @return Object
	 * @throws Exception
	 */
	
	
	public void MapperSelect(ProceedingJoinPoint joinPoint) throws Throwable {
		LOGGER.debug("mapper--------------------------------------------------------------------------------------------------------------");
 		StopWatch stopWatch = new StopWatch();
 		//Object sqlid  = null;
		try {
			stopWatch.start();
			Object[] methodArgs = joinPoint.getArgs(); //, sqlArgs = null;
			LOGGER.debug("length:" + methodArgs.length);
			for (Object  methodArg : methodArgs){
				LOGGER.debug("methodArg:" + methodArg.toString());
			}
			stopWatch.stop();
			//return retValue;
		} catch (Throwable e) {
			throw e;
		} finally {
			
		
		}
		
	}
	/**
	 * 시스템 로그정보를 생성한다.
	 * sevice Class의 select로 시작되는 Method
	 *
	 * @param ProceedingJoinPoint
	 * @return Object
	 * @throws Exception
	 */
	@AfterReturning(pointcut = "execution(public * egovframework.let..impl.*Impl.delete*(..)) "
		                 + " || execution(public * com.kses..impl.*Impl.delete*(..))   "
						 + " &&  !@target(com.kses.backoffice.sym.log.annotation.NoLogging) "
			             + " &&  !@annotation(com.kses.backoffice.sym.log.annotation.NoLogging) )", returning = "result" )
	public void logSelect(JoinPoint joinPoint, Object result) throws Throwable {
		StopWatch stopWatch = new StopWatch();
 		SysLog sysLog = new SysLog();
 		Object sqlid  = null;
		try {
			stopWatch.start();
			Object[] methodArgs = joinPoint.getArgs(); //, sqlArgs = null;
			if (methodArgs.length > 0){
				sqlid = methodArgs[0];
			}
			stopWatch.stop();
		} catch (Throwable e) {
			throw e;
		} finally {
			
			sysLog.setSqlParam(ParamToJson.paramToJson(sqlid));
			sysLog.setMethodResult(ParamToJson.paramToJson(result) );
			
			if (result instanceof ModelAndView  && result != null) {
				ModelAndView mav = ((ModelAndView) result);
				if (!mav.getModel().isEmpty()) {
					LOGGER.info(" ( @AfterReturning 2 " + joinPoint.getSignature().getName() + ") Controller Return: " + mav.getModel());
				}
				if (mav.getModel().get(SysLogAspect.KEY_ECODE) == null) {
					mav.addObject(SysLogAspect.KEY_ECODE, 0);
				}
			}
			
			String className = joinPoint.getTarget().getClass().getName();
			String methodName = joinPoint.getSignature().getName();
			
			String processSeCode = "D";
			String processTime = Long.toString(stopWatch.getTotalTimeMillis());
			String uniqId = "";
			String ip = "";
 
			
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(isAuthenticated.booleanValue()) { 
				 LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser(); 
				 uniqId = user.getAdminId();
				 ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
				 HttpServletRequest request = attr.getRequest();
				 ip = EgovClntInfo.getClntIP(request);
			} 
			sysLog.setErrorCode("200"); 
			sysLog.setSrvcNm(className);
			sysLog.setMethodNm(methodName); 
			sysLog.setProcessSeCode(processSeCode);
			sysLog.setProcessTime(processTime); 
			sysLog.setRqesterId(uniqId);
			sysLog.setRqesterIp(ip); 
			sysLog.setMethodResult("");
			
			sysLog.setSearchIp(ip); 
			sysLog.setSearchId(uniqId); 
			sysLog.setFirstIndex(0);
			sysLog.setRecordCountPerPage(20);
			sysLogService.logInsertSysLog(sysLog);
 
		}
 
	}
	
	
	@AfterThrowing(pointcut = "execution( public * egovframework.let..impl.*Impl.update*(..))  "
						     + " or execution(* com.kses.*Controller.*(..)) " 
						     + " and  !@target(com.kses.backoffice.sym.log.annotation.NoLogging) "
						     + " and  !@annotation(com.kses.backoffice.sym.log.annotation.NoLogging) )", throwing = "error")
	public void logUpdateThrow(JoinPoint joinPoint, Exception error) throws Exception  {
		if (error.getClass().equals(MyBatisSystemException.class) 
			|| error.getClass().getName().contains("org.springframework.jdbc")) {
		    LOGGER.error(" (" + joinPoint.getSignature().getName() + ") Implement Throwable: " + error.getMessage());
		} else {
		   LOGGER.error(" (" + joinPoint.getSignature().getName() + ") Implement Throwable: " + error);
		}
	}
	@ExceptionHandler(value = Exception.class)
	public Object handlerError(HttpServletRequest request, Exception e) {
		ModelAndView mav = null;
		if (request.getHeader("AJAX") != null && e.toString().equals("egovframework.com.cmm.exception.CustomerExcetion")) {
			mav = new ModelAndView(Globals.JSONVIEW);
			mav.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			mav.addObject(Globals.STATUS_MESSAGE, "자동 공격이 의심 됩니다.");
		    return mav;
		} else if (request.getHeader("AJAX") != null && !e.toString().equals("egovframework.com.cmm.exception.CustomerExcetion")) {
			LOGGER.error("============================================");
			LOGGER.error("error:" + e.toString());
			mav = new ModelAndView(Globals.JSONVIEW);
			mav.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			mav.addObject(Globals.STATUS_MESSAGE,  egovMessageSource.getMessage("fail.request.msg") );
		    return mav;
		} else if (request.getHeader("AJAX") == null && e.toString().equals("egovframework.com.cmm.exception.CustomerExcetion")) {
		    mav = new ModelAndView("/cmm/error/duplication");
			return mav;
		} else {
			LOGGER.error("============================================");
			LOGGER.error("error:" + e.toString());
			mav = new ModelAndView("/cmm/error/egovError");
			return mav;
		}
	}
	
	private String fillParameters(String statement, Object[] sqlArgs){
		StringBuilder completedSqlBuilder = new StringBuilder(Math.round(statement.length() * 1.2f));
		int index, prevIndex = 0;
		
		for (Object arg: sqlArgs){
			index = statement.indexOf("?", prevIndex);
			if (index == -1)
				completedSqlBuilder.append(statement.substring(prevIndex, index));
			
			if(arg == null)
				completedSqlBuilder.append("NULL");
			else
				completedSqlBuilder.append(":"+ arg.toString());
			prevIndex = index + 1;
		}
		if (prevIndex != statement.length())
			completedSqlBuilder.append(statement.substring(prevIndex));
		
		return completedSqlBuilder.toString();
	}

	
}
