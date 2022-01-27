package com.kses.backoffice.bas.holy.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bas.holy.mapper.HolyInfoManageMapper;
import com.kses.backoffice.bas.holy.service.HolyInfoService;
import com.kses.backoffice.bas.holy.vo.HolyInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class HolyInfoServiceImpl extends EgovAbstractServiceImpl implements HolyInfoService{

	private static final Logger LOGGER = LoggerFactory.getLogger(HolyInfoServiceImpl.class);
			
	@Autowired
	private HolyInfoManageMapper holyMapper;

	@Override
	public List<Map<String, Object>> selectHolyInfoList(Map<String, Object> params) throws Exception {
		return holyMapper.selectHolyInfoList(params);
	}

	@Override
	public Map<String, Object> selectHolyInfoDetail(String holySeq) throws Exception {
		return holyMapper.selectHolyInfoDetail(holySeq);
	}
	
	@Override
	public int updateHolyInfo(HolyInfo vo) throws Exception {
		return vo.getMode().equals("Ins") ? holyMapper.insertHolyInfo(vo) : holyMapper.updateHolyInfo(vo) ;
	}
	
	@Override
	public int deleteHolyInfo(List<String> holyList) throws Exception {
		return holyMapper.deleteHolyInfo(holyList);
	}
	
	@Override
	public int holyInfoCenterApply(List<HolyInfo> holyInfoList) throws Exception {
		return holyMapper.holyInfoCenterApply(holyInfoList);
	}

	@Override
	public boolean insertExcelHoly(List<HolyInfo> holyInfoList) throws Exception {
		boolean result = false;
		try {
			holyMapper.insertExcelHoly(holyInfoList);
			result = true;
		}catch( Exception e) {
			LOGGER.error("insertExcelHoly error:" + e.toString());
		}
		return result;
	}
}