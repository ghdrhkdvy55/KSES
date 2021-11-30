package com.kses.backoffice.bas.system.mapper;

import com.kses.backoffice.bas.system.vo.SystemInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface SystemInfoManageMapper {
	
	public SystemInfo selectSystemInfo(SystemInfo searchVO) throws Exception;
	
	public int updateSystemInfo(SystemInfo vo) throws Exception;
}
