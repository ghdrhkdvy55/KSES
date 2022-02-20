package com.kses.backoffice.bld.floor.service;

import com.kses.backoffice.bld.floor.vo.FloorPartInfo;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface FloorPartInfoManageService {

    List<Map<String, Object>> selectFloorPartInfoList(@Param("params") Map<String, Object> params)throws Exception;
	
	List<Map<String, Object>> selectFloorPartInfoManageCombo (String floorCd)throws Exception;
	
	Map<String, Object> selectFloorPartInfoDetail(String partSeq)throws Exception;
	
	List<Map<String, Object>> selectResvPartList(Map<String, Object> params) throws Exception;

	int insertFloorPartInfoManage(FloorPartInfo floorPartInfo)throws Exception;
	
	int updateFloorPartInfoManage(FloorPartInfo floorPartInfo)throws Exception;
	
	int updateFloorPartInfPositionInfo(List<FloorPartInfo> floorPartInfo)throws Exception;
}
