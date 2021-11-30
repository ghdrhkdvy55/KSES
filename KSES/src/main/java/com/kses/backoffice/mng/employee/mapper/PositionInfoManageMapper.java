package com.kses.backoffice.mng.employee.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.mng.employee.vo.PositionInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper
public interface PositionInfoManageMapper {
	public List<Map<String, Object>> selectPositionInfoList(@Param("params") Map<String, Object> params);
	
	public List<PositionInfo> selectPositionInfoComboList();
	
	public Map<String, Object> selectPositionDetailInfo(String jikwCode);
	
	public int insertPositionInfo(PositionInfo jikwInfo);
	
	public int updatePositionInfo(PositionInfo jikwInfo);
	
}