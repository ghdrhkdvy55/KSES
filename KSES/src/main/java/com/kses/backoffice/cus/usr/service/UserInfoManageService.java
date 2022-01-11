package com.kses.backoffice.cus.usr.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.cus.usr.vo.UserInfo;
import com.kses.front.login.vo.UserLoginInfo;

public interface UserInfoManageService {

    List<Map<String, Object>> selectUserInfoListPage(Map<String, Object> params) throws Exception;
    
    Map<String, Object> selectUserInfoDetail(String userId) throws Exception;
    
    UserLoginInfo selectSSOUserInfo(Map<String, Object> params) throws Exception;
    
    Map<String, Object> selectUserVacntnInfo(String userId) throws Exception;
    
    Map<String, Object> selectSpeedOnVacntnInfo(UserLoginInfo userLoginInfo) throws Exception;
    
    int updateUserInfo(UserInfo vo) throws Exception;
    
    int updateUserRcptInfo(UserInfo vo) throws Exception;
    
    int updateUserNoshowCount(String userId) throws Exception;
    
    boolean deleteUserInfo(String delCds) throws Exception;
}
