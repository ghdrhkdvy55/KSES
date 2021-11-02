package com.kses.backoffice.rsv.msg.mapper;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.rsv.msg.vo.MessageInfo;
import com.kses.backoffice.rsv.msg.vo.MessageInfoVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface MessageInfoManageMapper {

    public List<Map<String, Object>> selectMsgManageListByPagination(MessageInfoVO searchVO) throws Exception;
    
    public List<MessageInfo> selectMsgCombo(String msgGubun) ;
	
    public Map<String, Object> selectMsgManageDetail(String MsgSeq) throws Exception;
	
    public int insertMsgManage(MessageInfo vo) throws Exception;
	
    public int updateMsgManage(MessageInfo vo) throws Exception;
	
    public int deleteMsgManage(String  MsgSeq) throws Exception;
	
}
