package egovframework.com.cmm.annotation;



import java.util.Locale;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.Signature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.dao.DataAccessException;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;
import egovframework.com.cmm.exception.CustomerExcetion;
import egovframework.rte.fdl.cmmn.aspect.ExceptionTransfer;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.cmmn.exception.FdlException;
import egovframework.rte.fdl.cmmn.exception.manager.ExceptionHandlerService;

public class CustomerExceptionTransfer  extends ExceptionTransfer{

	private static final Logger LOGGER = LoggerFactory.getLogger(ExceptionTransfer.class);
	
	@Autowired
	private MessageSource messageSource;

	private ExceptionHandlerService[] exceptionHandlerServices;
	
	/**
	 * 디볼트로 패턴 매칭은 ANT 형태로 비교한다.
	 */
	private PathMatcher pm = new AntPathMatcher();
	
	@Override
	public void transfer(JoinPoint thisJoinPoint, Exception exception) throws Exception {
		LOGGER.debug("execute ExceptionTransfer.transfer  확인 ");
		
		Class<?> clazz = thisJoinPoint.getTarget().getClass();
		Signature signature = thisJoinPoint.getSignature();

		Locale locale = LocaleContextHolder.getLocale();
		
		
	
		//EgovBizException 이 발생시
		if (exception instanceof EgovBizException) {
			LOGGER.debug("Exception case :: EgovBizException ");

			EgovBizException be = (EgovBizException) exception;
			//wrapp 된 Exception 있는 경우 error 원인으로 출력해준다.
			if (be.getWrappedException() != null) {
				Throwable throwable = be.getWrappedException();
				getLog(clazz).error(be.getMessage(), throwable);
			} else {
				getLog(clazz).error(be.getMessage(), be.getCause());
			}

			// Exception Handler 에 발생된 Package 와 Exception 설정. (runtime 이 아닌 ExceptionHandlerService를 실행함)
			processHandling(clazz, signature.getName(), be, pm, exceptionHandlerServices);

			throw be;

			//RuntimeException 이 발생시 내부에서 DataAccessException 인 경우 는 별도록 throw 하고 있다.
		} else if (exception instanceof RuntimeException) {
			LOGGER.debug("RuntimeException case :: RuntimeException ");

			RuntimeException be = (RuntimeException) exception;
			getLog(clazz).error(be.getMessage(), be.getCause());

			// Exception Handler 에 발생된 Package 와 Exception 설정.
			processHandling(clazz, signature.getName(), exception, pm, exceptionHandlerServices);

			if (be instanceof DataAccessException) {
				LOGGER.debug("RuntimeException case :: DataAccessException ");
				DataAccessException sqlEx = (DataAccessException) be;
				throw sqlEx;
			}

			throw be;

			//실행환경 확장모듈에서 발생한 Exception (요청: 공통모듈) :: 후처리로직 실행하지 않음.
		} else if (exception instanceof FdlException) {
			LOGGER.debug("FdlException case :: FdlException ");

			FdlException fe = (FdlException) exception;
			getLog(clazz).error(fe.getMessage(), fe.getCause());

			throw fe;

		} else if (  exception instanceof  CustomerExcetion ){
			LOGGER.debug("CustomerExcetion case :: CustomerExcetion ");
			// 여기 부분 처리를 해야 정리됨
			
			throw processException(clazz, "fail.common.msg", new String[] {}, exception, locale);
			
		}else {
			//그외에 발생한 Exception 을  BaseException (메세지: fail.common.msg) 로  만들어 변경 던진다.
			//:: 후처리로직 실행하지 않음.
			LOGGER.debug("case :: Exception ");
			getLog(clazz).error(exception.getMessage(), exception.getCause());
			throw processException(clazz, "fail.common.msg", new String[] {}, exception, locale);
		}
	}
	/**
	 * 발생한 Exception 에 따라 후처리 로직이 실행할 수 있도록 연결하는 역할을 수행한다.
	 * 
	 * @param clazz Exception 발생 클래스
	 * @param methodName Exception 발생 메소드명
	 * @param exception 발생한 Exception
	 * @param pm 발생한 PathMatcher(default : AntPathMatcher)
	 * @param exceptionHandlerServices[] 등록되어 있는 ExceptionHandlerService 리스트
	 */
	@Override
	protected void processHandling(Class<?> clazz, 
			                                     String methodName, 
			                                     Exception exception, 
			                                     PathMatcher pm, 
			                                     ExceptionHandlerService[] exceptionHandlerServices) {
		LOGGER.error("processHandling");
		
		
		for (ExceptionHandlerService ehm : exceptionHandlerServices) {
			try {
				if (!ehm.hasReqExpMatcher()) {
					ehm.setReqExpMatcher(pm);
				}
				LOGGER.error("processHandling"+clazz.getCanonicalName() + "." + methodName + ":" +exception);
				ehm.setPackageName(clazz.getCanonicalName() + "." + methodName);
				ehm.run(exception);
			} catch (Exception e) {
				LOGGER.error("ExceptionHandlerService Error", e);
			}
		}
	}
	
}
