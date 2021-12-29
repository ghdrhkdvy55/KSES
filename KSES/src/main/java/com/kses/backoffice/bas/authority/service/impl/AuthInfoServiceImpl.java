package com.kses.backoffice.bas.authority.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bas.authority.mapper.AuthInfoManageMapper;
import com.kses.backoffice.bas.authority.service.AuthInfoService;
import com.kses.backoffice.bas.authority.vo.AuthInfo;
import com.kses.backoffice.util.mapper.UniSelectInfoManageMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class AuthInfoServiceImpl extends EgovAbstractServiceImpl implements AuthInfoService{
	
	@Autowired
	private AuthInfoManageMapper authMapper;
	
	@Autowired
	private UniSelectInfoManageMapper uniMapper;
	
	@Override
	public List<Map<String, Object>> selectAuthInfoList(Map<String, Object> params) throws Exception {
		return authMapper.selectAuthInfoList(params);
	}

	@Override
	public Map<String, Object> selectAuthInfoDetail(String authorCode) throws Exception {
		return authMapper.selectAuthInfoDetail(authorCode);
	}
	
	@Override
	public int insertAuthInfo(AuthInfo authInfo) throws Exception {
		return (uniMapper.selectIdDoubleCheck("AUTHOR_CODE", "COMTNAUTHORINFO", "AUTHOR_CODE = ["+ authInfo.getAuthorCode() + "[" ) > 0) ? -1 :  authMapper.insertAuthInfo(authInfo);
	}
	
	@Override
	public int updateAuthInfo(AuthInfo authInfo) throws Exception {
		return authMapper.updateAuthInfo(authInfo);
	}

	@Override
	public int deleteAuthInfo(String authorCode) throws Exception {
		return authMapper.deleteAuthInfo(authorCode);
	}

	@Override
	public List<Map<String, Object>> selectAuthInfoComboList() throws Exception {
		return authMapper.selectAuthInfoComboList();
	}
}