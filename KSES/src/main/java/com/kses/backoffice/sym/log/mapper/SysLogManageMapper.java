package com.kses.backoffice.sym.log.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.sym.log.vo.SysLog;

import egovframework.rte.psl.dataaccess.mapper.Mapper;




@Mapper
public interface SysLogManageMapper {

	public List<Map<String, Object>> selectSysLogList( SysLog searchVO);
	
	public Map<String, Object> selectSysLogInfo(@Param("requstId") String requstId);
	
	public int logInsertSysLog(SysLog vo);
	
	public int logInsertSysLogSummary();
	
	public int logDeleteSysLogSummary();
	
}
