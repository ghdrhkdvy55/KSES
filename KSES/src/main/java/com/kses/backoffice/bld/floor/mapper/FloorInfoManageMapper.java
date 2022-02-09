package com.kses.backoffice.bld.floor.mapper;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.floor.vo.FloorInfo;

@Mapper
public interface FloorInfoManageMapper {

	public List<Map<String, Object>> selectFloorInfoList(@Param("params") Map<String, Object> params);
	
	public Map<String, Object> selectFloorInfoDetail(@Param("floorCd") String floorCd);
	
	public List<Map<String, Object>> selectFloorInfoComboList(@Param("centerCd") String centerCd);
	
	public int updateFloorInfo(FloorInfo vo);

	int updateFloorInfoList(@Param("floorInfoList") List<FloorInfo> floorInfoList);

}
