package com.kses.backoffice.cus.usr.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.kses.backoffice.cus.usr.vo.UserInfo;
import com.kses.front.login.vo.UserLoginInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface UserInfoManageMapper {

    public List<Map<String, Object>> selectUserInfoListPage(@Param("params") Map<String, Object> params);
    
    public Map<String, Object> selectUserInfoDetail(String userId);
    
    public UserLoginInfo selectSSOUserInfo(@Param("params") Map<String, Object> params);
    
    public Map<String, Object> selectUserVacntnInfo(String userId);
    
    public Map<String, Object> selectSpeedOnVacntnInfo(UserLoginInfo userLoginInfo);
    
    public int insertUserInfo(UserInfo vo);
	
    public int updateUserInfo(UserInfo vo);
    
    public int updateUserRcptInfo(UserInfo vo);
    
    public int updateUserNoshowCount(String userId);
    
    public void deleteUserInfo(@Param("delCds") List<String> delCds);
}
