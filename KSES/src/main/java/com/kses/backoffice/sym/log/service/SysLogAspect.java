package com.kses.backoffice.sym.log.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.function.Predicate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.mybatis.spring.MyBatisSystemException;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestWrapper;
import org.springframework.stereotype.Component;
import org.springframework.util.StopWatch;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kses.backoffice.sym.log.vo.SysLog;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.let.utl.sim.service.EgovClntInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Aspect
@Component
public class SysLogAspect {
	public static final String KEY_ECODE = "ecode";
	
	@Autowired
	private EgovSysLogService sysLogService;
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	private static ObjectMapper objectMapper;
	static {
		objectMapper = new ObjectMapper();
		objectMapper.setSerializationInclusion(Include.NON_NULL);
	}
	private static <T> Predicate<T> not(Predicate<T> p) { return o -> !p.test(o); }
	
	/**
	 * 데이터 업데이트 관련 Controller 호출 시
	 * @param joinPoint
	 * @return
	 * @throws Throwable
	 */
	@Around("execution(public * egovframework.let..web.*Controller.update*(..)) || execution(public * com.kses..web.*Controller.update*(..))"
			+ " &&  !@target(com.kses.backoffice.sym.log.annotation.NoLogging)"
            + " &&  !@annotation(com.kses.backoffice.sym.log.annotation.NoLogging))")	
	public Object logUpdate(ProceedingJoinPoint joinPoint) throws Throwable {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		Class<?> clazz = joinPoint.getTarget().getClass();
		Object result = null; 
		Object sqlId  = null;
		
		StopWatch stopWatch = new StopWatch();
		try {
			log.info(" [" + clazz.getSimpleName() + "] ---------------------------------------------------------------------------------//");
			Arrays.stream(joinPoint.getArgs())
				.filter(not(LoginVO.class::isInstance))
				.filter(not(HttpSession.class::isInstance))
				.filter(not(HttpServletRequest.class::isInstance))
				.filter(not(SecurityContextHolderAwareRequestWrapper.class::isInstance))
				.filter(not(BeanPropertyBindingResult.class::isInstance))
				.forEach(arg -> {
					try {
						log.info(" (" + joinPoint.getSignature().getName() + ") Controller Parameters: " + objectMapper.writeValueAsString(arg));
					} catch (JsonProcessingException e) {
						log.info(" (" + joinPoint.getSignature().getName() + ") Controller Parameters: " + arg);
					}
			});
			
			stopWatch.start();
			Object[] methodArgs = joinPoint.getArgs();
			if (methodArgs.length > 0){
				sqlId = methodArgs[0];
			}
			result = joinPoint.proceed();
			return result;
		} catch (Throwable e) {
			throw e;
		} finally {
			stopWatch.stop();
			if (result instanceof ModelAndView  && result != null) {
				ModelAndView mav = ((ModelAndView) result);
				if (!mav.getModel().isEmpty()) {
					log.info(" ["+ clazz.getSimpleName() +"] ---------------------------------------------------------------------------------//\n(" + joinPoint.getSignature().getName() + ") Controller Return: " + mav.getModel());
				}
			}
			
			final String processSeCode = ParamToJson.JsonKeyToString(sqlId,"mode").equals(Globals.SAVE_MODE_INSERT) 
					? Globals.SYSLOG_PROCESS_SE_CODE_INSERT : Globals.SYSLOG_PROCESS_SE_CODE_UPDATE;
			final String ipAddr = EgovClntInfo.getClntIP(request);
			final String processTime = Long.toString(stopWatch.getTotalTimeMillis());
			final String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
			// 시스템 로그 기록
			SysLog sysLog = new SysLog();
			sysLog.setErrorCode(HttpStatus.OK.value()+"");
			sysLog.setSrvcNm(clazz.getSimpleName());
			sysLog.setMethodNm(joinPoint.getSignature().getName());
			sysLog.setProcessSeCode(processSeCode);
			sysLog.setProcessTime(processTime);
//			sysLog.setSqlParam(ParamToJson.paramToJson(sqlId));
			sysLog.setRqesterIp(ipAddr);
			sysLog.setRqesterId(userId);
//			sysLogService.logInsertSysLog(sysLog);
		}
	}
	
