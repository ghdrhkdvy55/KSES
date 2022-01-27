package com.kses.backoffice.rsv.msg.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.rsv.msg.mapper.MessageInfoManageMapper;
import com.kses.backoffice.rsv.msg.service.MessageInfoManageService;
import com.kses.backoffice.rsv.msg.vo.MessageInfo;

@Service
public class MessageInfoManageServiceImpl extends EgovAbstractServiceImpl implements MessageInfoManageService {

	
	private static final Logger LOGGER = LoggerFactory.getLogger(MessageInfoManageServiceImpl.class);
	
	@Autowired
	private MessageInfoManageMapper msgMapper;

	@Override
	public List<Map<String, Object>> selectMsgManageListByPagination(Map<String, Object> searchVO) throws Exception {
		return msgMapper.selectMsgManageListByPagination(searchVO);
	}

	@Override
	public Map<String, Object> selectMsgManageDetail(String MsgSeq) throws Exception {
		return msgMapper.selectMsgManageDetail(MsgSeq);
	}
	@Override
	public int insertMsgManage(List<MessageInfo> messageInfos) throws Exception {
		return msgMapper.insertMsgManage(messageInfos);		
	}

	@Override
	public int deleteMsgManage(String msgSeq) throws Exception {
		return 0;
	}
	
	
}
