package com.kses.backoffice.sym.log.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.sym.log.mapper.ScheduleInfoManageMapper;
import com.kses.backoffice.sym.log.service.ScheduleInfoManageService;
import com.kses.backoffice.sym.log.vo.ScheduleInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class ScheduleInfoManageServiceImpl extends EgovAbstractServiceImpl implements  ScheduleInfoManageService{

	@Autowired 
	private ScheduleInfoManageMapper scheduleMapper;

	@Override
	public List<Map<String, Object>> selectScheduleListInfo(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return scheduleMapper.selectScheduleListInfo(params);
	}

	@Override
	public int insertScheduleManage(String schName, String schResult, String schMessage) throws Exception {
		// TODO Auto-generated method stub
		
		ScheduleInfo info = new ScheduleInfo();
		
		info.setSchName(schName);
		info.setSchResult(schResult);
		info.setSchResultMessage(schMessage);
		
		return scheduleMapper.insertScheduleManage(info);
	}
}
