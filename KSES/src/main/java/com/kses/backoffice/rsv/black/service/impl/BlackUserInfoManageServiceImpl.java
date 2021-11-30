package com.kses.backoffice.rsv.black.service.impl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.rsv.black.mapper.BlackUserInfoManageMapper;
import com.kses.backoffice.rsv.black.service.BlackUserInfoManageService;
import com.kses.backoffice.rsv.black.vo.BlackUserInfo;

@Service
public class BlackUserInfoManageServiceImpl extends EgovAbstractServiceImpl implements BlackUserInfoManageService {
	@Autowired
	BlackUserInfoManageMapper blackUserMapper;
	
	@Override
	public List<Map<String, Object>> selectBlackUserInfoManageListByPagination(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return blackUserMapper.selectBlackUserInfoManageListByPagination(params);
	}
	
	@Override
	public int updateBlackUserInfoManage(BlackUserInfo vo) throws Exception {
		// TODO Auto-generated method stub
		return vo.getMode().equals("Ins") ? blackUserMapper.insertBlackUserInfo(vo) : blackUserMapper.updateBlackUserInfo(vo);
	}
}