	/**
	 * 데이터 조회 관련 Controller 호출 시
	 * @param joinPoint
	 * @return
	 * @throws Throwable
	 */
	@Around("execution(public * egovframework.let..web.*Controller.select*(..)) || execution(public * com.kses..web.*Controller.select*(..))"
			+ " && !@target(com.kses.backoffice.sym.log.annotation.NoLogging)"
            + " && !@annotation(com.kses.backoffice.sym.log.annotation.NoLogging))")	
	public Object logSelect(ProceedingJoinPoint joinPoint) throws Throwable {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		Class<?> clazz = joinPoint.getTarget().getClass();
		Object result = null;
		Object sqlId  = null;
		
		StopWatch stopWatch = new StopWatch();
		try {
			log.info(" [" + clazz.getSimpleName() + "] ---------------------------------------------------------------------------------//");
			Arrays.stream(joinPoint.getArgs())
				.filter(not(LoginVO.class::isInstance))
				.filter(not(HttpSession.class::isInstance))
				.filter(not(HttpServletRequest.class::isInstance))
				.filter(not(SecurityContextHolderAwareRequestWrapper.class::isInstance))
				.filter(not(BeanPropertyBindingResult.class::isInstance))
				.forEach(arg -> {
					try {
						log.info(" (" + joinPoint.getSignature().getName() + ") Controller Parameters: " + objectMapper.writeValueAsString(arg));
					} catch (JsonProcessingException e) {
						log.info(" (" + joinPoint.getSignature().getName() + ") Controller Parameters: " + arg);
					}
				});
			
			stopWatch.start();
			Object[] methodArgs = joinPoint.getArgs();
			if (methodArgs.length > 0) {
				sqlId = methodArgs[0];
			}
			result = joinPoint.proceed();
			return result;
		} catch (Throwable e) {
		    throw e;
		} finally {
			stopWatch.stop();
			if (result instanceof ModelAndView  && result != null) {
				ModelAndView mav = ((ModelAndView) result);
				if (!mav.getModel().isEmpty()) {
					log.info(" ["+ clazz.getSimpleName() +"] ---------------------------------------------------------------------------------//\n(" + joinPoint.getSignature().getName() + ") Controller Return: " + mav.getModel());
				}
			}
			
			final String processSeCode = Globals.SYSLOG_PROCESS_SE_CODE_SELECT;
			final String ipAddr = EgovClntInfo.getClntIP(request);
			final String processTime = Long.toString(stopWatch.getTotalTimeMillis());
			final String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
			// 시스템 로그 기록
			SysLog sysLog = new SysLog();
			sysLog.setErrorCode(HttpStatus.OK.value()+"");
			sysLog.setSrvcNm(clazz.getSimpleName());
			sysLog.setMethodNm(joinPoint.getSignature().getName());
			sysLog.setProcessSeCode(processSeCode);
			sysLog.setProcessTime(processTime);
//			sysLog.setSqlParam(ParamToJson.paramToJson(sqlId));
			sysLog.setRqesterIp(ipAddr);
			sysLog.setRqesterId(userId);
//			sysLog.setMethodResult(ParamToJson.paramToJson(result));
//			sysLogService.logInsertSysLog(sysLog);
		}
	}
	
	/**
	 * 데이터 삭제 관련 Controller 호출 후 반환 시 
	 * @param joinPoint
	 * @param result
	 * @throws Throwable
	 */
	@Around("execution(public * egovframework.let..web.*Controller.delete*(..)) || execution(public * com.kses..web.*Controller.delete*(..))"
			 + " && !@target(com.kses.backoffice.sym.log.annotation.NoLogging)"
	         + " && !@annotation(com.kses.backoffice.sym.log.annotation.NoLogging))")
	public Object logDelete(ProceedingJoinPoint joinPoint) throws Throwable {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		Class<?> clazz = joinPoint.getTarget().getClass();
		Object result = null;
		Object sqlId  = null;
		
		StopWatch stopWatch = new StopWatch();
		try {
			stopWatch.start();
			Object[] methodArgs = joinPoint.getArgs(); //, sqlArgs = null;
			if (methodArgs.length > 0){
				sqlId = methodArgs[0];
			}
			result = joinPoint.proceed();
			return result;
		} catch (Throwable e) {
			throw e;
		} finally {
			stopWatch.stop();
			if (result instanceof ModelAndView  && result != null) {
				ModelAndView mav = ((ModelAndView) result);
				if (!mav.getModel().isEmpty()) {
					log.info(" ["+ clazz.getSimpleName() +"] ---------------------------------------------------------------------------------//\n(" + joinPoint.getSignature().getName() + ") Controller Return: " + mav.getModel());
				}
			}
			
			final String processSeCode = Globals.SYSLOG_PROCESS_SE_CODE_DELETE;
			final String ipAddr = EgovClntInfo.getClntIP(request);
			final String processTime = Long.toString(stopWatch.getTotalTimeMillis());
			final String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
			// 시스템 로그 기록
			SysLog sysLog = new SysLog();
			sysLog.setErrorCode(HttpStatus.OK.value()+"");
			sysLog.setSrvcNm(clazz.getSimpleName());
			sysLog.setMethodNm(joinPoint.getSignature().getName());
			sysLog.setProcessSeCode(processSeCode);
			sysLog.setProcessTime(processTime);
//			sysLog.setSqlParam(ParamToJson.paramToJson(sqlId));
			sysLog.setRqesterIp(ipAddr);
			sysLog.setRqesterId(userId);
//			sysLogService.logInsertSysLog(sysLog);
		}
	}
	
