package com.kses.backoffice.mng.employee.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.mng.employee.mapper.GradInfoManageMapper;
import com.kses.backoffice.mng.employee.service.GradInfoManageService;
import com.kses.backoffice.mng.employee.vo.GradInfo;

import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class GradInfoManageServiceImpl extends EgovAbstractServiceImpl implements GradInfoManageService {

	@Autowired 
	private GradInfoManageMapper gradMapper;

	@Override
	public List<Map<String, Object>> selectGradInfoList(@Param("params") Map<String, Object> params) throws Exception {
		return gradMapper.selectGradInfoList(params);
	}
	
	@Override
	public List<GradInfo> selectGradInfoComboList() throws Exception {
		return gradMapper.selectGradInfoComboList();
	}
	
	@Override
	public Map<String, Object> selectGradDetailInfo(String gradCode) throws Exception {
		return gradMapper.selectGradDetailInfo(gradCode);
	}


	@Override
	public int updateGradInfo(GradInfo gradInfo) throws Exception {
		return gradInfo.getMode().equals(Globals.SAVE_MODE_INSERT) ?  gradMapper.insertGradInfo(gradInfo) :  gradMapper.updateGradInfo(gradInfo);
	}

}