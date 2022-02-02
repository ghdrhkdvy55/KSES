package com.kses.backoffice.sym.log.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.sym.log.vo.LoginLog;

public interface LoginLogService {

	public List selectLoginLogInfo(Map<String, Object> searchVO ) throws Exception;
	
	public Map<String, Object> selectLoginLogInfoDetail(String logId) throws Exception;
	
	public int logInsertLoginLog(LoginLog vo  ) throws Exception;
}
