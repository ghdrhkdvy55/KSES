package com.kses.front.login.service;

import java.util.Map;

public interface UserLoginService {
	Map<String, Object> getUserLoginInfo(Map<String, Object> params) throws Exception;
	
	String getUserLoginCheck(Map<String, Object> params) throws Exception;
}
