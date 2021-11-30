package com.kses.backoffice.bld.center.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.center.vo.CenterInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
@Mapper
public interface CentertInfoManagerMapper {
	
	public List<Map<String, Object>> selectCenterInfoList(@Param("params") Map<String, Object> params);
		
	public List<Map<String, Object>> selectCenterInfoComboList();
	
	public Map<String, Object> selectCenterInfoManageDetail(String centerCode);
		
	public int insertCenterInfoManage(CenterInfo vo);
	
	public int updateCenterInfoManage(CenterInfo vo);
	
	public int updateCenterFloorInfoManage(@Param("floorInfo") String floorInfo, @Param("centerCode") String centerCode);
	
	public int deleteCenterInfoManage(String centerCode);
}
