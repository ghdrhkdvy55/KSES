package com.kses.backoffice.rsv.black.service.impl;

import egovframework.com.cmm.service.Globals;
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
		return blackUserMapper.selectBlackUserInfoManageListByPagination(params);
	}
	
	@Override
	public int updateBlackUserInfoManage(BlackUserInfo vo) throws Exception {
		return vo.getMode().equals(Globals.SAVE_MODE_INSERT) ? blackUserMapper.insertBlackUserInfo(vo) : blackUserMapper.updateBlackUserInfo(vo);
	}
}