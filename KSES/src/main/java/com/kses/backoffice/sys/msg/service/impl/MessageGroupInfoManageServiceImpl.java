package com.kses.backoffice.sys.msg.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.sys.msg.mapper.MessageGroupInfoManageMapper;
import com.kses.backoffice.sys.msg.service.MessageGroupInfoManageService;
import com.kses.backoffice.sys.msg.vo.MessageGroupInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class MessageGroupInfoManageServiceImpl extends EgovAbstractServiceImpl implements MessageGroupInfoManageService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MessageGroupInfoManageServiceImpl.class);
	
	@Autowired
	private MessageGroupInfoManageMapper messageGroupMapper;

	@Override
	public List<Map<String, Object>> selectMessageGroupInfoList(Map<String, Object> params) throws Exception {
		return messageGroupMapper.selectMessageGroupInfoList(params);
	}

	@Override
	public Map<String, Object> selectMessageGroupDetail(String groupCd) throws Exception {
		return messageGroupMapper.selectMessageGroupDetail(groupCd);
	}

	@Override
	public int updateMessageGroupInfo(MessageGroupInfo vo) throws Exception {
		return vo.getMode().equals("Ins") ? messageGroupMapper.insertMessageGroupInfo(vo) : messageGroupMapper.updateMessageGroupInfo(vo);
	}

	@Override
	public boolean deleteMessageGroupInfo(String delCds) throws Exception {
		try {
			
			messageGroupMapper.deleteMessageGroupInfo(SmartUtil.dotToList(delCds));
			return true;
		}catch(Exception e) {
			LOGGER.error("deleteAuthInfo error:" + e.toString());
			return false;
		}
	}
	
	
	
}
