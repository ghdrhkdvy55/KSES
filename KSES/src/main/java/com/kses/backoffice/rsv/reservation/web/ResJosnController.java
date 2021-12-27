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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.JsonNode;
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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.property.EgovPropertyService;
import com.popbill.api.CashbillService;
import com.popbill.api.PopbillException;
import com.popbill.api.CBIssueResponse;
import com.popbill.api.cashbill.Cashbill;

@RestController
@RequestMapping("/backoffice/rsv")
public class ResJosnController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ResJosnController.class);
	// 추후 front 로 이동

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

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "speedCheck.do", method = { RequestMethod.POST })
	public ModelAndView selectPreOpenInfo(@ModelAttribute("loginVO") LoginVO loginVO,
			@RequestBody Map<String, Object> sendInfo, HttpServletRequest request) {

		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			// 값 넣기
			String Url = "";
			JsonNode node = null;
			// _requstId
			//
			String Message = "";
			String errorCd = "";

			JSONObject jsonObject = new JSONObject();
			for (Map.Entry<String, Object> entry : ((Map<String, Object>) sendInfo.get("sendInfo")).entrySet()) {
				String key = entry.getKey();
				Object value = entry.getValue();
				jsonObject.put(key, value);
			}

			if (SmartUtil.NVL(sendInfo.get("gubun"), "").toString().equals("login")) {
				Url = propertiesService.getString("sppeedUrl_T") + "user/userChk";

				// 스피드온 패스워드 암호화(임시)
				// Login_Type -> 1 = SHA-512 + Base64 : 2 = SHA-256 + Base64
				String encryptType = "";
				String password = "";

				if ("1".equals(jsonObject.get("Login_Type").toString())) {
					encryptType = "SHA-512";
					password = jsonObject.get("User_Pw").toString();
					jsonObject.put("User_Pw", SmartUtil.encryptPassword(password, encryptType));
					LOGGER.debug("1 : " + SmartUtil.encryptPassword(password, encryptType));
				} else {
					encryptType = "SHA-256";
					password = jsonObject.get("Card_Pw").toString();
					jsonObject.put("Card_Pw", SmartUtil.encryptPassword(password, encryptType));
					LOGGER.debug("2 : " + SmartUtil.encryptPassword(password, encryptType));
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
					user.setUserCardNo(node.get("Card_Id").asText());
					user.setUserCardId(node.get("Card_No").asText());
					user.setUserCardSeq(node.get("Card_Seq").asText());

					user.setMode("Ins");
					userService.updateUserInfo(user);

					// 최초 로그인시 개인정보 동의를 위한 고객정보 전송
					model.addObject("userInfo", user);
				} else {
					for (speedon direction : speedon.values()) {
						if (direction.getCode().equals(node.get("Error_Cd").asText())) {
							Message = direction.getName();
						}
					}
				}
			} else if (SmartUtil.NVL(sendInfo.get("gubun"), "").toString().equals("fep")) {
				// 출금 정보
				Url = propertiesService.getString("sppeedUrl_T") + "trade/fepWithdraw";

				Map<String, Object> resvInfo = resService.selectUserResvInfo(jsonObject);

				jsonObject.put("System_Type", "E");
				jsonObject.put("External_Key", resvInfo.get("resv_seq"));
				jsonObject.put("Card_Id", resvInfo.get("user_card_id"));
				jsonObject.put("Card_Pw", SmartUtil.encryptPassword(jsonObject.get("Card_Pw").toString(), "SHA-256"));
				jsonObject.put("Card_Seq", resvInfo.get("user_card_seq"));
				jsonObject.put("Div_Cd", resvInfo.get("center_speed_cd"));
				jsonObject.put("Pw_YN", "Y");

				if (resvInfo.get("resv_entry_dvsn").equals("ENTRY_DVSN_1")) {
					jsonObject.put("Pay_Type", "001");
					jsonObject.put("Trade_Cd", "20A61");
					jsonObject.put("Trade_Detail", "입장시스템 입장료 출금");
				} else {
					jsonObject.put("Pay_Type", "003");
					jsonObject.put("Trade_Cd", "20A63");
					jsonObject.put("Trade_Detail", "입장시스템 입장/좌석 이용료 출금");
				}

				jsonObject.put("Trade_Pay", resvInfo.get("resv_pay_cost").toString());

				node = SmartUtil.requestHttpJson(Url, jsonObject.toJSONString(), "SPEEDWITHDRAW", "SPEEDON", "KSES");
				if (node.get("Error_Cd").asText().equals("SUCCESS")) {
					// 예약 테이블 출금 정보 처리 하기
					ResvInfo resInfo = new ResvInfo();
					resInfo.setResvSeq(SmartUtil.NVL(resvInfo.get("resv_seq"), "").toString());
					resInfo.setResvState("RESV_STATE_2");
					resInfo.setResvPayDvsn("RESV_PAY_DVSN_2");
					resInfo.setTradNo(node.get("Trade_No").asText());

					resService.resPriceChange(resInfo);
				} else {
					for (speedon direction : speedon.values()) {
						if (direction.getCode().equals(node.get("Error_Cd").asText())) {
							Message = direction.getName();
						}
					}
				}
			} else if (SmartUtil.NVL(sendInfo.get("gubun"), "").toString().equals("Inf")) {
				Url = propertiesService.getString("sppeedUrl_T") + "trade/schTradeInfo";
				node = SmartUtil.requestHttpJson(Url, jsonObject.toJSONString(), "SPEEDSCHTRADEINFO", "SPEEDON",
						"KSES");
				if (node.get("Error_Cd").asText().equals("SUCCESS")) {
					// 예약 테이블 취소 정보 처리 하기

				} else {
					for (speedon direction : speedon.values()) {
						if (direction.getCode().equals(node.get("Error_Cd").asText())) {
							Message = direction.getName();
						}
					}
				}
			} else if (SmartUtil.NVL(sendInfo.get("gubun"), "").toString().equals("dep")) {
				// 취소 정보
				Url = propertiesService.getString("sppeedUrl_T") + "trade/fepDeposit";
				Map<String, Object> resvInfo = resService.selectUserResvInfo(jsonObject);

				jsonObject.put("System_Type", "E");
				jsonObject.put("External_Key", resvInfo.get("resv_seq"));
				jsonObject.put("Card_Id", resvInfo.get("user_card_id"));
				jsonObject.put("Card_Pw", SmartUtil.encryptPassword(jsonObject.get("Card_Pw").toString(), "SHA-256"));
				jsonObject.put("Pw_YN", "Y");
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
				if (node.get("Error_Cd").asText().equals("SUCCESS")) {
					// 예약 테이블 취소 정보 처리 하기
					ResvInfo resInfo = new ResvInfo();
					resInfo.setResvSeq(SmartUtil.NVL(sendInfo.get("resvSeq"), "").toString());
					resInfo.setResvPayDvsn("RESV_PAY_DVSN_3");
					resInfo.setResvPayDvsn("RESV_STATE_4");
					resInfo.setTradNo(node.get("Trade_No").asText());
					resService.resPriceChange(resInfo);

				} else {
					for (speedon direction : speedon.values()) {
						if (direction.getCode().equals(node.get("Error_Cd").asText())) {
							Message = direction.getName();
						}
					}
				}
			}
			model.addObject(Globals.STATUS, errorCd);
			model.addObject(Globals.STATUS_MESSAGE, Message);
			model.addObject(Globals.STATUS_REGINFO, node);
		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}

		return model;
	}

	// qr checkin 검토
	@RequestMapping(value = "qrReadCheck.do", method = { RequestMethod.POST })
	public ModelAndView selectQrCheckInfo(@RequestBody AttendInfo sendInfo, HttpServletRequest request) {

		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			EgovFileScrty fileScrty = new EgovFileScrty();

			String qrInfo = fileScrty.decode(sendInfo.getQrCode());
			String qrCneterCd = sendInfo.getQrCneterCd(); // qr 지점 정보
			String qrInot = sendInfo.getQrInot(); // qrIO 구분
			LOGGER.debug("qrInfo:" + qrInfo);

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

				for (String value : attempInfos) {
					LOGGER.debug("value : " + value);
				}

				String formatedNow = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));

				LOGGER.debug("qrTime:" + qrTime.substring(0, 8));
				LOGGER.debug("formatedNow:" + formatedNow);

				if (!qrTime.substring(0, 8).equals(formatedNow.substring(0, 8))) {
					ERROR_CD = "ERROR_05";
					ERROR_MSG = "예약일자 오류.";
					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					return model;
				}

				// 시간 비교
				if (Integer.valueOf(SmartUtil.timeCheck(qrTime)) < -30 && gubun.equals("INTERVAL")) {
					ERROR_CD = "ERROR_01";
					ERROR_MSG = "생성 시간 초과.";
					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					return model;
				}

				// 현재 날짜/시간
				if (centerPilotYn.equals("Y") && !tradNo.equals("") && Integer.valueOf(resvPayCost) > 0) {
				// 결제 먼저 하기

				} else {
					ERROR_CD = "ERROR_04";
					ERROR_MSG = "이용료 결제 필요.";
					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					return model;

				}
				if (!center_rbm_cd.equals(qrCneterCd)) {
					ERROR_CD = "ERROR_06";
					ERROR_MSG = "장소 오류.";
					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					return model;
				}
				if (!qrInot.equals(inOt)) {
					ERROR_CD = "ERROR_07";
					ERROR_MSG = "퇴장 정보 없음.";
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

				LOGGER.debug("rcvCd : " + sendInfo.getRcvCd());

				if (sendInfo.getRcvCd().equals("OK")) {
					ERROR_CD = "OK";
					ERROR_MSG = "";
					IOGUBUN = inOt;
					USER_NM = sendInfo.getUserNm();

					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					model.addObject("IOGUBUN", IOGUBUN);
					model.addObject("USER_NM", USER_NM);
					model.addObject("CENTER_NM", USER_NM);
					model.addObject("SEATNM", seatNm);
					model.addObject("SEATCLASS", seatClassNm);
					// 자리수 수정
					if (userPhone.length() > 4) {
						userPhone = userPhone.substring(userPhone.length() - 4, userPhone.length());
					}
					model.addObject("USERPHONE", userPhone);
					model.addObject("CENTERNM", centerNm);
					model.addObject("FLOORNM", floorNm);
					model.addObject("PARTNM", partNm);
					model.addObject("INOTMSG", IOGUBUN_TXT);
					
					// 예약정보 상태값 변경 (예약 -> 이용)
					ResvInfo resvInfo = new ResvInfo();
					resvInfo.setResvSeq(resSeq);
					resvInfo.setResvState("RESV_STATE_2");
					resService.resvStateChange(resvInfo);

					return model;
				} else {
					String errorMessage = sendInfo.getRcvCd().equals("ERROR_02") ? "입/출입 잘못 시도" : "시스템 에러";
					ERROR_CD = sendInfo.getRcvCd();
					ERROR_MSG = errorMessage;
					model.addObject("ERROR_CD", ERROR_CD);
					model.addObject("ERROR_MSG", ERROR_MSG);
					return model;
				}
			} else {
				ERROR_CD = "ERROR_03";
				ERROR_MSG = "시스템 에러.";
				model.addObject("ERROR_CD", ERROR_CD);
				model.addObject("ERROR_MSG", ERROR_MSG);
				return model;
			}
		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.error("selectQrCheckInfo error:" + e.toString() + ":" + lineNumber);
			model.addObject("ERROR_CD", "ERROR_02");
			model.addObject("ERROR_MSG", "시스템 에러");

		}
		return model;
	}

	// qr 새 전송
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

			if (resInfo == null || Integer.valueOf(resInfo.get("resv_end_dt").toString()) < Integer.valueOf(nowDate)) {
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, "잘못된 예약 번호 이거나 지난 예약번호 입니다.");
			} else if (SmartUtil.NVL(resInfo.get("resv_state"), "").toString().equals("RESV_STATE_4")) {
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, "예약 취소된 예약 번호 입니다.");
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
					inotMsg = "입장기록 없음";
				} else {
					inOt = SmartUtil.NVL(attend.get("inout_dvsn"), "OT").toString().equals("IN") ? "OT" : "IN";
					inotMsg = (attend.size() > 2) ? "재입장" : "정상";
				}

				EgovFileScrty fileScrty = new EgovFileScrty();
				String gubun = tickPlace.equals("ONLINE") ? "INTERVAL" : "PAPER";

				String qrCode = fileScrty.encode(resvSeq + ":" + qrTime + ":" + inOt + ":" + gubun + ":"
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
						+ SmartUtil.NVL(resInfo.get("part_nm"), "").toString());
				fileScrty = null;

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

	// 무인 발권기
	@RequestMapping(value = "tickMachinRes.do")
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

		InterfaceInfo info = new InterfaceInfo();
		info.setTrsmrcvSeCode(sendEnum.RPQ.getCode());
		info.setIntegId("MACHINRES");
		info.setRequstSysId(SmartUtil.NVL(jsonInfo.get("IF_NO").toString(), "").toString());

		try {

			Map<String, Object> searchVO = new HashMap<String, Object>();
			LOGGER.debug("RES_NO:" + jsonInfo.get("RES_NO"));
			searchVO.put("resvSeq", SmartUtil.NVL(jsonInfo.get("RES_NO"), "").toString());
			String localTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
			searchVO.put("resvDate", localTime);
			Map<String, Object> resInfo = resService.selectUserResvInfo(searchVO);

			String recDate = SmartUtil.NVL(jsonInfo.get("RES_SEND_DATE"), "19700101").toString();

			if (resInfo != null && SmartUtil.NVL(resInfo.get("resv_end_dt"), "").toString().equals(localTime)
					&& recDate.substring(0, 8).equals(localTime)) {
				LOGGER.info(localTime);
				resName = SmartUtil.NVL(resInfo.get("user_nm"), "").toString();
				resPrice = SmartUtil.NVL(resInfo.get("resv_pay_cost"), "").toString();
				resDay = SmartUtil.NVL(resInfo.get("resv_start_dt"), "").toString();
				resTime = SmartUtil.NVL(resInfo.get("resv_start_tm"), "").toString();
				seatName = SmartUtil.NVL(resInfo.get("seat_nm"), "").toString();
				resPersonCnt = "1";
				returnCode = "OK";
			} else {
				returnCode = "ERROR_01";
				returnMessage = "예약 정보 없음.";
			}

			info.setTrsmrcvSeCode(sendEnum.RPS.getCode());

			info.setRequstSysId(SmartUtil.NVL(jsonInfo.get("MACHINE_SERIAL").toString(), "").toString());
			info.setRequstInsttId("MACHIN");
			info.setRequstTrnsmitTm(SmartUtil.NVL(jsonInfo.get("RES_SEND_DATE"), "").toString());
			info.setRspnsRecptnTm(SmartUtil.nowTime());

			LOGGER.debug("returnCode:" + returnCode);

			info.setResultCode(returnCode);

			info.setSendMessage(jsonObject.toString());
			info.setRqesterId("admin");

		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.error("selectTickMachinRes error:" + e.toString() + ":" + lineNumber);
			returnCode = "ERROR_02";
			info.setRqesterId("admin");
			info.setResultCode(returnCode);
			returnMessage = "시스템 에러 입니다.";
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

		// 인터페이스 연계
		info.setResultMessage(ParamToJson.paramToJson(model));
		interfaceService.InterfaceInsertLoginLog(info);

		return model;
	}

	@RequestMapping(value = "tickMachinQr.do")
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

		InterfaceInfo info = new InterfaceInfo();
		info.setTrsmrcvSeCode(sendEnum.RPQ.getCode());
		info.setIntegId("MACHINQR");
		info.setRequstSysId(SmartUtil.NVL(jsonInfo.get("IF_NO").toString(), "").toString());

		// 제품 시리얼 정보 추가
		info.setRequstSysId(SmartUtil.NVL(jsonInfo.get("MACHINE_SERIAL").toString(), "").toString());
		info.setRqesterId("admin");

		try {
			Map<String, Object> searchVO = new HashMap<String, Object>();
			searchVO.put("resvSeq", SmartUtil.NVL(jsonInfo.get("RES_NO"), "").toString());
			searchVO.put("resvDate", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")));
			Map<String, Object> resInfo = resService.selectUserResvInfo(searchVO);
			String localTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
			String recDate = SmartUtil.NVL(jsonInfo.get("RES_SEND_DATE"), "19700101").toString();

			LOGGER.debug(Integer.valueOf(SmartUtil.NVL(jsonInfo.get("RES_PRICE"), "").toString()) + ":"
					+ Integer.valueOf(SmartUtil.NVL(resInfo.get("resv_pay_cost"), "").toString()));
			if (resInfo == null || !recDate.substring(0, 8).equals(localTime)) {
				returnCode = "ERROR_01";
				returnMessage = "예약 정보 없음.";
			} else if (resInfo != null && !SmartUtil.NVL(jsonInfo.get("RES_PRICE"), "").toString()
					.equals(SmartUtil.NVL(resInfo.get("resv_pay_cost"), "").toString())) {
				returnCode = "ERROR_03";
				returnMessage = "결제 금액 확인 요망.";
			} else {
				resName = SmartUtil.NVL(resInfo.get("user_nm"), "").toString();
				resPrice = SmartUtil.NVL(resInfo.get("resv_pay_cost"), "").toString();
				resDay = SmartUtil.NVL(resInfo.get("resv_start_dt"), "").toString();
				resTime = SmartUtil.NVL(resInfo.get("resv_start_tm"), "").toString();
				seatClass = SmartUtil.NVL(resInfo.get("seat_class"), "").toString();
				userPhone = SmartUtil.NVL(resInfo.get("user_phone"), "").toString();
				userPhoneBack4 = userPhone.substring(userPhone.length()-4,userPhone.length());
				
				EgovFileScrty fileScrty = new EgovFileScrty();
				String qrCode = fileScrty.encode(resInfo.get("resv_seq") + ":" + resInfo.get("resv_start_dt")
						+ ":IN:PAPER:" + SmartUtil.NVL(resInfo.get("user_id"), "").toString());
				fileScrty = null;

				resQrUrl = qrCode;
				seatName = SmartUtil.NVL(resInfo.get("seat_nm"), "").toString();
				resPersonCnt = "1";
				returnCode = "OK";

				ResvInfo resInfoU = new ResvInfo();

				resInfoU.setTradNo(SmartUtil.NVL(jsonInfo.get("IF_NO"), "").toString());
				resInfoU.setResvPayDvsn("RESV_PAY_DVSN_2");
				resInfoU.setResvSeq(SmartUtil.NVL(jsonInfo.get("RES_NO"), "").toString());

				int ret = resService.resPriceChange(resInfoU);
				if (ret > 0) {
					returnCode = "OK";

				} else {
					returnCode = "ERROR_02";
					returnMessage = "시스템 에러 입니다.";
				}

			}

			// 인터페이스 연계`

			info.setRequstInsttId("MACHIN");
			info.setRspnsRecptnTm(SmartUtil.nowTime());
			info.setRequstTrnsmitTm(SmartUtil.NVL(jsonInfo.get("RES_SEND_DATE"), "").toString());
			info.setResultCode(returnCode);
			info.setResultMessage(model.toString());
			info.setSendMessage(jsonInfo.toString());

			// 결제 로직 타기

		} catch (Exception e) {
			LOGGER.error("selectTickMachinPrice error:" + e.toString());
			returnCode = "ERROR_02";
			// 애러시 코드 값 입력
			info.setResultCode(returnCode);
			returnMessage = "시스템 에러 입니다.";
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
		

		info.setResultMessage(ParamToJson.paramToJson(model));
		interfaceService.InterfaceInsertLoginLog(info);

		return model;
	}

	// 현금 영수증
	@RequestMapping(value = "billPrint.do")
	public ModelAndView selectPopBillInfo(@RequestParam("resvSeq") String resvSeq,
			@RequestParam("tranGubun") String tranGubun) throws Exception {
		// 가맹점 사업자번호

		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		try {
			String corpNum = propertiesService.getString("Company.Number");

			Map<String, Object> resInfo = resService.selectResInfoDetail(resvSeq);

			String msgKey = tranGubun.equals("bill") ? resvSeq + "_001" : resvSeq + "_002";
			String msgTradType = tranGubun.equals("bill") ? "승인거래" : "취소거래";

			// 메모
			String Memo = "현금영수증 즉시발행 메모";

			// 현금영수증 정보 객체
			Cashbill cashbill = new Cashbill();

			// 문서번호, 최대 24자리, 영문, 숫자 '-', '_'로 구성
			cashbill.setMgtKey(msgKey);

			// 문서형태, {승인거래, 취소거래} 중 기재
			cashbill.setTradeType(msgTradType);

			// 취소거래시 기재, 원본 현금영수증 국세청 승인번호 - getInfo API를 통해 confirmNum 값 기재
			cashbill.setOrgConfirmNum("");

			// 취소거래시 기재, 원본 현금영수증 거래일자 - getInfo API를 통해 tradeDate 값 기재
			cashbill.setOrgTradeDate("");

			// 과세형태, {과세, 비과세} 중 기재
			cashbill.setTaxationType("비과세");

			// 거래처 식별번호, 거래유형에 따라 작성
			// 소득공제용 - 주민등록/휴대폰/카드번호 기재가능
			// 지출증빙용 - 사업자번호/주민등록/휴대폰/카드번호 기재가능

			cashbill.setIdentityNum(SmartUtil.NVL(resInfo.get("user_phone"), "").toString());

			// 거래구분, {소득공제용, 지출증빙용} 중 기재
			cashbill.setTradeUsage(SmartUtil.NVL(resInfo.get("resv_rcpt_dvsn_nm"), "소득공제용").toString());

			// 거래유형, {읿반, 도서공연, 대중교통} 중 기재
			cashbill.setTradeOpt("읿반");

			int payAmt = Integer.valueOf(SmartUtil.NVL(resInfo.get("resv_pay_cost"), "0").toString());
			int payCost = 0;
			int payTxt = 0;

			if (payAmt > 0) {
				payCost = ((payAmt / 11) * 10);
				payTxt = payAmt - payCost;
			}
			// 공급가액, 숫자만 가능
			cashbill.setSupplyCost(String.valueOf(payCost));
			// 부가세, 숫자만 가능
			cashbill.setTax(String.valueOf(payTxt));
			// 합계금액, 숫자만 가능, 봉사료 + 공급가액 + 부가세
			cashbill.setTotalAmount(String.valueOf(payAmt));
			// 봉사료, 숫자만 가능
			cashbill.setServiceFee("0");

			// 발행자 사업자번호, '-'제외 10자리
			cashbill.setFranchiseCorpNum(corpNum);

			// 발행자 상호
			cashbill.setFranchiseCorpName("국민체육진흥공단");

			// 발행자 대표자명
			cashbill.setFranchiseCEOName("발행자 대표자");

			// 발행자 주소
			cashbill.setFranchiseAddr("서울시 송파구 올림픽로 424 올림픽문화센터(올림픽컨벤션센터)");

			// 발행자 연락처
			cashbill.setFranchiseTEL("07043042991");

			// 발행안내 문자 전송여부
			cashbill.setSmssendYN(false);

			// 거래처 고객명
			cashbill.setCustomerName(SmartUtil.NVL(resInfo.get("user_nm"), "0").toString());

			// 거래처 주문상품명
			cashbill.setItemName(SmartUtil.NVL(resInfo.get("seat_nm"), "입석").toString());

			// 거래처 주문번호
			cashbill.setOrderNumber(resvSeq);

			// 거래처 이메일
			// 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
			// 실제 거래처의 메일주소가 기재되지 않도록 주의
			cashbill.setEmail(SmartUtil.NVL(resInfo.get("user_email"), "").toString());
			// 거래처 휴대폰
			cashbill.setHp(SmartUtil.NVL(resInfo.get("user_phone"), "").toString());

			CBIssueResponse response = cashbillService.registIssue(corpNum, cashbill, Memo);
			// 현금 영수증 출력 번호
			ResvInfo info = new ResvInfo();
			info.setResvSeq(resvSeq);
			info.setResvRcptNumber(response.getConfirmNum());
			int ret = resService.resbillChange(info);
			// 현금 영수증 거래 끝 부분

			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject("popBill", response);

		} catch (PopbillException e) {
			// 예외 발생 시, e.getCode() 로 오류 코드를 확인하고, e.getMessage()로 오류 메시지를 확인합니다.
			System.out.println("오류 코드" + e.getCode());
			System.out.println("오류 메시지" + e.getMessage());

			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.error("selectPopBillInfo error:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, e.getCode() + ":" + e.getMessage());

		}

		return model;
	}
}