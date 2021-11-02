package com.kses.backoffice.cus.kko.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.cus.kko.mapper.KkoMsgManageMapper;
import com.kses.backoffice.cus.kko.service.KkoMsgManageSevice;
import com.kses.backoffice.cus.kko.vo.KkoMsgInfo;
import com.kses.backoffice.cus.kko.vo.kkoMessageInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class KkoMsgManageSeviceImpl extends EgovAbstractServiceImpl implements KkoMsgManageSevice  {

	
	@Autowired
	private KkoMsgManageMapper kkoMapper;

	@Override
	public List<Map<String, Object>> selectKkoMsgInfoList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return kkoMapper.selectKkoMsgInfoList(params);
	}

	@Override
	public Map<String, Object> selectKkoMsgInfoDetail(String msgkey) throws Exception {
		// TODO Auto-generated method stub
		return kkoMapper.selectKkoMsgInfoDetail(msgkey);
	}

	@Override
	public int kkoMsgInsertSevice(String _sendGubun, Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		KkoMsgInfo vo = new KkoMsgInfo();
		kkoMessageInfo message = new kkoMessageInfo();
		Map<String, String> returnMsg = new HashMap<String, String>();
		
		
		if (params.get("item_gubun").equals("ITEM_GUBUN_1")) {
			returnMsg = message.meetingMsg(_sendGubun, params);
		}else if  (params.get("item_gubun").equals("ITEM_GUBUN_3")) {
			returnMsg = message.coregMsg(_sendGubun, params);
		}
		int ret = 0;
		if (!SmartUtil.NVL(params.get("emphandphone"), "").toString().equals("")  ) {
			vo.setPhone(  params.get("emphandphone").toString());
			vo.setCallback("01021703122");
			vo.setMsg(returnMsg.get("resMessage"));
			vo.setTemplateCode(returnMsg.get("templeCode"));
			vo.setFailedType("MMS");
			vo.setFailedSubject(returnMsg.get("title"));
			vo.setFailedMsg(returnMsg.get("resMessage"));
			kkoMapper.kkoMsgInsertSevice(vo);
		}
		
		return ret;
	}
	
	
}
