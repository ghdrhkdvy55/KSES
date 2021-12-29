package com.kses.backoffice.bas.authority.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bas.authority.vo.AuthInfo;

public interface AuthInfoService {
	
	List<Map<String, Object>> selectAuthInfoList(Map<String, Object> params) throws Exception;
	
	List<Map<String, Object>> selectAuthInfoComboList() throws Exception;
	
    Map<String, Object> selectAuthInfoDetail(String authCode) throws Exception;
	
    int insertAuthInfo(AuthInfo authInfo) throws Exception;
    
    int updateAuthInfo(AuthInfo authInfo) throws Exception;
    
    int deleteAuthInfo(String authCode) throws Exception;
}
