package com.kses.backoffice.sys.msg.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.sys.msg.vo.MessageInfo;
import com.kses.backoffice.sys.msg.vo.MessageInfoVO;

public interface MessageInfoManageService {

	
	List<Map<String, Object>> selectMsgManageListByPagination(MessageInfoVO searchVO) throws Exception;
	
	List<MessageInfo> selectMsgCombo(String msgGubun) throws Exception;
	
	Map<String, Object> selectMsgManageDetail(String msgSeq) throws Exception;
		
    int updateMsgManage(MessageInfo vo) throws Exception;
	
    int deleteMsgManage(String  msgSeq) throws Exception;
}
