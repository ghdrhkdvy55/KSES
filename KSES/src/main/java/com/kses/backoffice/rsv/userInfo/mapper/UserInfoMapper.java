package com.kses.backoffice.rsv.userInfo.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface UserInfoMapper {

	public List<Map<String, Object>> selectUserInfoListByPagination(@Param("params") Map<String, Object> params);
	
	public Map<String, Object> selectUserDetail(String userId);
	
	public List<Map<String, Object>> selectCmmnDetailCombo (String code);
	
}