package com.kses.backoffice.sym.log.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.sym.log.mapper.LoginLogMapper;
import com.kses.backoffice.sym.log.service.LoginLogService;
import com.kses.backoffice.sym.log.vo.LoginLog;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class LoginLogServiceImpl extends EgovAbstractServiceImpl implements LoginLogService{

	@Autowired
	private LoginLogMapper loginLogMapper;
	
    @Resource(name = "egovLoginLogIdGnrService")
    private EgovIdGnrService idgenService;
	
    @NoLogging
	@Override
	public int logInsertLoginLog(LoginLog loginLog) throws Exception {
    	loginLog.setLogId(idgenService.getNextStringId());
		return loginLogMapper.logInsertLoginLog(loginLog);
	}
    
	@Override
	public List<Map<String, Object>> selectLoginLogInfo(Map<String, Object> searchVO) throws Exception {
	    return loginLogMapper.selectLoginLogInfo(searchVO);
	}

	@Override
	public Map<String, Object> selectLoginLogInfoDetail(String logId) throws Exception {
		return loginLogMapper.selectLoginDetail(logId);
	}
	
}
