package com.kses.backoffice.bld.center.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.center.vo.PreOpenInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface PreOpenInfoManageMapper {
	public List<Map<String, Object>> selectPreOpenInfoList(@Param("centerCd") String centerCd) throws Exception;
	
	public int updatePreOpenInfo(@Param("preOpenInfoList") List<PreOpenInfo> preOpenInfoList) throws Exception;
	
	public int copyPreOpenInfo(PreOpenInfo preOpenInfo) throws Exception;
}
