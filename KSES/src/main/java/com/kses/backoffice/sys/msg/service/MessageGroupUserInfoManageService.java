package com.kses.backoffice.sys.msg.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.sys.msg.vo.MessageGroupUserInfo;

public interface MessageGroupUserInfoManageService {

	
    List<Map<String, Object>> selectMessageGroupUserInfoList(@Param("params") Map<String, Object> params) throws Exception;
    
    Map<String, Object> selectMessageGroupUserDetail(String groupCd) throws Exception;
    
    int insertMessageGroupUserInfo(List<MessageGroupUserInfo> vo) throws Exception;
    
    boolean insertMessageGroupUser(MessageGroupUserInfo userInfo) throws Exception;
    
    boolean deleteMessageGroupUserInfo(String delCds) throws Exception;
}
