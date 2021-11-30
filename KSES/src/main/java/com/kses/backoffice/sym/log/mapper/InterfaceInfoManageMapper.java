package com.kses.backoffice.sym.log.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.sym.log.vo.InterfaceInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface InterfaceInfoManageMapper {

    public List<Map<String, Object>> selectInterfaceLogInfo (@Param("params") Map<String, Object> searchVO);
    
    public Map<String, Object> selectInterfaceDetail (String requstId);
	
	public int InterfaceInsertLoginLog(InterfaceInfo vo);
	
	public int InterfaceUpdateLoginLog(InterfaceInfo vo);
	
}
