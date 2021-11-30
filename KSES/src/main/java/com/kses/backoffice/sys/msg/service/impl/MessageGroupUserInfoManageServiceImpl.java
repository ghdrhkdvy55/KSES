package com.kses.backoffice.sys.msg.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.sys.msg.mapper.MessageGroupUserInfoManageMapper;
import com.kses.backoffice.sys.msg.service.MessageGroupUserInfoManageService;
import com.kses.backoffice.sys.msg.vo.MessageGroupUserInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class MessageGroupUserInfoManageServiceImpl extends EgovAbstractServiceImpl implements MessageGroupUserInfoManageService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MessageGroupUserInfoManageServiceImpl.class);
			
	@Autowired
	private MessageGroupUserInfoManageMapper msgGroupUserMapper;

	@Override
	public List<Map<String, Object>> selectMessageGroupUserInfoList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return msgGroupUserMapper.selectMessageGroupUserInfoList(params);
	}

	@Override
	public Map<String, Object> selectMessageGroupUserDetail(String groupUserseq) throws Exception {
		// TODO Auto-generated method stub
		return msgGroupUserMapper.selectMessageGroupUserDetail(groupUserseq);
	}

	@Override
	public int insertMessageGroupUserInfo(List<MessageGroupUserInfo> vo) throws Exception {
		// TODO Auto-generated method stub
		return msgGroupUserMapper.insertMessageGroupUserInfo(vo);
	}

	@Override
	public boolean deleteMessageGroupUserInfo(String delCds) throws Exception {
		// TODO Auto-generated method stub
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
		// TODO Auto-generated method stub
		 try {
	        	msgGroupUserMapper.insertMessageGroupUser(userInfo);
				return true;
		 }catch(Exception e) {
				LOGGER.error("deleteAuthInfo error:" + e.toString());
				return false;
		 }
	}
	 
}
