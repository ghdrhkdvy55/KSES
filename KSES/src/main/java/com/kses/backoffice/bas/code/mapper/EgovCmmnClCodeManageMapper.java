package com.kses.backoffice.bas.code.mapper;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bas.code.vo.CmmnClCode;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovCmmnClCodeManageMapper {

    public List<Map<String, Object>> selectCmmnClCodeListByPagination(Map<String, Object> vo);
	
	public List<Map<String, Object>> selectCmmnClCodeList();
	
	public Map<String, Object> selectCmmnClCodeDetail(String clCode);
	
	public int insertCmmnClCode(CmmnClCode vo);
	
	public int updateCmmnClCode(CmmnClCode vo);
	
	public int deleteCmmnClCode(String clCode);
	
}
