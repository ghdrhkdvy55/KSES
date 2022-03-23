package com.kses.backoffice.bld.center.service.impl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bld.center.mapper.PreOpenInfoManageMapper;
import com.kses.backoffice.bld.center.service.PreOpenInfoManageService;
import com.kses.backoffice.bld.center.vo.PreOpenInfo;

@Service
public class PreOpenInfoManageServiceImpl extends EgovAbstractServiceImpl implements PreOpenInfoManageService {
	
	@Autowired
	PreOpenInfoManageMapper preOpenMapper;
	
	@Override
	public List<Map<String, Object>> selectPreOpenInfoList(String centerCd) throws Exception {
		return preOpenMapper.selectPreOpenInfoList(centerCd);
	}

	@Override
	public int updatePreOpenInfo(List<PreOpenInfo> preOpenInfoList) throws Exception {
		return preOpenMapper.updatePreOpenInfo(preOpenInfoList);
	}

	@Override
	public int copyPreOpenInfo(PreOpenInfo preOpenInfo) throws Exception {
		return preOpenMapper.copyPreOpenInfo(preOpenInfo);
	}
}