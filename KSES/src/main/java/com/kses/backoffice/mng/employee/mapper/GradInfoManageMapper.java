package com.kses.backoffice.mng.employee.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.mng.employee.vo.GradInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface GradInfoManageMapper {
	public List<Map<String, Object>> selectGradInfoList(@Param("params") Map<String, Object> params);
	
	public List<GradInfo> selectGradInfoComboList();
	
	public Map<String, Object> selectGradDetailInfo(String gradCode);
	
	public int insertGradInfo(GradInfo gradInfo);
	
	public int updateGradInfo(GradInfo gradInfo);
	
}