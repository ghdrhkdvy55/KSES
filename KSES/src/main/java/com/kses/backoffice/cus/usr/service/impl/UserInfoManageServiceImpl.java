package com.kses.backoffice.cus.usr.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.cus.usr.mapper.UserInfoManageMapper;
import com.kses.backoffice.cus.usr.service.UserInfoManageService;
import com.kses.backoffice.cus.usr.vo.UserInfo;
import com.kses.backoffice.util.SmartUtil;
import com.kses.front.login.vo.UserLoginInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service
public class UserInfoManageServiceImpl extends EgovAbstractServiceImpl implements UserInfoManageService {

	private static final Logger LOGGER = LoggerFactory.getLogger(UserInfoManageServiceImpl.class);
	
	
	@Autowired
	private UserInfoManageMapper userMapper;

	@Override
	public List<Map<String, Object>> selectUserInfoListPage(Map<String, Object> params) throws Exception {
		return userMapper.selectUserInfoListPage(params);
	}

	@Override
	public Map<String, Object> selectUserInfoDetail(String userId) throws Exception {
		return userMapper.selectUserInfoDetail(userId);
	}
	
	@Override
	public UserLoginInfo selectSSOUserInfo(Map<String, Object> params) throws Exception {
		return userMapper.selectSSOUserInfo(params);
	}
	
	@Override
	public Map<String, Object> selectUserVacntnInfo(String userId) throws Exception {
		return userMapper.selectUserVacntnInfo(userId);
	}
	
	@Override
	public Map<String, Object> selectSpeedOnVacntnInfo(UserLoginInfo userLoginInfo) throws Exception {
		return userMapper.selectSpeedOnVacntnInfo(userLoginInfo);
	}

	@Override
	public int updateUserInfo(UserInfo vo) throws Exception {
		return vo.getMode().equals("Ins") ?  userMapper.insertUserInfo(vo) : userMapper.updateUserInfo(vo);
	}
	
	@Override
	public int updateUserRcptInfo(UserInfo vo) throws Exception {
		return userMapper.updateUserRcptInfo(vo);
	}

	@Override
	public boolean deleteUserInfo(String delCds) throws Exception {
        try {
        	userMapper.deleteUserInfo(SmartUtil.dotToList(delCds));
			return true;
		}catch(Exception e) {
			LOGGER.error("deleteAuthInfo error:" + e.toString());
			return false;
		}
	}
}