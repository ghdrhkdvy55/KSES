package com.kses.backoffice.bld.center.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bld.center.vo.CenterInfo;

public interface CenterInfoManageService {

	List<Map<String, Object>> selectCenterInfoList(Map<String, Object> SearchVO) throws Exception;
		
	List<Map<String, Object>> selectCenterInfoComboList() throws Exception;
	
	Map<String, Object> selectCenterInfoDetail(String centerCd) throws Exception;
	
	List<Map<String, Object>> selectResvCenterList() throws Exception;
	
	int updateCenterInfoManage(CenterInfo vo) throws Exception;
	
	int updateCenterFloorInfoManage (String floorInfo, String centerCode) throws Exception;
}