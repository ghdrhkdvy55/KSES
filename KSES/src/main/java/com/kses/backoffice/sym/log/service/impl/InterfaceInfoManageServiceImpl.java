package com.kses.backoffice.sym.log.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import com.fasterxml.jackson.databind.JsonNode;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;
import com.kses.backoffice.rsv.reservation.vo.speedon;
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
		return interfaceMapper.selectInterfaceLogInfo(searchVO);
	}

	@Override
	public Map<String, Object> selectInterfaceDetail(String requstId) throws Exception {
		return interfaceMapper.selectInterfaceDetail(requstId);
	}
	
	@Override
    public String selectInterfaceLogCsvHeader() throws Exception {
		return interfaceMapper.selectInterfaceLogCsvHeader();
	}
    
	@Override
    public List<String> selectInterfaceLogCsvList(InterfaceInfo vo) throws Exception{
		return interfaceMapper.selectInterfaceLogCsvList(vo);
	}
	
	@Override
	public ModelMap SpeedOnPayMent(String resvSeq, String cardPw, boolean isPassword) throws Exception {
		String Url = propertiesService.getString("speedOnUrl") + "trade/fepWithdraw";		
		JSONObject jsonObject = new JSONObject();
		ModelMap result = new ModelMap();
		String message = "";
		
		JsonNode node = null;
		jsonObject.put("resvSeq", resvSeq);
		try {	
			Map<String, Object> resvInfo = resvService.selectUserResvInfo(jsonObject);
			int partSpeedPayCost = Integer.parseInt(SmartUtil.NVL(resvInfo.get("part_speed_pay_cost"),"0")); 
		    int centerSpeedEntryPayCost = Integer.parseInt(SmartUtil.NVL(resvInfo.get("center_speed_entry_pay_cost"),"0")); 
		    
			if(!SmartUtil.NVL(resvInfo.get("resv_state"),"").equals("RESV_STATE_1")) {
				switch (SmartUtil.NVL(resvInfo.get("resv_state"),"")) {
					case "RESV_STATE_2" : message = "?????? ???????????? ???????????? ?????????.";  break;
					case "RESV_STATE_3" : message = "?????? ???????????? ????????? ???????????? ?????????.";  break;
					case "RESV_STATE_4" : message = "?????? ????????? ???????????? ?????????.";  break;
					default: message = "???????????? ???????????? ?????????."; break;
				}
				result.addAttribute(Globals.STATUS, Globals.STATUS_FAIL);
				result.addAttribute(Globals.STATUS_MESSAGE, message);
				return result;
			}
			
			if(!SmartUtil.NVL(resvInfo.get("resv_pay_dvsn"),"").equals("RESV_PAY_DVSN_1")) {
				switch (SmartUtil.NVL(resvInfo.get("resv_pay_dvsn"),"")) {
					case "RESV_PAY_DVSN_2" : message = "?????? ??????????????? ???????????? ?????????.";  break;
					case "RESV_PAY_DVSN_3" : message = "?????? ??????????????? ???????????? ?????????.";  break;
					default: message = "???????????? ???????????? ?????????."; break;
				}
				result.addAttribute(Globals.STATUS, Globals.STATUS_FAIL);
				result.addAttribute(Globals.STATUS_MESSAGE, message);
				return result;
			}
			
			if(!SmartUtil.NVL(resvInfo.get("center_pilot_yn"),"").equals("Y")) {
				result.addAttribute(Globals.STATUS, Globals.STATUS_FAIL);
				result.addAttribute(Globals.STATUS_MESSAGE, "????????? ???????????????.");
				return result;
			}
			
			jsonObject.put("System_Type", "E");
			jsonObject.put("External_Key", resvInfo.get("resv_seq"));
			jsonObject.put("Card_Id", resvInfo.get("user_card_id"));

			if(isPassword) {
				jsonObject.put("Card_Pw", SmartUtil.encryptPassword(cardPw, "SHA-256"));
				jsonObject.put("Pw_YN", "Y");
			} else {
				jsonObject.put("Card_Pw", "");
				jsonObject.put("Pw_YN", "N");
			}
			
			jsonObject.put("Card_Seq", resvInfo.get("user_card_seq"));
			jsonObject.put("Div_Cd", resvInfo.get("center_speed_cd"));

			if (resvInfo.get("resv_entry_dvsn").equals("ENTRY_DVSN_1")) {
				jsonObject.put("Pay_Type", "001");
				jsonObject.put("Trade_Cd", "20A61");
				jsonObject.put("Trade_Detail", "??????????????? ????????? ??????");
			} else {
				jsonObject.put("Pay_Type", "003");
				jsonObject.put("Trade_Cd", "20A63");
				jsonObject.put("Trade_Detail", "??????????????? ??????/?????? ????????? ??????");
			}
			
			jsonObject.put("Trade_Pay", String.valueOf(partSpeedPayCost + centerSpeedEntryPayCost));

			node = SmartUtil.requestHttpJson(Url, jsonObject.toJSONString(), "SPEEDWITHDRAW", "SPEEDON", "KSES");
			if (node.get("Error_Cd").asText().equals("SUCCESS")) {
				ResvInfo resInfo = new ResvInfo();
				resInfo.setResvSeq(SmartUtil.NVL(resvInfo.get("resv_seq"), "").toString());
				resInfo.setResvSeatPayCost(String.valueOf(partSpeedPayCost));
				resInfo.setResvEntryPayCost(String.valueOf(centerSpeedEntryPayCost));
				resInfo.setResvPayCost(String.valueOf(partSpeedPayCost + centerSpeedEntryPayCost));
				resInfo.setResvPayDvsn("RESV_PAY_DVSN_2");
				resInfo.setResvTicketDvsn("RESV_TICKET_DVSN_1");
				resInfo.setTradNo(node.get("Trade_No").asText());

				resvService.updateResvPriceInfo(resInfo);
			} else {
				for (speedon direction : speedon.values()) {
					if (direction.getCode().equals(node.get("Error_Cd").asText())) {
						result.addAttribute(Globals.STATUS_MESSAGE, direction.getName());
					}
				}
			}
			
			result.addAttribute(Globals.STATUS, node.get("Error_Cd").asText());
			result.addAttribute(Globals.STATUS_REGINFO, node);
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
	public ModelMap SpeedOnPayMentCancel(String resvSeq, String cardPw, boolean isPassword, boolean isForced) throws Exception {
		String Url = propertiesService.getString("speedOnUrl") + "trade/fepDeposit";
		JSONObject jsonObject = new JSONObject();
		ModelMap result = new ModelMap();
		String message = "";
		
		JsonNode node = null;

		try {
			jsonObject.put("resvSeq", resvSeq);
			Map<String, Object> resvInfo = resvService.selectUserResvInfo(jsonObject);
			
			if(!SmartUtil.NVL(resvInfo.get("resv_state"),"").equals("RESV_STATE_1")) {
				switch (SmartUtil.NVL(resvInfo.get("resv_state"),"")) {
					case "RESV_STATE_2" : message = "?????? ???????????? ???????????? ?????????.";  break;
					case "RESV_STATE_3" : message = "?????? ???????????? ????????? ???????????? ?????????.";  break;
					case "RESV_STATE_4" : message = "?????? ????????? ???????????? ?????????.";  break;
					default: message = "???????????? ???????????? ?????????."; break;
				}
				result.addAttribute(Globals.STATUS, Globals.STATUS_FAIL);
				result.addAttribute(Globals.STATUS_MESSAGE, message);
				return result;
			}
			
			if(!SmartUtil.NVL(resvInfo.get("resv_pay_dvsn"),"").equals("RESV_PAY_DVSN_2")) {
				switch (SmartUtil.NVL(resvInfo.get("resv_pay_dvsn"),"")) {
					case "RESV_PAY_DVSN_1" : message = "????????? ???????????? ?????????.";  break;
					case "RESV_PAY_DVSN_3" : message = "?????? ??????????????? ???????????? ?????????.";  break;
					default: message = "???????????? ???????????? ?????????."; break;
				}
				result.addAttribute(Globals.STATUS, Globals.STATUS_FAIL);
				result.addAttribute(Globals.STATUS_MESSAGE, message);
				return result;
			}
			
			if(!SmartUtil.NVL(resvInfo.get("resv_ticket_dvsn"),"").equals("RESV_TICKET_DVSN_1")) {
				switch (SmartUtil.NVL(resvInfo.get("resv_pay_dvsn"),"")) {
					case "RESV_TICKET_DVSN_2" : message = "??????????????? ?????? ???????????? ?????????.";  break;
					default: message = "???????????? ???????????? ?????????."; break;
				}
				result.addAttribute(Globals.STATUS, Globals.STATUS_FAIL);
				result.addAttribute(Globals.STATUS_MESSAGE, message);
				return result;
			}
			
			jsonObject.put("System_Type", "E");
			jsonObject.put("External_Key", resvInfo.get("resv_seq"));
			jsonObject.put("Card_Id", resvInfo.get("user_card_id"));
			
			if(isPassword) {
				jsonObject.put("Card_Pw", SmartUtil.encryptPassword(cardPw, "SHA-256"));
				jsonObject.put("Pw_YN", "Y");
			} else {
				jsonObject.put("Card_Pw", "");
				jsonObject.put("Pw_YN", "N");
			}
			
			jsonObject.put("Card_Seq", resvInfo.get("user_card_seq"));
			jsonObject.put("Div_Cd", resvInfo.get("center_speed_cd"));
		
			if (resvInfo.get("resv_entry_dvsn").equals("ENTRY_DVSN_1")) {
				jsonObject.put("Pay_Type", "001");
				jsonObject.put("Trade_Cd", "10A11");
				jsonObject.put("Trade_Detail", "??????????????? ????????? ?????? ??????");
			} else {
				jsonObject.put("Pay_Type", "003");
				jsonObject.put("Trade_Cd", "10A13");
				jsonObject.put("Trade_Detail", "??????????????? ??????/?????? ????????? ?????? ??????");
			}
		
			jsonObject.put("Trade_No", resvInfo.get("trad_no").toString());
			jsonObject.put("Trade_Pay", resvInfo.get("resv_pay_cost").toString());
		
			node = SmartUtil.requestHttpJson(Url, jsonObject.toJSONString(), "SPEEDFEPDEPOSIT", "SPEEDON", "KSES");
			
			if(node.get("Error_Cd").asText().equals("SUCCESS")) {
				//?????? ????????? ?????? ?????? ?????? ??????
				ResvInfo resInfo = new ResvInfo();
				resInfo.setResvSeq(resvSeq);
				resInfo.setResvPayDvsn("RESV_PAY_DVSN_3");
				resInfo.setResvTicketDvsn("RESV_TICKET_DVSN_1");
				resInfo.setTradNo(node.get("Trade_No").asText());
				resvService.updateResvPriceInfo(resInfo);
				
				result.addAttribute(Globals.STATUS, Globals.STATUS_SUCCESS);
				result.addAttribute(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.request.msg"));
			} else {
				for (speedon direction : speedon.values()) {
					if (direction.getCode().equals(node.get("Error_Cd").asText())) {
						result.addAttribute(Globals.STATUS, Globals.STATUS_FAIL);
						result.addAttribute(Globals.STATUS_MESSAGE, direction.getName());
					}
				}
			}
			
			result.addAttribute(Globals.STATUS, node.get("Error_Cd").asText());
			result.addAttribute(Globals.STATUS_REGINFO, node);
		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			result.addAttribute(Globals.STATUS, Globals.STATUS_FAIL);
			result.addAttribute(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		
		return result;
	}

	@Override
	public int InterfaceInsertLoginLog(InterfaceInfo vo) throws Exception {
		vo.setRequstId( egovTranLog.getNextStringId());
		return interfaceMapper.InterfaceInsertLoginLog(vo);
	}

	@Override
	public int InterfaceUpdateLoginLog(InterfaceInfo vo) throws Exception {
		return interfaceMapper.InterfaceUpdateLoginLog(vo);
	}
	
	@Override
	public int deleteInterfaceLogCsvList(String occrrncDe) throws Exception {
		return interfaceMapper.deleteInterfaceLogCsvList(occrrncDe);
	}
}