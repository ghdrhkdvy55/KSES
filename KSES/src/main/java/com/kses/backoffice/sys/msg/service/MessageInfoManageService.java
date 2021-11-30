package com.kses.backoffice.sys.msg.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.sys.msg.vo.MessageInfo;

public interface MessageInfoManageService {

	
	List<Map<String, Object>> selectMsgManageListByPagination(Map<String, Object> searchVO) throws Exception;
	
	Map<String, Object> selectMsgManageDetail(String msgSeq) throws Exception;
		
    int insertMsgManage(List<MessageInfo> messageInfos) throws Exception;
	
    int deleteMsgManage(String  msgSeq) throws Exception;
}
