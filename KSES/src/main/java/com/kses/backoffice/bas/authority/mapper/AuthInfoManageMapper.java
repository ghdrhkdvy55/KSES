package com.kses.backoffice.bas.authority.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bas.authority.vo.AuthInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface AuthInfoManageMapper {

    public List<Map<String, Object>> selectAuthInfoList(@Param("params") Map<String, Object> params);
    
    public List<Map<String, Object>> selectAuthInfoComboList();
	
    public Map<String, Object> selectAuthInfoDetail(String authorCode);
    
    public int insertAuthInfo(AuthInfo vo);
	
    public int updateAuthInfo(AuthInfo vo);
    
    public int deleteAuthInfo(String authorCode);
}
