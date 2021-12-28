package egovframework.com.cmm.exception;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.AbstractHandlerExceptionResolver;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.EgovWebUtil;
import egovframework.com.cmm.service.Globals;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class EgovExceptionResolver extends AbstractHandlerExceptionResolver {
	
	@Autowired
	protected EgovMessageSource egovMessageSource;

	@Override
	protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
		ModelAndView model = new ModelAndView();
		
		// AJAX 호출일 경우
		if (EgovWebUtil.isAjaxRequest(request)) {
			model = new ModelAndView(Globals.JSONVIEW);
			switch (ex.getClass().getSimpleName()) {
				case "EgovBizException":
					handleEgovBizException(model, ex);
					break;
				case "NotFoundException":
					handleNotFoundException(model, ex);
					break;
//				case "RuntimeException":
//				case "FdlException":
//				case "DataAccessException":
				default:
					handleException(model, ex);
					break;
			}
			
			log.error(ex.toString());
		}
		// Error Page 이동
		else {
			
		}
		
		return model;
	}
	
	private void handleEgovBizException(ModelAndView model, Exception ex) {
		model.setStatus(HttpStatus.CONFLICT);
		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
		model.addObject(Globals.STATUS_MESSAGE, ex.toString());
	}
	
	private void handleNotFoundException(ModelAndView model, Exception ex) {
		model.setStatus(HttpStatus.NOT_FOUND);
	}

	private void handleException(ModelAndView model, Exception ex) {
		model.setStatus(HttpStatus.INTERNAL_SERVER_ERROR);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.request"));
	}
}
