package com.kses.backoffice.rsv.reservation.web;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.JsonNode;
import com.kses.backoffice.bas.kiosk.service.KioskInfoService;
import com.kses.backoffice.cus.usr.service.UserInfoManageService;
import com.kses.backoffice.cus.usr.vo.UserInfo;
import com.kses.backoffice.rsv.reservation.service.AttendInfoManageService;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.AttendInfo;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;
import com.kses.backoffice.rsv.reservation.vo.speedon;
import com.kses.backoffice.sym.log.service.InterfaceInfoManageService;
import com.kses.backoffice.sym.log.service.ParamToJson;
import com.kses.backoffice.sym.log.vo.InterfaceInfo;
import com.kses.backoffice.sym.log.vo.sendEnum;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.property.EgovPropertyService;
import com.popbill.api.CashbillService;
import com.popbill.api.PopbillException;
import com.popbill.api.Response;
import com.popbill.api.CBIssueResponse;
import com.popbill.api.cashbill.Cashbill;
import com.popbill.api.cashbill.CashbillInfo;

@RestController
@RequestMapping("/backoffice/rsv")
public class ResJosnController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ResJosnController.class);
	// ?????? front ??? ??????

	@Autowired
	EgovMessageSource egovMessageSource;

	@Autowired
	protected EgovPropertyService propertiesService;

	@Autowired
	protected UserInfoManageService userService;

	@Autowired
	private AttendInfoManageService attendService;

	@Autowired
	private ResvInfoManageService resService;

	@Autowired
	private InterfaceInfoManageService interfaceService;

	@Autowired
	private CashbillService cashbillService;
	
	@Autowired
	private UniSelectInfoManageService uniService;
	
	@Autowired
	private KioskInfoService kioskService;

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "speedCheck.do", method = { RequestMethod.POST })
	@Transactional
	public ModelAndView selectSpeedCheck(	@ModelAttribute("loginVO") LoginVO loginVO,
											@RequestBody Map<String, Object> sendInfo, HttpServletRequest request) {

		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			String Url = "";
			JsonNode node = null;

			String Message = "";
			String errorCd = "";

			JSONObject jsonObject = new JSONObject();
			for (Map.Entry<String, Object> entry : ((Map<String, Object>) sendInfo.get("sendInfo")).entrySet()) {
				String key = entry.getKey();
				Object value = entry.getValue();
				jsonObject.put(key, value);
			}

			if (SmartUtil.NVL(sendInfo.get("gubun"), "").toString().equals("login")) {
				Url = propertiesService.getString("speedOnUrl") + "user/userChk";

				String encryptType = "";
				String password = "";

				if ("1".equals(jsonObject.get("Login_Type").toString())) {
					encryptType = "SHA-512";
					password = jsonObject.get("User_Pw").toString();
					jsonObject.put("User_Pw", SmartUtil.encryptPassword(password, encryptType));
				} else {
					encryptType = "SHA-256";
					password = jsonObject.get("Card_Pw").toString();
					jsonObject.put("Card_Pw", SmartUtil.encryptPassword(password, encryptType));
				}

				node = SmartUtil.requestHttpJson(Url, jsonObject.toJSONString(), "SPEEDLOGIN", "SPEEDON", "KSES");
				errorCd = node.get("Error_Cd").asText();
				if (node.get("Error_Cd").asText().equals("SUCCESS")) {
					UserInfo user = new UserInfo();
					user.setUserBirthDy(node.get("User_Birth_Dy").asText());
					user.setUserSexMf(node.get("User_Sex_MF").asText());
					user.setUserPhone(node.get("User_Phone").asText());
					user.setUserNm(node.get("User_Nm").asText());
					user.setUserId(node.get("User_Id").asText());
					user.setUserDvsn("USER_DVSN_1");
					user.setUserCardNo(node.get("Card_No").asText());
					user.setUserCardId(node.get("Card_Id").asText());
					user.setUserCardSeq(node.get("Card_Seq").asText());
					user.setMode("Ins");
					
					userService.updateUserInfo(user);

					// ?????? ???????????? ???????????? ????????? ?????? ???????????? ??????
					model.addObject("userInfo", user);
				} else {
					for (speedon direction : speedon.values()) {
						if (direction.getCode().equals(node.get("Error_Cd").asText())) {
							Message = direction.getName();
						}
					}
				}
				
				model.addObject(Globals.STATUS, errorCd);
				model.addObject(Globals.STATUS_MESSAGE, Message);
				model.addObject(Globals.STATUS_REGINFO, node);
			
			} else if (SmartUtil.NVL(sendInfo.get("gubun"), "").toString().equals("fep")) {
				ModelMap result = interfaceService.SpeedOnPayMent(jsonObject.get("resvSeq").toString(), "", false);
				
				model.addObject(Globals.STATUS, result.get(Globals.STATUS));
				model.addObject(Globals.STATUS_MESSAGE, result.get(Globals.STATUS_MESSAGE));
				model.addObject(Globals.STATUS_REGINFO, result.get(Globals.STATUS_REGINFO));
			
			} else if (SmartUtil.NVL(sendInfo.get("gubun"), "").toString().equals("dep")) {
				ModelMap result = interfaceService.SpeedOnPayMentCancel(jsonObject.get("resvSeq").toString(), "", false, false);
				
				model.addObject(Globals.STATUS, result.get(Globals.STATUS));
				model.addObject(Globals.STATUS_MESSAGE, result.get(Globals.STATUS_MESSAGE));
				model.addObject(Globals.STATUS_REGINFO, result.get(Globals.STATUS_REGINFO));
			}
		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}

		return model;
	}

	// qr checkin ??????
	@RequestMapping(value = "qrReadCheck.do", method = { RequestMethod.POST })
	public ModelAndView selectQrCheckInfo(@RequestBody AttendInfo sendInfo, HttpServletRequest request) {

		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		AttendInfo attendInfoVO = new AttendInfo();
		
		try {
			String qrInfo = EgovFileScrty.decode(sendInfo.getQrCode());
			String qrCneterCd = sendInfo.getQrCneterCd(); // qr ?????? ??????
			String qrInot = sendInfo.getQrInot(); // qrIO ??????
			String qrCheck = sendInfo.getQrCode();
			
			String result = "";
			String ERROR_CD = "";
			String ERROR_MSG = "";
			String IOGUBUN = "";
			String USER_NM = "";
			String IOGUBUN_TXT = "";

			if (qrInfo.contains(":")) {
				String[] attempInfos = qrInfo.split(":");
				String resSeq = attempInfos[0];
				String qrTime = attempInfos[1];
				String inOt = attempInfos[2];
				String gubun = attempInfos[3];
				String userId = attempInfos[4];

				String centerPilotYn = attempInfos[5];
				String tradNo = attempInfos[6];
				String resvEntryDvsn = attempInfos[7];
				String resvPayCost = attempInfos[8];
				String center_rbm_cd = attempInfos[9];
				String inotMsg = attempInfos[10];

				String userPhone = attempInfos[11];
				String centerNm = attempInfos[12];
				String seatNm = attempInfos[13];
				String seatClassNm = attempInfos[14];
				String floorNm = attempInfos[15];
				String partNm = attempInfos[16];
				String resvQrCount = attempInfos[17];
				String formatedNow = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
				
				Map<String, Object> searchVO = new HashMap<String, Object>();
				String nowDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
				searchVO.put("resvSeq", resSeq);
				searchVO.put("resvDate", nowDate);
				
				Map<String, Object> doubleCheckVO = new HashMap<String, Object>();
				doubleCheckVO.put("resvSeq", SmartUtil.NVL(resSeq, "").toString());
				doubleCheckVO.put("qrCode", SmartUtil.NVL(qrCheck, "").toString());
				Map<String, Object> qrDoubleCheck = resService.selectQrDuplicate(doubleCheckVO);
				
				Map<String, Object> resInfo = resService.selectUserResvInfo(searchVO);
				
				if (!qrTime.substring(0, 8).equals(formatedNow.substring(0, 8))) {
					ERROR_CD = "ERROR_05";
					ERROR_MSG = "???????????? ??????.";
					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					return model;
				}
				
				String resvState = SmartUtil.NVL(resInfo.get("resv_state"),""); 
				if (resvState.equals("RESV_STATE_3") || resvState.equals("RESV_STATE_4")) {
					ERROR_CD = "ERROR_09";
					ERROR_MSG = "????????? ?????? ??????.";
					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					return model;
				}

				if (!gubun.equals("PAPER")) {
					if (!qrDoubleCheck.get("cnt").toString().equals("0")) {
						ERROR_CD = "ERROR_10";
						ERROR_MSG = "????????? ??????.";
						model.addObject("ERROR_CD", ERROR_CD);
						model.addObject("ERROR_MSG", ERROR_MSG);
						return model;
					}
				}
				// ?????? ??????
				if (Integer.valueOf(SmartUtil.timeCheck(qrTime)) < -30 && gubun.equals("INTERVAL")) {
					ERROR_CD = "ERROR_01";
					ERROR_MSG = "?????? ?????? ??????.";
					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					return model;
				}

				// ?????? ??????/??????
				if (centerPilotYn.equals("Y") && tradNo.equals("") && Integer.valueOf(resvPayCost) > 0) {
					ERROR_CD = "ERROR_04";
					ERROR_MSG = "????????? ?????? ??????.";
					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					return model;
				}
				
				if (!center_rbm_cd.equals(qrCneterCd)) {
					ERROR_CD = "ERROR_06";
					ERROR_MSG = "?????? ??????.";
					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					return model;
				}
				
				//??????QR????????? IN/OUT ??????
				if(gubun.equals("PAPER")) {
					attendInfoVO.setResvSeq(resSeq);
					attendInfoVO.setUserId(userId);
					Map<String, Object> attendInfo = attendService.selectAttendInfoDetail(attendInfoVO);
					
					if (attendInfo == null) {
						inOt = "IN";
					} else {
						inOt = "IN";
					}
				}
				
				if (!resvQrCount.equals(SmartUtil.NVL(resInfo.get("resv_qr_count"),""))) {
					ERROR_MSG = "QR???????????? ?????????";
					ERROR_CD = "ERROR_08";
					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					return model;	
				}

				if (!qrInot.equals(inOt)) {
					ERROR_MSG = qrInot.equals("IN") ? "?????? ?????? ??????." : "?????? ?????? ??????.";
					ERROR_CD = "ERROR_07";
					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					return model;	
				}
				
				sendInfo.setUserId(userId);
				sendInfo.setResvSeq(resSeq);
				sendInfo.setInoutDvsn(inOt);
				sendInfo.setRcvDt(formatedNow);
				sendInfo.setQrCheckTm(formatedNow);
				sendInfo.setRcvCd("OK");
				sendInfo.setQrCode(sendInfo.getQrCode());
				
				sendInfo = attendService.insertAttendInfo(sendInfo);
				IOGUBUN_TXT = inotMsg;
				
				if (sendInfo.getRcvCd().equals("OK")) {
					ERROR_CD = "OK";
					ERROR_MSG = "";
					IOGUBUN = inOt;
					USER_NM = sendInfo.getUserNm();

					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					model.addObject("IOGUBUN", IOGUBUN);
					model.addObject("USER_NM", USER_NM);
					model.addObject("SEATNM", seatNm);
					model.addObject("SEATCLASS", seatClassNm);
					// ????????? ??????
					if (userPhone.length() > 4) {
						userPhone = userPhone.substring(userPhone.length() - 4, userPhone.length());
					}
					model.addObject("USERPHONE", userPhone);
					model.addObject("CENTERNM", centerNm);
					model.addObject("FLOORNM", floorNm);
					model.addObject("PARTNM", partNm);
					model.addObject("INOTMSG", IOGUBUN_TXT);
					
					// ???????????? ????????? ?????? (?????? -> ??????)
					ResvInfo resvInfo = new ResvInfo();
					resvInfo.setResvSeq(resSeq);
					resvInfo.setResvState("RESV_STATE_2");
					resvInfo.setLastUpdusrId("SYSTEM");
					resService.updateResvState(resvInfo);

					return model;
				} else {
					String errorMessage = sendInfo.getRcvCd().equals("ERROR_02") ? "???/?????? ?????? ??????" : "????????? ??????";
					ERROR_CD = sendInfo.getRcvCd();
					ERROR_MSG = errorMessage;
					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					return model;
				}
			} else {
				ERROR_CD = "ERROR_03";
				ERROR_MSG = "????????? QR??????";
				model.addObject("ERROR_CD", ERROR_CD);
				model.addObject("ERROR_MSG", ERROR_MSG);
				return model;
			}
		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.error("selectQrCheckInfo error:" + e.toString() + ":" + lineNumber);
			model.addObject("ERROR_CD", "ERROR_02");
			model.addObject("ERROR_MSG", "????????? ??????");

		}
		return model;
	}

	// qr ??? ??????
	@RequestMapping(value = "qrSend.do")
	public ModelAndView selectQrSendInfo(@RequestParam("resvSeq") String resvSeq,
			@RequestParam("tickPlace") String tickPlace) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Map<String, Object> searchVO = new HashMap<String, Object>();
			String nowDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
			searchVO.put("resvSeq", resvSeq);
			searchVO.put("resvDate", nowDate);

			Map<String, Object> resInfo = resService.selectUserResvInfo(searchVO);
			String resvState = SmartUtil.NVL(resInfo.get("resv_state"), "");
			
			if(resInfo == null || Integer.valueOf(resInfo.get("resv_end_dt").toString()) < Integer.valueOf(nowDate)) {
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, "????????? ?????? ?????? ????????? ?????? ???????????? ?????????.");
				return model;
			} else if(resvState.toString().equals("RESV_STATE_4")) {
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, "?????? ????????? ???????????? ?????????.");
				return model;
			} else {
				AttendInfo vo = new AttendInfo();
				vo.setResvSeq(resvSeq);
				vo.setUserId(resInfo.get("user_id").toString());
				String qrTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
				String inOt = "";
				Map<String, Object> attend = attendService.selectAttendInfoDetail(vo);
				String inotMsg = "";
				if (attend == null) {
					inOt = "IN";
					inotMsg = "????????????";
				} else {
					inOt = "IN";
					inotMsg = "??????";
				}
				
				//QR???????????? ????????????
				resService.updateResvQrCount(resvSeq);

				String gubun = tickPlace.equals("ONLINE") ? "INTERVAL" : "PAPER";
				String qrCode = EgovFileScrty.encode(resvSeq + ":" + qrTime + ":" + inOt + ":" + gubun + ":"
						+ SmartUtil.NVL(resInfo.get("user_id"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("center_pilot_yn"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("trad_no"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("resv_entry_dvsn"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("resv_pay_cost"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("center_rbm_cd"), "").toString() + ":" + inotMsg + ":"
						+ SmartUtil.NVL(resInfo.get("user_phone"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("center_nm"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("seat_nm"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("seat_class"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("floor_nm"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("part_nm"), "").toString() + ":"
						+ String.valueOf(Integer.valueOf(SmartUtil.NVL(resInfo.get("resv_qr_count"), "0")) + 1));
				
				model.addObject("vacntnInfo", userService.selectUserVacntnInfo(resInfo.get("user_id").toString()));
				model.addObject("resvInfo", resInfo);
				model.addObject("QRCODE", qrCode);
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			}
		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}

	// ?????? ?????????
	@RequestMapping(value = "tickMachinRes.do")
	@Transactional
	public ModelAndView selectTickMachinRes(@RequestBody Map<String, Object> jsonInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		model.addObject("IF_NO", jsonInfo.get("IF_NO"));
		model.addObject("RES_NO", jsonInfo.get("RES_NO"));
		model.addObject("RETURN_DATE", jsonInfo.get("RETURN_DATE"));
		model.addObject("MACHINE_SERIAL", jsonInfo.get("MACHINE_SERIAL"));

		JSONObject jsonObject = new JSONObject();
		for (Map.Entry<String, Object> entry : jsonInfo.entrySet()) {
			String key = entry.getKey();
			Object value = entry.getValue();
			jsonObject.put(key, value);
		}

		String resName = "";
		String resPrice = "";
		String resDay = "";
		String resTime = "";
		String seatName = "";
		String resPersonCnt = "";
		String returnCode = "";
		String returnMessage = "";
		String userNm = "";
		String firstNm = "";
		String middleNm = "";
		String LastNm = "";
		String cnvMiddleNm = "";

		InterfaceInfo info = new InterfaceInfo();
		info.setTrsmrcvSeCode(sendEnum.RPQ.getCode());
		info.setIntegId("MACHINRES");
		info.setRequstSysId(SmartUtil.NVL(jsonInfo.get("IF_NO").toString(), "").toString());

		try {
			Map<String, Object> searchVO = new HashMap<String, Object>();
			String localTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
			String resvSeq = localTime + SmartUtil.NVL(jsonInfo.get("RES_NO"), "").toString();
			
			searchVO.put("resvDate", localTime);
			searchVO.put("resvSeq", resvSeq);
			String checkResvSeq = uniService.selectIdDoubleCheck("RESV_SEQ", "TSER_RESV_INFO_I", "RESV_SEQ = [" + resvSeq + "[") > 0 ? "OK" : "FAIL";
			if (checkResvSeq.equals("OK")) {
				Map<String, Object> resInfo = resService.selectUserResvInfo(searchVO);
				Map<String, Object> machineVO = new HashMap<String, Object>();
				machineVO.put("ticketMchnSno", SmartUtil.NVL(jsonInfo.get("MACHINE_SERIAL"), "").toString());
				machineVO.put("centerCd", SmartUtil.NVL(resInfo.get("center_cd"), "").toString());
				Map<String, Object> machineSerial = kioskService.selectTicketMchnSnoCheck(machineVO);
				
				String recDate = SmartUtil.NVL(jsonInfo.get("RES_SEND_DATE"), "19700101").toString();
				
				if(machineSerial.get("cnt").toString().equals("0")) {
					returnCode = "ERROR_03";
					returnMessage = "?????? ?????? ????????? ????????????. \n??????????????? ???????????? ????????????.";
				} else if (resInfo != null && !SmartUtil.NVL(resInfo.get("resv_pay_dvsn"), "").toString().equals("RESV_PAY_DVSN_1")) {
					returnCode = "ERROR_04";
					returnMessage = "?????? ????????? ?????? ???????????????.";
				} else {
					if (resInfo != null && SmartUtil.NVL(resInfo.get("resv_end_dt"), "").toString().equals(localTime) && recDate.substring(0, 8).equals(localTime)) {
						LOGGER.info(localTime);
						userNm = SmartUtil.NVL(resInfo.get("user_nm"), "").toString();
						resPrice = SmartUtil.NVL(resInfo.get("resv_pay_cost"), "").toString();
						resDay = SmartUtil.NVL(resInfo.get("resv_start_dt"), "").toString();
						resTime = SmartUtil.NVL(resInfo.get("resv_start_tm"), "").toString();
						seatName = SmartUtil.NVL(resInfo.get("seat_nm"), "").toString();
						resPersonCnt = "1";
						returnCode = "OK";
						
						if(userNm.length()>2) {
							firstNm = userNm.substring(0,1);
							middleNm = userNm.substring(1, userNm.length()-1);
							LastNm = userNm.substring(userNm.length()-1, userNm.length());
							cnvMiddleNm = "";
							for(int i=0; i<middleNm.length(); i++) {
								cnvMiddleNm +="*";
							}
							resName = firstNm + cnvMiddleNm + LastNm;
						} else if(userNm.length()==2){
							firstNm = userNm.substring(0,1);
							resName = firstNm + "*";
						} else {
							resName = userNm;
						}
					}
				}
			} else {
				returnCode = "ERROR_01";
				returnMessage = "?????? ?????? ??????.";
			}

			info.setTrsmrcvSeCode(sendEnum.RPS.getCode());
	
			info.setRequstSysId(SmartUtil.NVL(jsonInfo.get("MACHINE_SERIAL").toString(), "").toString());
			info.setRequstInsttId("MACHIN");
			info.setRequstTrnsmitTm(SmartUtil.NVL(jsonInfo.get("RES_SEND_DATE"), "").toString());
			info.setRspnsRecptnTm(SmartUtil.nowTime());
			info.setResultCode(returnCode);
			info.setSendMessage(jsonObject.toString());
			info.setRqesterId("SYSTEM");
		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.error("selectTickMachinRes error:" + e.toString() + ":" + lineNumber);
			returnCode = "ERROR_02";
			info.setRqesterId("SYSTEM");
			info.setResultCode(returnCode);
			returnMessage = "????????? ?????? ?????????.";
			info.setTrsmrcvSeCode(sendEnum.RPF.getCode());
		}
		
		model.addObject("RES_NAME", resName);
		model.addObject("RES_PRICE", resPrice);
		model.addObject("RES_DAY", resDay);
		model.addObject("RES_TIME", resTime);
		model.addObject("SEAT_NAME", seatName);
		model.addObject("RES_PERSON_CNT", resPersonCnt);
		model.addObject("RETURN_CODE", returnCode);
		model.addObject("RETURN_MESSAGE", returnMessage);

		// ??????????????? ??????
		info.setResultMessage(ParamToJson.paramToJson(model));
		interfaceService.InterfaceInsertLoginLog(info);

		return model;
	}

	@RequestMapping(value = "tickMachinQr.do")
	@Transactional
	public ModelAndView selectTickMachinPrice(@RequestBody Map<String, Object> jsonInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		model.addObject("IF_NO", jsonInfo.get("IF_NO"));
		model.addObject("RES_NO", jsonInfo.get("RES_NO"));
		model.addObject("RES_PRICE", jsonInfo.get("RES_PRICE"));
		model.addObject("RETURN_DATE", SmartUtil.nowTime());
		model.addObject("MACHINE_SERIAL", jsonInfo.get("MACHINE_SERIAL"));

		String resName = "";
		String resPrice = "";
		String resDay = "";
		String resTime = "";
		String seatName = "";
		String resQrUrl = "";
		String resPersonCnt = "";
		String returnCode = "";
		String returnMessage = "";
		String seatClass = "";
		String userPhone = "";
		String userPhoneBack4 = "";
		String partInitial = "";

		InterfaceInfo info = new InterfaceInfo();
		info.setTrsmrcvSeCode(sendEnum.RPQ.getCode());
		info.setIntegId("MACHINQR");
		info.setRequstSysId(SmartUtil.NVL(jsonInfo.get("IF_NO").toString(), "").toString());

		// ?????? ????????? ?????? ??????
		info.setRequstSysId(SmartUtil.NVL(jsonInfo.get("MACHINE_SERIAL").toString(), "").toString());
		info.setRqesterId("SYSTEM");

		try {
			Map<String, Object> searchVO = new HashMap<String, Object>();
			String localTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
			String resvSeq = localTime + SmartUtil.NVL(jsonInfo.get("RES_NO"), "").toString();
			searchVO.put("resvSeq", resvSeq);
			searchVO.put("resvDate", localTime);
			
			Map<String, Object> resInfo = resService.selectUserResvInfo(searchVO);
			
			LOGGER.debug("resvSeq : " + SmartUtil.NVL(resInfo.get("resv_seq"), "").toString() + 
					", resvUserDvsn : " + SmartUtil.NVL(resInfo.get("resv_user_dvsn"), "").toString() + 
					", centerNm : " + SmartUtil.NVL(resInfo.get("center_nm"), "").toString() + 
					", seatNm : " + SmartUtil.NVL(resInfo.get("seat_nm"), "").toString() + 
					", seatClass : " + SmartUtil.NVL(resInfo.get("seat_class"), "").toString() + 
					", resvEndDt : " + SmartUtil.NVL(resInfo.get("resv_end_dt"), "").toString() + 
					", userId : " + SmartUtil.NVL(resInfo.get("user_id"), "").toString() +
					", userNm : " + SmartUtil.NVL(resInfo.get("user_nm"), "").toString() +
					", resvPayCost : " + SmartUtil.NVL(resInfo.get("resv_pay_cost"), "").toString());
			
			String recDate = SmartUtil.NVL(jsonInfo.get("RES_SEND_DATE"), "19700101").toString();
			String qrTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
			
			if (resInfo == null || !recDate.substring(0, 8).equals(localTime)) {
				returnCode = "ERROR_01";
				returnMessage = "?????? ?????? ??????.";
			} else if (resInfo != null && !SmartUtil.NVL(jsonInfo.get("RES_PRICE"), "").toString().equals(SmartUtil.NVL(resInfo.get("resv_pay_cost"), "").toString())) {
				returnCode = "ERROR_03";
				returnMessage = "?????? ?????? ?????? ??????.";
			} else if (resInfo != null && !SmartUtil.NVL(resInfo.get("resv_pay_dvsn"), "").toString().equals("RESV_PAY_DVSN_1")) {
				returnCode = "ERROR_04";
				returnMessage = "?????? ????????? ?????? ???????????????.";
			} else {
				resName = SmartUtil.NVL(resInfo.get("user_nm"), "").toString();
				resPrice = SmartUtil.NVL(resInfo.get("resv_pay_cost"), "").toString();
				resDay = SmartUtil.NVL(resInfo.get("resv_end_dt"), "").toString();
				resTime = SmartUtil.NVL(resInfo.get("resv_start_tm"), "").toString();
				seatClass = SmartUtil.NVL(resInfo.get("seat_class"), "").toString();
				userPhone = SmartUtil.NVL(resInfo.get("user_phone"), "").toString();
				userPhoneBack4 = userPhone.substring(userPhone.length()-4,userPhone.length());
				partInitial = SmartUtil.NVL(resInfo.get("part_initial"), "").toString();
				// TO-DO ???/????????? ?????? ??????
				
				//QR???????????? ????????????
				resService.updateResvQrCount(resvSeq);
				
				String qrCode = EgovFileScrty.encode(resInfo.get("resv_seq") + ":" + qrTime
						+ ":IN:PAPER:" + SmartUtil.NVL(resInfo.get("user_id"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("center_pilot_yn"), "").toString() + ":"
						+ SmartUtil.NVL(jsonInfo.get("IF_NO"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("resv_entry_dvsn"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("resv_pay_cost"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("center_rbm_cd"), "").toString() + "::" 
						+ SmartUtil.NVL(resInfo.get("user_phone"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("center_nm"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("seat_nm"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("seat_class"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("floor_nm"), "").toString() + ":"
						+ SmartUtil.NVL(resInfo.get("part_nm"), "").toString() + ":"
						+ String.valueOf(Integer.valueOf(SmartUtil.NVL(resInfo.get("resv_qr_count"), "0")) + 1));
				resQrUrl = qrCode;
				seatName = SmartUtil.NVL(resInfo.get("seat_nm"), "").toString();
				resPersonCnt = "1";
				returnCode = "OK";

				ResvInfo resInfoU = new ResvInfo();

				resInfoU.setTradNo(SmartUtil.NVL(jsonInfo.get("IF_NO"), "").toString());
				resInfoU.setResvPayDvsn("RESV_PAY_DVSN_2");
				resInfoU.setResvTicketDvsn("RESV_TICKET_DVSN_2");
				resInfoU.setResvSeq(resvSeq);
				
				// SPDM???????????? ?????????????????? ??????????????? ????????? ???????????? '??????' -> '?????????' ?????? ??????
				if(resInfo.get("center_cd").equals("C21110401")) {
					resInfoU.setResvState("RESV_STATE_2");
				}
				
				int ret = resService.updateResvPriceInfo(resInfoU);
				if (ret > 0) {
					returnCode = "OK";
				} else {
					returnCode = "ERROR_02";
					returnMessage = "????????? ?????? ?????????.";
				}
			}

			// ??????????????? ??????`

			info.setRequstInsttId("MACHIN");
			info.setRspnsRecptnTm(SmartUtil.nowTime());
			info.setRequstTrnsmitTm(SmartUtil.NVL(jsonInfo.get("RES_SEND_DATE"), "").toString());
			info.setResultCode(returnCode);
			info.setResultMessage(model.toString());
			info.setSendMessage(jsonInfo.toString());

			// ?????? ?????? ??????

		} catch (Exception e) {
			LOGGER.error("selectTickMachinPrice error:" + e.toString());
			returnCode = "ERROR_02";
			// ????????? ?????? ??? ??????
			info.setResultCode(returnCode);
			returnMessage = "????????? ?????? ?????????.";
		}

		model.addObject("RES_NAME", resName);
		model.addObject("RES_PRICE", resPrice);
		model.addObject("RES_DAY", resDay);
		model.addObject("RES_TIME", resTime);
		model.addObject("SEAT_NAME", seatName);
		model.addObject("RES_QR_URL", resQrUrl);
		model.addObject("RES_PERSON_CNT", resPersonCnt);
		model.addObject("RETURN_CODE", returnCode);
		model.addObject("RETURN_MESSAGE", returnMessage);
		model.addObject("SEAT_CLASS", seatClass);
		model.addObject("USER_PHONE", userPhoneBack4);
		model.addObject("PART_INITIAL", partInitial);
		
		info.setResultMessage(ParamToJson.paramToJson(model));
		interfaceService.InterfaceInsertLoginLog(info);

		return model;
	}

	// ?????? ?????????
	@RequestMapping(value="billPrint.do")
	public ModelAndView selectPopBillInfo(	@RequestParam("resvSeq") String resvSeq) throws Exception {
											
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Map<String, Object> resvInfo = resService.selectResvInfoDetail(resvSeq);
			Map<String, Object> billInfo = resService.selectResvBillInfo(resvSeq);
			
			if(billInfo == null) {
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, "?????? ??????(??????)??? ????????? ??????????????? ?????? ????????? ????????????.");
				return model;
			}
			
			String resvRcptState = SmartUtil.NVL(resvInfo.get("resv_rcpt_state"), "");
			if(resvRcptState.equals("")) {
				resvRcptState = "RESV_RCPT_STATE_1";
			} else {
				resvRcptState = resvRcptState.equals("RESV_RCPT_STATE_1") ? "RESV_RCPT_STATE_2" : "RESV_RCPT_STATE_1"; 
			}
			
			// ?????? ??????????????? ??????
			String corpNum = SmartUtil.NVL(billInfo.get("bill_num"), "");
			String tel = SmartUtil.NVL(billInfo.get("bill_tel"), "");
			String addr = SmartUtil.NVL(billInfo.get("bill_addr"), "");
			String corpName = SmartUtil.NVL(billInfo.get("bill_corp_name"), "");
			String ceoName = SmartUtil.NVL(billInfo.get("bill_ceo_name"), "");
			String userId = SmartUtil.NVL(billInfo.get("bill_user_id"), "");
			
			// ?????? ??????????????? ??????
			String mgtKey = "";
			String delMgtKey = "";
			String memo = "";
			String tradeType = "";
			String orgConfirmNum = "";
			String orgTradeDate = "";
			
			if(resvRcptState.equals("RESV_RCPT_STATE_1")) {
				mgtKey = resvSeq + "_001";
				delMgtKey = resvSeq + "_002";
				tradeType = "????????????";
				memo = "??????????????? ???????????? ??????";
			} else {
				mgtKey = resvSeq + "_002";
				delMgtKey = resvSeq + "_001";
				tradeType = "????????????";
				memo = "??????????????? ???????????? ??????";
				orgConfirmNum = cashbillService.getInfo(corpNum, delMgtKey).getOrgConfirmNum();
				orgTradeDate = cashbillService.getInfo(corpNum, delMgtKey).getOrgConfirmNum();
			}
			
			// ??????????????? ?????? ??????
			Cashbill cashbill = new Cashbill();
			
			// ????????????, ?????? 24??????, ??????, ?????? '-', '_'??? ??????
			cashbill.setMgtKey(mgtKey);

			// ????????????, {????????????, ????????????} ??? ??????
			cashbill.setTradeType(tradeType);

			// ??????????????? ??????, ?????? ??????????????? ????????? ???????????? - getInfo API??? ?????? confirmNum ??? ??????
			cashbill.setOrgConfirmNum(orgConfirmNum);

			// ??????????????? ??????, ?????? ??????????????? ???????????? - getInfo API??? ?????? tradeDate ??? ??????
			cashbill.setOrgTradeDate(orgTradeDate);

			// ????????????, {??????, ?????????} ??? ??????
			cashbill.setTaxationType("??????");

			// ????????? ????????????, ??????????????? ?????? ??????
			// ??????????????? - ????????????/?????????/???????????? ????????????
			// ??????????????? - ???????????????/????????????/?????????/???????????? ????????????
			cashbill.setIdentityNum(SmartUtil.NVL(resvInfo.get("resv_rcpt_tel"), "").toString());

			// ????????????, {???????????????, ???????????????} ??? ??????
			cashbill.setTradeUsage(SmartUtil.NVL(resvInfo.get("resv_rcpt_dvsn_text"), "???????????????").toString());

			// ????????????, {??????, ????????????, ????????????} ??? ??????
			cashbill.setTradeOpt("??????");

			int payAmt = Integer.valueOf(SmartUtil.NVL(resvInfo.get("resv_pay_cost"), "0").toString());
			int payCost = 0;
			int payTxt = 0;
            
			//?????????
			if (payAmt > 0) {
				payCost = ((payAmt / 11) * 10);
				payTxt = payAmt - payCost;
			}
			
			// ????????????, ????????? ??????
			cashbill.setSupplyCost(String.valueOf(payCost));
			
			// ?????????, ????????? ??????
			cashbill.setTax(String.valueOf(payTxt));

			// ????????????, ????????? ??????, ????????? + ???????????? + ?????????
			cashbill.setTotalAmount(String.valueOf(payAmt));
			// ?????????, ????????? ??????
			cashbill.setServiceFee("0");

			// ????????? ???????????????, '-'?????? 10??????
			cashbill.setFranchiseCorpNum(corpNum);

			// ????????? ??????
			cashbill.setFranchiseCorpName(corpName);

			// ????????? ????????????
			cashbill.setFranchiseCEOName(ceoName);

			// ????????? ??????
			cashbill.setFranchiseAddr(addr);

			// ????????? ?????????
			cashbill.setFranchiseTEL(tel);

			// ???????????? ?????? ????????????
			cashbill.setSmssendYN(false);
			
			// ????????? ?????????
			cashbill.setCustomerName(SmartUtil.NVL(resvInfo.get("user_nm"), "0").toString());

			// ????????? ???????????????
			cashbill.setItemName(SmartUtil.NVL(resvInfo.get("seat_nm"), "?????????").toString());

			// ????????? ????????????
			cashbill.setOrderNumber(resvSeq);

			// ????????? ?????????
			// ?????? ?????????????????? ??????????????? ???????????? ?????? ????????? ???????????????,
			// ?????? ???????????? ??????????????? ???????????? ????????? ??????
			cashbill.setEmail("");
			// ????????? ?????????
			cashbill.setHp(SmartUtil.NVL(resvInfo.get("user_phone"), "").toString());

			ResvInfo info = new ResvInfo();
			String resvRcptNumber = "";
			if(resvRcptState.equals("RESV_RCPT_STATE_1")) {
				CBIssueResponse response = cashbillService.registIssue(corpNum, cashbill, memo, userId);
				resvRcptNumber = response.getConfirmNum();
				LOGGER.info(resvRcptNumber);
				model.addObject("popBill", response);
				model.addObject(Globals.STATUS_MESSAGE, "??????????????? ?????? ??????");
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				LOGGER.info("???????????? : " + resvSeq + "??????????????? ??????  ??????");
			} else {
				Response response =	cashbillService.cancelIssue(corpNum, delMgtKey, memo, userId);
				model.addObject("popBill", response);
				model.addObject(Globals.STATUS_MESSAGE, "??????????????? ?????? ?????? ??????");
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				LOGGER.info("???????????? : " + resvSeq + "??????????????? ?????? ?????? ??????");
			}
			
			// ?????? ????????? ?????? ??????
			info.setResvSeq(resvSeq);
			info.setResvRcptState(resvRcptState);
			info.setResvRcptNumber(resvRcptNumber);
			resService.resvBillChange(info);
			
			// KSES???????????? ??????????????? ????????????
			// ???????????? : ???????????? + _001 / ???????????? : ???????????? + _002 
			// ????????? ??? ????????? ?????? ???????????? ???????????? ?????? ??????????????? ??????
			if(cashbillService.checkMgtKeyInUse(corpNum, delMgtKey)) {
				cashbillService.delete(corpNum, delMgtKey);
				LOGGER.info("??????????????? ?????? ?????? ??????");
			}
		} catch (PopbillException e) {
			// ?????? ?????? ???, e.getCode() ??? ?????? ????????? ????????????, e.getMessage()??? ?????? ???????????? ???????????????.
			LOGGER.error("?????? ??????" + e.getCode());
			LOGGER.error("?????? ?????????" + e.getMessage());

			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.error("selectPopBillInfo error:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, e.getCode() + ":" + e.getMessage());
		}

		return model;
	}
	
	// ?????? ?????????
	@RequestMapping(value="billState.do")
	public ModelAndView selectPopBillStateInfo(	@RequestParam("resvSeq") String resvSeq) throws Exception {

		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Map<String, Object> resvInfo = resService.selectResvInfoDetail(resvSeq);
			Map<String, Object> billInfo = resService.selectResvBillInfo(resvSeq);
			
			if(SmartUtil.NVL(resvInfo.get("resv_rcpt_state"),"").equals("")) {	
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, "??????????????? ?????? ????????? ???????????? .");
				return model;
			} else if(billInfo == null) {
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, "?????? ????????? ????????? ??????????????? ?????? ????????? ???????????? .");
				return model;
			}
			
			String corpNum = SmartUtil.NVL(billInfo.get("bill_num"), "");
			String mgtKey = SmartUtil.NVL(resvInfo.get("resv_rcpt_state"), "").equals("RESV_RCPT_STATE_1") ? resvSeq + "_001" : resvSeq + "_002";
			CashbillInfo cashBillInfo = cashbillService.getInfo(corpNum, mgtKey);
			
			model.addObject("cashBillInfo", cashBillInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch (PopbillException e) {
			// ?????? ?????? ???, e.getCode() ??? ?????? ????????? ????????????, e.getMessage()??? ?????? ???????????? ???????????????.
			LOGGER.error("?????? ??????" + e.getCode());
			LOGGER.error("?????? ?????????" + e.getMessage());

			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.error("selectPopBillInfo error:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, e.getCode() + ":" + e.getMessage());
		}

		return model;
	}
}