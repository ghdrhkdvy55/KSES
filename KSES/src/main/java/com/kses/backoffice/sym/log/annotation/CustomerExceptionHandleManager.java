package com.kses.backoffice.sym.log.annotation;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.rte.fdl.cmmn.exception.handler.ExceptionHandler;
import egovframework.rte.fdl.cmmn.exception.manager.DefaultExceptionHandleManager;

public class CustomerExceptionHandleManager extends DefaultExceptionHandleManager  {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CustomerExceptionHandleManager.class);

	@Override
	public boolean run(Exception exception) throws Exception {
		LOGGER.error("exception:" + exception.toString());
		
		// 매칭조건이 false 인 경우
		if (!enableMatcher()) {
			return false;
		}
		for (String pattern : patterns) {
			if (pm.match(pattern, thisPackageName)) {
				for (ExceptionHandler eh : handlers) {
					eh.occur(exception, getPackageName());
				}
				break;
			}
		}

		return true;
	}

}
