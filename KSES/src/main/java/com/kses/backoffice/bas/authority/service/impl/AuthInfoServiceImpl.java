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
		// TODO Auto-generated method stub
		return authMapper.selectAuthInfoList(params);
	}

	@Override
	public Map<String, Object> selectAuthInfoDetail(String authorCode) throws Exception {
		// TODO Auto-generated method stub
		return authMapper.selectAuthInfoDetail(authorCode);
	}
	
	@Override
	public int updateAuthInfo(AuthInfo vo) throws Exception {
		int ret = 0;
		
		if (vo.getMode().equals("Ins")){
			ret = (uniMapper.selectIdDoubleCheck("AUTHOR_CODE", "COMTNAUTHORINFO", "AUTHOR_CODE = ["+ vo.getAuthorCode() + "[" ) > 0) ? -1 :  authMapper.insertAuthInfo(vo);
		} else {
			ret = authMapper.updateAuthInfo(vo);
		}
		return ret;
	}

	@Override
	public int deleteAuthInfo(String authorCode) throws Exception {
		return authMapper.deleteAuthInfo(authorCode);
	}

	@Override
	public List<Map<String, Object>> selectAuthInfoComboList() throws Exception {
		// TODO Auto-generated method stub
		return authMapper.selectAuthInfoComboList();
	}
}