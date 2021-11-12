package com.kses.backoffice.sys.msg.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.sys.msg.mapper.MessageInfoManageMapper;
import com.kses.backoffice.sys.msg.service.MessageInfoManageService;
import com.kses.backoffice.sys.msg.vo.MessageInfo;
import com.kses.backoffice.sys.msg.vo.MessageInfoVO;

@Service
public class MessageInfoManageServiceImpl extends EgovAbstractServiceImpl implements MessageInfoManageService {

	
	private static final Logger LOGGER = LoggerFactory.getLogger(MessageInfoManageServiceImpl.class);
	
	@Autowired
	private MessageInfoManageMapper msgMapper;

	@Override
	public List<Map<String, Object>> selectMsgManageListByPagination(MessageInfoVO searchVO) throws Exception {
		// TODO Auto-generated method stub
		return msgMapper.selectMsgManageListByPagination(searchVO);
	}

	@Override
	public Map<String, Object> selectMsgManageDetail(String MsgSeq) throws Exception {
		// TODO Auto-generated method stub
		return msgMapper.selectMsgManageDetail(MsgSeq);
	}
	@Override
	public int updateMsgManage(MessageInfo vo) throws Exception {
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
		// TODO Auto-generated method stub
		return msgMapper.deleteMsgManage(msgSeq);
	}

	@Override
	public List<MessageInfo> selectMsgCombo(String msgGubun)
			throws Exception {
		// TODO Auto-generated method stub
		return msgMapper.selectMsgCombo(msgGubun);
	}
	
	
}
