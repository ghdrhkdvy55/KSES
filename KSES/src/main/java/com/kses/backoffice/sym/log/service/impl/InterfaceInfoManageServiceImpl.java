package com.kses.backoffice.sym.log.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.JsonNode;
import com.kses.backoffice.cus.usr.vo.UserInfo;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;
import com.kses.backoffice.rsv.reservation.vo.speedon;
import com.kses.backoffice.rsv.reservation.web.ResJosnController;
import com.kses.backoffice.sym.log.mapper.InterfaceInfoManageMapper;
import com.kses.backoffice.sym.log.service.InterfaceInfoManageService;
import com.kses.backoffice.sym.log.vo.InterfaceInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.rte.fdl.property.EgovPropertyService;


@Service
@SuppressWarnings("unchecked")
public class InterfaceInfoManageServiceImpl extends EgovAbstractServiceImpl implements InterfaceInfoManageService {

	private static final Logger LOGGER = LoggerFactory.getLogger(InterfaceInfoManageServiceImpl.class);

	@Autowired
	EgovMessageSource egovMessageSource;
	
	@Autowired
	private InterfaceInfoManageMapper interfaceMapper;
	
	@Resource (name = "egovTrsmrcvLogIdGnrService")
	private EgovIdGnrService egovTranLog;
	
	@Autowired
	private ResvInfoManageService resvService;

	@Autowired
	protected EgovPropertyService propertiesService;
	
	@Override
	public List<Map<String, Object>> selectInterfaceLogInfo(Map<String, Object> searchVO) throws Exception {
		// TODO Auto-generated method stub
		return interfaceMapper.selectInterfaceLogInfo(searchVO);
	}

	@Override
	public Map<String, Object> selectInterfaceDetail(String requstId) throws Exception {
		// TODO Auto-generated method stub
		return interfaceMapper.selectInterfaceDetail(requstId);
	}
	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> SpeedOnCancelPayMent(JSONObject jsonObject) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		// 값 넣기
		String Url = propertiesService.getString("sppeedUrl_T") + "trade/fepDeposit";
		JsonNode node = null;

		try {
			Map<String, Object> resvInfo = resvService.selectUserResvInfo(jsonObject);
		
			jsonObject.put("System_Type", "E");
			jsonObject.put("External_Key", resvInfo.get("resv_seq"));
			jsonObject.put("Card_Id", resvInfo.get("user_card_id"));
			
			if(SmartUtil.NVL(jsonObject.get("Pw_YN"),"").equals("N")) {
				jsonObject.put("Card_Pw", "");
				jsonObject.put("Pw_YN", "N");
			} else {
				jsonObject.put("Card_Pw", SmartUtil.encryptPassword(jsonObject.get("Card_Pw").toString(), "SHA-256"));
				jsonObject.put("Pw_YN", "Y");
			}
			
			jsonObject.put("Card_Seq", resvInfo.get("user_card_seq"));
			jsonObject.put("Div_Cd", resvInfo.get("center_speed_cd"));
		
			if (resvInfo.get("resv_entry_dvsn").equals("ENTRY_DVSN_1")) {
				jsonObject.put("Pay_Type", "001");
				jsonObject.put("Trade_Cd", "10A11");
				jsonObject.put("Trade_Detail", "입장시스템 입장료 출금 취소");
			} else {
				jsonObject.put("Pay_Type", "003");
				jsonObject.put("Trade_Cd", "10A13");
				jsonObject.put("Trade_Detail", "입장시스템 입장/좌석 이용료 출금 취소");
			}
		
			jsonObject.put("Trade_No", resvInfo.get("trad_no").toString());
			jsonObject.put("Trade_Pay", resvInfo.get("resv_pay_cost").toString());
		
			node = SmartUtil.requestHttpJson(Url, jsonObject.toJSONString(), "SPEEDFEPDEPOSIT", "SPEEDON", "KSES");
			
			if(node.get("Error_Cd").asText().equals("SUCCESS")) {
				//예약 테이블 취소 정보 처리 하기
				ResvInfo resInfo = new ResvInfo();
				resInfo.setResvSeq(SmartUtil.NVL(jsonObject.get("resvSeq"), "").toString());
				resInfo.setResvPayDvsn("RESV_PAY_DVSN_3");
				resInfo.setResvPayDvsn("RESV_STATE_4");
				resInfo.setTradNo(node.get("Trade_No").asText());
				resvService.resPriceChange(resInfo);
				result.put(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.request.msg"));
			} else {
				for (speedon direction : speedon.values()) {
					if (direction.getCode().equals(node.get("Error_Cd").asText())) {
						result.put(Globals.STATUS_MESSAGE, direction.getName());
					}
				}
			}
			
			result.put(Globals.STATUS, node.get("Error_Cd").asText());
			result.put(Globals.STATUS_REGINFO, node);
		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			result.put(Globals.STATUS, Globals.STATUS_FAIL);
			result.put(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		
		return result;
	}

	@Override
	public int InterfaceInsertLoginLog(InterfaceInfo vo) throws Exception {
		// TODO Auto-generated method stub
		vo.setRequstId( egovTranLog.getNextStringId());
		return interfaceMapper.InterfaceInsertLoginLog(vo);
	}

	@Override
	public int InterfaceUpdateLoginLog(InterfaceInfo vo) throws Exception {
		// TODO Auto-generated method stub
		return interfaceMapper.InterfaceUpdateLoginLog(vo);
	}

}
