package com.kses.backoffice.bld.center.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.center.vo.CenterHolyInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface CenterHolyInfoManageMapper {
	public List<Map<String, Object>> selectCenterHolyInfoList(@Param("centerCd") String centerCd) throws Exception;
	
	public int updateCenterHolyInfo(CenterHolyInfo vo) throws Exception;
	
	public int insertCenterHolyInfo(CenterHolyInfo vo) throws Exception;
	
	public int copyCenterHolyInfo(@Param("params") Map<String, Object> params) throws Exception;
	
	public Map<String, Object> centerUpdateSelect(@Param("centerHolySeq") String centerHolySeq) throws Exception;
	
	public int deleteCenterHolyInfo(int centerHolySeq);
}
