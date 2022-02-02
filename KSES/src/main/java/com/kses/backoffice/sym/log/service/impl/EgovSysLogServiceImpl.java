package com.kses.backoffice.sym.log.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.sym.log.mapper.SysLogManageMapper;
import com.kses.backoffice.sym.log.service.EgovSysLogService;
import com.kses.backoffice.sym.log.vo.SysLog;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class EgovSysLogServiceImpl extends EgovAbstractServiceImpl implements EgovSysLogService {

	@Autowired
	private SysLogManageMapper syslogMapper;
	
	
    /** ID Generation */    
	@Resource(name="egovSysLogIdGnrService")
	private EgovIdGnrService egovSysLogIdGnrService;

	
	
	@NoLogging
	@Override
	public void logInsertSysLog(SysLog sysLog) throws Exception {
		if (!sysLog.getErrorCode().equals("909")){
			sysLog.setRequstId(egovSysLogIdGnrService.getNextStringId());
			syslogMapper.logInsertSysLog(sysLog);
		}
	}
	
	@NoLogging
	@Override
	public void logInsertSysLogSummary() throws Exception {
		
	}
	
	@NoLogging
	@Override
	public Map<String, Object> selectSysLogInfo(String requstId) throws Exception {
		return syslogMapper.selectSysLogInfo(requstId);
	}
	
	@NoLogging
	@Override
	public List<Map<String, Object>> selectSysLogList(Map<String, Object> sysLog)  throws Exception {
		//페이징 처리 다시 한번 생각하기 
		return syslogMapper.selectSysLogList(sysLog);
	}
	
}