package com.kses.backoffice.cus.kko.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
	
	@Autowired
	private SmartUtil util;

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
		if (!util.NVL(params.get("emphandphone"), "").toString().equals("")  ) {
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

	@Override
	public int kkoVisitedInsertService(String _snedGubun,  List<List< Object>> params, String _visitedGubun) throws Exception {
		
		KkoMsgInfo vo = new KkoMsgInfo();
		kkoMessageInfo message = new kkoMessageInfo();
		Map<String, Object> visitedInfo = null;
		if (_visitedGubun.equals("VISITED_GUBUN_1")) {
			visitedInfo = (Map<String, Object>) params.stream().limit(1).collect(Collectors.toList()).get(0).get(0);
		}else {
			visitedInfo = (Map<String, Object>) params.stream().limit(1).collect(Collectors.toList()).get(0);
		}
		
		
		Map<String, String> returnMsg =  visitedInfo.get("visited_gubun").toString().equals("VISITED_GUBUN_1") ?
				message.visitedMsg(_snedGubun, visitedInfo): message.tourMsg(_snedGubun, visitedInfo) ;
		
		int ret = 0;
		
		if (!util.NVL(visitedInfo.get("visited_req_celphone"), "").toString().equals("")  ) {
			//case 할지 안할지 정리 하기
			if (!_snedGubun.equals("REQ") && !_snedGubun.equals("ARR") && visitedInfo.get("visited_gubun").toString().equals("VISITED_GUBUN_1")) {
				vo.setPhone(  visitedInfo.get("visited_req_celphone").toString().replaceAll("-", ""));
				vo.setCallback(visitedInfo.get("emphandphone").toString().replaceAll("-", ""));
			}else if (visitedInfo.get("visited_gubun").toString().equals("VISITED_GUBUN_1")) {
				vo.setPhone(visitedInfo.get("emphandphone").toString().replaceAll("-", ""));
				vo.setCallback(visitedInfo.get("visited_req_celphone").toString().replaceAll("-", ""));
			}else if (visitedInfo.get("visited_gubun").toString().equals("VISITED_GUBUN_2")) {
				vo.setPhone(visitedInfo.get("visited_req_celphone").toString());
				vo.setCallback("01021703122");
			}
			System.out.println("---------------------------------------------------------");
			System.out.println(returnMsg.get("buttonJson"));
			System.out.println("---------------------------------------------------------");
			vo.setButtonJson(returnMsg.get("buttonJson"));
			vo.setMsg(returnMsg.get("resMessage"));
			vo.setTemplateCode(returnMsg.get("templeCode"));
			
			vo.setFailedType("MMS");
			vo.setFailedSubject(returnMsg.get("title"));
			vo.setFailedMsg(returnMsg.get("resMessage"));
			ret = kkoMapper.kkoMsgInsertSevice(vo);
		}
		
		return ret;
	}


	
	
}
