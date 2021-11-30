package com.kses.backoffice.rsv.msg.mapper;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.rsv.msg.vo.MessageInfo1;
import com.kses.backoffice.rsv.msg.vo.MessageInfoVO1;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface MessageInfoManageMapper1 {

    public List<Map<String, Object>> selectMsgManageListByPagination(MessageInfoVO1 searchVO) throws Exception;
    
    public List<MessageInfo1> selectMsgCombo(String msgGubun) ;
	
    public Map<String, Object> selectMsgManageDetail(String MsgSeq) throws Exception;
	
    public int insertMsgManage(MessageInfo1 vo) throws Exception;
	
    public int updateMsgManage(MessageInfo1 vo) throws Exception;
	
    public int deleteMsgManage(String  MsgSeq) throws Exception;
	
}
