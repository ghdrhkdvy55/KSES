package com.kses.backoffice.rsv.msg.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.rsv.msg.mapper.MessageInfoManageMapper1;
import com.kses.backoffice.rsv.msg.service.MessageInfoManageService1;
import com.kses.backoffice.rsv.msg.vo.MessageInfo1;
import com.kses.backoffice.rsv.msg.vo.MessageInfoVO1;

@Service
public class MessageInfoManageServiceImpl1 extends EgovAbstractServiceImpl implements MessageInfoManageService1 {

	
	private static final Logger LOGGER = LoggerFactory.getLogger(MessageInfoManageServiceImpl1.class);
	
	@Autowired
	private MessageInfoManageMapper1 msgMapper;

	@Override
	public List<Map<String, Object>> selectMsgManageListByPagination(MessageInfoVO1 searchVO) throws Exception {
		return msgMapper.selectMsgManageListByPagination(searchVO);
	}

	@Override
	public Map<String, Object> selectMsgManageDetail(String MsgSeq) throws Exception {
		return msgMapper.selectMsgManageDetail(MsgSeq);
	}
	@Override
	public int updateMsgManage(MessageInfo1 vo) throws Exception {
		int ret = 0;
		try{
			if (vo.getMode().equals("Ins"))
				ret = msgMapper.insertMsgManage(vo);
			else 
				ret =msgMapper.updateMsgManage(vo);
		}catch(Exception e){
			LOGGER.error("updateMsgManage error:" + e.toString());
		}
		return ret;
	}

	@Override
	public int deleteMsgManage(String msgSeq) throws Exception {
		return msgMapper.deleteMsgManage(msgSeq);
	}

	@Override
	public List<MessageInfo1> selectMsgCombo(String msgGubun)
			throws Exception {
		return msgMapper.selectMsgCombo(msgGubun);
	}
	
	
}
