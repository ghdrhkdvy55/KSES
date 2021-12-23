package com.kses.backoffice.cus.usr.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.cus.usr.vo.UserInfo;

public interface UserInfoManageService {

    List<Map<String, Object>> selectUserInfoListPage(Map<String, Object> params) throws Exception;
    
    Map<String, Object> selectUserInfoDetail(String userId) throws Exception;
    
    Map<String, Object> selectUserVacntnInfo(String userId) throws Exception;
    
    int updateUserInfo(UserInfo vo) throws Exception;
    
    int updateUserRcptInfo(UserInfo vo) throws Exception;
    
    boolean deleteUserInfo(String delCds) throws Exception;
}
