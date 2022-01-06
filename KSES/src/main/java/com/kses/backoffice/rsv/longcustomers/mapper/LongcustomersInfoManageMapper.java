package com.kses.backoffice.rsv.longcustomers.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface LongcustomersInfoManageMapper {

	public List<Map<String, Object>> selectLongcustomerList (@Param("params") Map<String, Object> searchVO);
	
	public List<Map<String, Object>> selectLongcustomerResvList(String longResvSeq);
	
}
