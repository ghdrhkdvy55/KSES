package com.kses.backoffice.bld.center.service.impl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bld.center.mapper.NoshowInfoManageMapper;
import com.kses.backoffice.bld.center.service.NoshowInfoManageService;
import com.kses.backoffice.bld.center.vo.NoshowInfo;

@Service
public class NoshowInfoManageServiceImpl extends EgovAbstractServiceImpl implements NoshowInfoManageService {

	@Autowired
	NoshowInfoManageMapper noshowMapper;
	
	@Override
	public List<Map<String, Object>> selectNoshowInfoList(String centerCd) throws Exception {
		// TODO Auto-generated method stub
		return noshowMapper.selectNoshowInfoList(centerCd);
	}

	@Override
	public int updateNoshowInfo(List<NoshowInfo> noshowInfoList) throws Exception {
		// TODO Auto-generated method stub
		return noshowMapper.updateNoshowInfo(noshowInfoList);
	}

	@Override
	public int copyNoshowInfo(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return noshowMapper.copyNoshowInfo(params);
	}
}