package com.kses.backoffice.rsv.entrance.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EntranceInfoManageMapper {

	public List<Map<String, Object>> selectEnterRegistList(String resvSeq);
	
	public List<Map<String, Object>> selectResvInfoEnterRegistList(@Param("params") Map<String, Object> params);
}
