package com.kses.backoffice.bas.code.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bas.code.vo.CmmnCode;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovCmmnCodeManageMapper {

    public List<Map<String, Object>> selectCmmnCodeListByPagination(@Param("params") Map<String, Object> params);
	
	public List<Map<String, Object>> selectCmmnCodeList();
	
	public Map<String, Object> selectCmmnCodeDetail(String codeId);
	
	public int insertCmmnCode(CmmnCode vo);
	
	public int updateCmmnCode(CmmnCode vo);
	
	public int deleteCmmnCode(String codeId);
	
	
}
