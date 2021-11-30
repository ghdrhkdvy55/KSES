package com.kses.backoffice.bas.code.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.kses.backoffice.bas.code.vo.CmmnDetailCode;
import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper
public interface EgovCmmnDetailCodeManageMapper {

    public List<Map<String, Object>> selectCmmnDetailCodeListByPagination(String codeId);
	
	public List<Map<String, Object>> selectCmmnDetailCombo (String code);
	
	public List<Map<String, Object>> selectCmmnDetailComboLamp (String code);
	
	public List<CmmnDetailCode> selectCmmnDetailComboEtc(@Param("params") Map<String, Object> params);
	
	public CmmnDetailCode selectCmmnDetailCodeDetail(String code);
	
	public Map<String, Object> selectCmmnDetail(String code);
	
	public List<Map<String, Object>> selectComboSwcCon();
		
	public int insertCmmnDetailCode(CmmnDetailCode vo);
	               
	public int updateCmmnDetailCode(CmmnDetailCode vo);
	
	public int deleteCmmnDetailCode(String code);
	
	public int deleteCmmnDetailCodeId(String value);
	
	public List<Map<String, Object>> selectCmmnDetailResTypeCombo (Map<String, Object> vo);

}
