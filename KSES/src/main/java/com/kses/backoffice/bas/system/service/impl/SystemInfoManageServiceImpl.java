package com.kses.backoffice.bas.system.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bas.system.mapper.SystemInfoManageMapper;
import com.kses.backoffice.bas.system.service.SystemInfoManageService;
import com.kses.backoffice.bas.system.vo.SystemInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class SystemInfoManageServiceImpl extends EgovAbstractServiceImpl implements SystemInfoManageService {

	@Autowired
	private SystemInfoManageMapper systemMapper;

	@Override
	public SystemInfo selectSystemInfo(SystemInfo searchVO) throws Exception {
		return systemMapper.selectSystemInfo(searchVO);
	}

	@Override
	public int updateSystemInfo(SystemInfo vo) throws Exception {
		return systemMapper.updateSystemInfo(vo);
	}
}