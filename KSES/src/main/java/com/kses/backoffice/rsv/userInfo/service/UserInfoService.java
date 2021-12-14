package com.kses.backoffice.rsv.userInfo.service;

import java.util.List;
import java.util.Map;

public interface UserInfoService {

	public List<Map<String, Object>> selectUserInfoListByPagination(Map<String, Object> params) throws Exception;
	
	public Map<String, Object> selectUserDetail(String userId) throws Exception;
	
	List<Map<String, Object>> selectCmmnDetailCombo (String code) throws Exception;
	
}