package com.kses.backoffice.bld.center.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.center.vo.CenterHolyInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface CenterHolyInfoManageMapper {

	List<Map<String, Object>> selectCenterHolyInfoList(@Param("params") Map<String, Object> params) throws Exception;
	
	int updateCenterHolyInfo(CenterHolyInfo vo) throws Exception;

	int updateCenterHolyInfoList(@Param("centerHolyInfoList") List<CenterHolyInfo> centerHolyInfoList);
	
	int insertCenterHolyInfo(CenterHolyInfo vo) throws Exception;
	
	int copyCenterHolyInfo(@Param("params") Map<String, Object> params) throws Exception;
	
	Map<String, Object> centerUpdateSelect(@Param("centerHolySeq") String centerHolySeq) throws Exception;
	
	int deleteCenterHolyInfo(int centerHolySeq);
}
