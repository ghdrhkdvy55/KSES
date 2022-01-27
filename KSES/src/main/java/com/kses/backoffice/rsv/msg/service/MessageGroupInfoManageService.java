package com.kses.backoffice.rsv.msg.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import com.kses.backoffice.rsv.msg.vo.MessageGroupInfo;


public interface MessageGroupInfoManageService {

    List<Map<String, Object>> selectMessageGroupInfoList( Map<String, Object> params)throws Exception;
    
    Map<String, Object> selectMessageGroupDetail(String boardCd)throws Exception;
    
    int updateMessageGroupInfo(MessageGroupInfo vo)throws Exception;
    
    boolean deleteMessageGroupInfo(String delCds)throws Exception;
}
