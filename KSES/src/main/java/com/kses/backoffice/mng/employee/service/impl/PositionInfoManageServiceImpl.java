package com.kses.backoffice.mng.employee.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.mng.employee.mapper.PositionInfoManageMapper;
import com.kses.backoffice.mng.employee.service.PositionInfoManageService;
import com.kses.backoffice.mng.employee.vo.PositionInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class PositionInfoManageServiceImpl extends EgovAbstractServiceImpl implements PositionInfoManageService {

	@Autowired 
	private PositionInfoManageMapper positionMapper;

	@Override
	public List<Map<String, Object>> selectPositionInfoList(@Param("params") Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return positionMapper.selectPositionInfoList(params);
	}

	@Override
	public List<PositionInfo> selectPositionInfoComboList() throws Exception {
		// TODO Auto-generated method stub
		return positionMapper.selectPositionInfoComboList();
	}
	
	@Override
	public Map<String, Object> selectPositionDetailInfo(String psitCd) throws Exception {
		// TODO Auto-generated method stub
		return positionMapper.selectPositionDetailInfo(psitCd);
	}

	@Override
	public int updateJikwInfo(PositionInfo positionInfo) throws Exception {
		// TODO Auto-generated method stub
		return positionInfo.getMode().equals("Ins") ?  positionMapper.insertPositionInfo(positionInfo) : positionMapper.updatePositionInfo(positionInfo) ;
	}
}