package com.kses.front.login.mapper;

import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserLoginMapper {
	public Map<String, Object> getUserLoginInfo(@Param("params") Map<String, Object> params) throws Exception;
	
	String getUserLoginCheck(@Param("params") Map<String, Object> params) throws Exception;
}
