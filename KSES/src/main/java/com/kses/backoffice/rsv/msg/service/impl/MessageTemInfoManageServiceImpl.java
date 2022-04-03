package com.kses.backoffice.rsv.msg.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.rsv.msg.mapper.MessageTemInfoManageMapper;
import com.kses.backoffice.rsv.msg.service.MessageTemInfoManageService;
import com.kses.backoffice.rsv.msg.vo.MessageTemInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service
public class MessageTemInfoManageServiceImpl extends EgovAbstractServiceImpl implements MessageTemInfoManageService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MessageTemInfoManageServiceImpl.class);
	
	@Autowired
	private MessageTemInfoManageMapper msgMapper;

	@Override
	public List<Map<String, Object>> selectMessageTemplateInfoList(Map<String, Object> params) {
		return msgMapper.selectMessageTemplateInfoList(params);
	}

	@Override
	public Map<String, Object> selectMessageTemplateDetail(String tempSeq) {
		return msgMapper.selectMessageTemplateDetail(tempSeq);
	}

	@Override
	public int updateMessageTemplateInfo(MessageTemInfo vo) {
		return vo.getMode().equals("Ins") ? msgMapper.insertMessageTemplateInfo(vo) :  msgMapper.updateMessageTemplateInfo(vo);
	}

	@Override
	public boolean deleteMessageTemplateInfo(String delCds) {
		try {
    		msgMapper.deleteMessageTemplateInfo(SmartUtil.dotToList(delCds));
    		return true;
		}catch(Exception e) {
			LOGGER.error("deleteMessageTemplateInfo error:" + e.toString());
			return false;
		}
		
	}
	
	
}
