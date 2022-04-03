package com.kses.backoffice.bld.floor.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bld.floor.vo.FloorInfo;

public interface FloorInfoManageService {

	List<Map<String, Object>> selectFloorInfoList(Map<String, Object> params)throws Exception;
	
	List<Map<String, Object>> selectFloorInfoComboList (String centerCd)throws Exception;
	
	Map<String, Object> selectFloorInfoDetail(String floorCd)throws Exception;

	int updateFloorInfo(FloorInfo vo)throws Exception;
	
	int insertFloorSeatUpdate(Map<String, Object> params)throws Exception;
}
