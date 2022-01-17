
package com.kses.backoffice.bld.partclass.mapper;

import java.util.List; 
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.partclass.vo.PartClassInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper 
public interface PartClassInfoManageMapper { 
	  
	public List<Map<String, Object>> selectPartClassList (@Param("params") Map<String, Object> searchVO);
	
	public List<Map<String, Object>> selectPartClassComboList (@Param("centerCd") String centerCd);
	
	public int insertPartClassInfo(PartClassInfo partClassInfo);
	
	public int updatePartClassInfo(PartClassInfo partClassInfo);
	
	public int deletePartClassInfo(String partSeq); 

}
 