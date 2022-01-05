package com.kses.backoffice.bas.holy.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bas.holy.mapper.HolyInfoManageMapper;
import com.kses.backoffice.bas.holy.service.HolyInfoService;
import com.kses.backoffice.bas.holy.vo.HolyInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class HolyInfoServiceImpl extends EgovAbstractServiceImpl implements HolyInfoService{
			
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
	public List<Map<String, Object>> selectHolyCenterList(Map<String, Object> searchVO) throws Exception {
		return holyMapper.selectHolyCenterList(searchVO);
	}
	
	@Override
	public int insertHolyInfo(HolyInfo holyInfo) throws Exception {
		return holyMapper.insertHolyInfo(holyInfo);
	}
	
	@Override
	public int updateHolyInfo(HolyInfo holyInfo) throws Exception {
		return holyMapper.updateHolyInfo(holyInfo) ;
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
			log.error("insertExcelHoly error:" + e.toString());
		}
		return result;
	}
}