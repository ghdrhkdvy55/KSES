package com.kses.backoffice.bas.authority.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bas.authority.vo.AuthInfo;

public interface AuthInfoService {
	
	public List<Map<String, Object>> selectAuthInfoList(Map<String, Object> params) throws Exception;
	
	public List<Map<String, Object>> selectAuthInfoComboList() throws Exception;
	
    public Map<String, Object> selectAuthInfoDetail(String authCode) throws Exception;
	
    public int updateAuthInfo(AuthInfo vo) throws Exception;
    
    public int deleteAuthInfo(String authCode) throws Exception;
}
