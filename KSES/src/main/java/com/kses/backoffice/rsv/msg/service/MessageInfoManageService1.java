package com.kses.backoffice.rsv.msg.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.rsv.msg.vo.MessageInfo1;
import com.kses.backoffice.rsv.msg.vo.MessageInfoVO1;

public interface MessageInfoManageService1 {

	
	List<Map<String, Object>> selectMsgManageListByPagination(MessageInfoVO1 searchVO) throws Exception;
	
	List<MessageInfo1> selectMsgCombo(String msgGubun) throws Exception;
	
	Map<String, Object> selectMsgManageDetail(String msgSeq) throws Exception;
		
    int updateMsgManage(MessageInfo1 vo) throws Exception;
	
    int deleteMsgManage(String  msgSeq) throws Exception;
}
