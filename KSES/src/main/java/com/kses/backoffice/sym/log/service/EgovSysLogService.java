package com.kses.backoffice.sym.log.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.sym.log.vo.SysLog;

public interface EgovSysLogService {

	/**
	 * 시스템 로그정보를 생성한다.
	 *
	 * @param SysLog
	 */
	public void logInsertSysLog(SysLog sysLog) throws Exception;

	/**
	 * 시스템 로그정보를 요약한다.
	 *
	 * @param
	 */
	public void logInsertSysLogSummary() throws Exception;
	
	/**
	 * 시스템 로그정보 목록을 조회한다.
	 *
	 * @param SysLog
	 */
	public Map<?, ?> selectSysLogInfo(@Param("requestId") String requstId) throws Exception;

	/**
	 * 시스템 로그정보 목록을 조회한다.
	 *
	 * @param SysLog
	 */
	public List<Map<String, Object>> selectSysLogList(Map<String, Object> sysLog) throws Exception;
	
	
}
