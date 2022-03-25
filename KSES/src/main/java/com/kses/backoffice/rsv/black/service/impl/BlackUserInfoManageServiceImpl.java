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
	public List<Map<String, Object>> selectBlackUserInfoList(Map<String, Object> params) throws Exception {
		return blackUserMapper.selectBlackUserInfoList(params);
	}
	
	@Override
	public int insertBlackUserInfo(BlackUserInfo vo) throws Exception {
		return blackUserMapper.insertBlackUserInfo(vo);
	}
	
	@Override
	public int updateBlackUserInfo(BlackUserInfo vo) throws Exception {
		return blackUserMapper.updateBlackUserInfo(vo);
	}
	
	@Override
	public int deleteBlackUserInfo(String blklstSeq) throws Exception {
		return blackUserMapper.deleteBlackUserInfo(blklstSeq);
	}
}