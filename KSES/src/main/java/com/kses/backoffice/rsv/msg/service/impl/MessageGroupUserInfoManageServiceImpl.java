package com.kses.backoffice.rsv.msg.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.rsv.msg.mapper.MessageGroupUserInfoManageMapper;
import com.kses.backoffice.rsv.msg.service.MessageGroupUserInfoManageService;
import com.kses.backoffice.rsv.msg.vo.MessageGroupUserInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class MessageGroupUserInfoManageServiceImpl extends EgovAbstractServiceImpl implements MessageGroupUserInfoManageService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MessageGroupUserInfoManageServiceImpl.class);
			
	@Autowired
	private MessageGroupUserInfoManageMapper msgGroupUserMapper;

	@Override
	public List<Map<String, Object>> selectMessageGroupUserInfoList(Map<String, Object> params) throws Exception {
		return msgGroupUserMapper.selectMessageGroupUserInfoList(params);
	}

	@Override
	public Map<String, Object> selectMessageGroupUserDetail(String groupUserseq) throws Exception {
		return msgGroupUserMapper.selectMessageGroupUserDetail(groupUserseq);
	}

	@Override
	public int insertMessageGroupUserInfo(List<MessageGroupUserInfo> vo) throws Exception {
		return msgGroupUserMapper.insertMessageGroupUserInfo(vo);
	}

	@Override
	public boolean deleteMessageGroupUserInfo(String delCds) throws Exception {
        try {
        	msgGroupUserMapper.deleteMessageGroupUserInfo(SmartUtil.dotToList(delCds));
			return true;
		}catch(Exception e) {
			LOGGER.error("deleteAuthInfo error:" + e.toString());
			return false;
		}
		
	}

	@Override
	public boolean insertMessageGroupUser(MessageGroupUserInfo userInfo) throws Exception {
		 try {
	        	msgGroupUserMapper.insertMessageGroupUser(userInfo);
				return true;
		 }catch(Exception e) {
				LOGGER.error("deleteAuthInfo error:" + e.toString());
				return false;
		 }
	}
	 
}
