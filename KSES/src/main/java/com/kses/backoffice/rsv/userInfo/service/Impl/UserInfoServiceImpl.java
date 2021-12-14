package com.kses.backoffice.rsv.userInfo.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.rsv.userInfo.mapper.UserInfoMapper;
import com.kses.backoffice.rsv.userInfo.service.UserInfoService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class UserInfoServiceImpl extends EgovAbstractServiceImpl implements UserInfoService{
	@Autowired
	private UserInfoMapper userMapper;
	
	public List<Map<String, Object>> selectUserInfoListByPagination(Map<String, Object> params) throws Exception{
		
		return userMapper.selectUserInfoListByPagination(params);
	}
	
	public Map<String, Object> selectUserDetail(String userId) throws Exception{
		
		return userMapper.selectUserDetail(userId);
	}
	
	@Override
	public List<Map<String, Object>> selectCmmnDetailCombo(String code) throws Exception {
		// TODO Auto-generated method stub
		return userMapper.selectCmmnDetailCombo(code);
	}
}