	/**
	 * Contoller 호출 후 오류 발생 시 
	 * @param joinPoint
	 * @param error
	 * @throws Exception
	 */
	@AfterThrowing(pointcut = "execution( public * egovframework.let..web.*Controller.*(..)) or execution(* com.kses..web.*Controller.*(..))"
		     + " and !@target(com.kses.backoffice.sym.log.annotation.NoLogging)"
		     + " and !@annotation(com.kses.backoffice.sym.log.annotation.NoLogging))", throwing = "error")
	public void logUpdateThrow(JoinPoint joinPoint, Exception error) throws Exception  {
		Class<?> clazz = joinPoint.getTarget().getClass();
		if (error.getClass().equals(MyBatisSystemException.class) || error.getClass().getName().contains("org.springframework.jdbc")) {
			log.error(" ["+ clazz.getSimpleName() +"] ---------------------------------------------------------------------------------//\n(" + joinPoint.getSignature().getName() + ") Implement Throwable: " + error.getMessage());
		} else {
			log.error(" ["+ clazz.getSimpleName() +"] ---------------------------------------------------------------------------------//\n(" + joinPoint.getSignature().getName() + ") Implement Throwable: " + error);
		}
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
	
//  사용하지 않음	
//	@ExceptionHandler(value = Exception.class)
//	public Object handlerError(HttpServletRequest request, Exception e) {
//		ModelAndView mav = null;
//		if (request.getHeader("AJAX") != null && e.toString().equals("egovframework.com.cmm.exception.CustomerExcetion")) {
//			mav = new ModelAndView(Globals.JSONVIEW);
//			mav.addObject(Globals.STATUS, Globals.STATUS_FAIL);
//			mav.addObject(Globals.STATUS_MESSAGE, "자동 공격이 의심 됩니다.");
//		    return mav;
//		} else if (request.getHeader("AJAX") != null && !e.toString().equals("egovframework.com.cmm.exception.CustomerExcetion")) {
//			LOGGER.error("============================================");
//			LOGGER.error("error:" + e.toString());
//			mav = new ModelAndView(Globals.JSONVIEW);
//			mav.addObject(Globals.STATUS, Globals.STATUS_FAIL);
//			mav.addObject(Globals.STATUS_MESSAGE,  egovMessageSource.getMessage("fail.request.msg") );
//		    return mav;
//		} else if (request.getHeader("AJAX") == null && e.toString().equals("egovframework.com.cmm.exception.CustomerExcetion")) {
//		    mav = new ModelAndView("/cmm/error/duplication");
//			return mav;
//		} else {
//			LOGGER.error("============================================");
//			LOGGER.error("error:" + e.toString());
//			mav = new ModelAndView("/cmm/error/egovError");
//			return mav;
//		}
//	}
	
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
	
	@SuppressWarnings("unused")
	private void mapperSelect(ProceedingJoinPoint joinPoint) throws Throwable {
		log.debug("mapper--------------------------------------------------------------------------------------------------------------");
 		StopWatch stopWatch = new StopWatch();
 		//Object sqlid  = null;
		try {
			stopWatch.start();
			Object[] methodArgs = joinPoint.getArgs(); //, sqlArgs = null;
			log.debug("length:" + methodArgs.length);
			for (Object  methodArg : methodArgs){
				log.debug("methodArg:" + methodArg.toString());
			}
			stopWatch.stop();
			//return retValue;
		} catch (Throwable e) {
			throw e;
		}
	}
	
	@SuppressWarnings("unused")
	private Object logSql(ProceedingJoinPoint joinPoint) throws Throwable {
		log.debug("SqlSession----------------------------------------------------------------------------------------------------------");
		Object[] methodArgs = joinPoint.getArgs(), sqlArgs = null;
		Object retValue = joinPoint.proceed();
		String statement = null;
		String sqlid = methodArgs[0].toString();
		
		log.debug("sqlid:" + sqlid);
		log.debug("length:" + methodArgs.length);

		for (int i =1, n = methodArgs.length; i < n; i++){
			Object arg = methodArgs[i];
			
			log.debug("methodArgs:" + methodArgs[i].toString());
			
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
		log.debug("completedStatemane:" + completedStatemane);
		return retValue;
	}
	
}
