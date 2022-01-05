package com.kses.front.login.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.front.login.mapper.UserLoginMapper;
import com.kses.front.login.service.UserLoginService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class UserLoginServiceImpl extends EgovAbstractServiceImpl implements UserLoginService{
	
	@Autowired
	UserLoginMapper userLoginMapper;
	
	@Override
	public Map<String, Object> getUserLoginInfo(Map<String, Object> params) throws Exception {
		return userLoginMapper.getUserLoginInfo(params);
	}
	
	@Override
	public String getUserLoginCheck(Map<String, Object> params) throws Exception {
		return userLoginMapper.getUserLoginCheck(params);
	}
}