package com.kses.backoffice.rsv.msg.service;

import java.util.List;
import java.util.Map;
import com.kses.backoffice.rsv.msg.vo.MessageTemInfo;


public interface MessageTemInfoManageService {

    List<Map<String, Object>> selectMessageTemplateInfoList(Map<String, Object> params);
    
    Map<String, Object> selectMessageTemplateDetail(String tempSeq);
    
    int updateMessageTemplateInfo(MessageTemInfo vo);
    
    boolean deleteMessageTemplateInfo( String delCds);
}
