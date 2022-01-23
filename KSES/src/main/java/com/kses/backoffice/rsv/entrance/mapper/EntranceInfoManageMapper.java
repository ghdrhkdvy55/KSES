package com.kses.backoffice.rsv.entrance.mapper;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EntranceInfoManageMapper {

	public List<Map<String, Object>> selectEnterRegistList(String resvSeq);
	
}
