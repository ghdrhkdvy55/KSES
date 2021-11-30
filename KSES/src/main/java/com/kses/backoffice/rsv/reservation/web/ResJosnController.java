package com.kses.backoffice.rsv.reservation.web;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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
import com.kses.backoffice.sym.log.service.InterfaceInfoManageService;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.property.EgovPropertyService;

@RestController
@RequestMapping("/backoffice/rsv")
public class ResJosnController{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ResJosnController.class);
	//추후 front 로 이동 
	
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
	
	
	
	@RequestMapping(value="speedCheck.do", method = {RequestMethod.POST})
    public ModelAndView selectPreOpenInfo(	@ModelAttribute("loginVO") LoginVO loginVO,
    		                                @RequestBody Map<String, Object> sendInfo,
    										HttpServletRequest request) {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
		     //값 넣기 
			 String Url = "";
			 JsonNode node = null;
			 //_requstId
			 //
			 if ( SmartUtil.NVL(sendInfo.get("gubun"), "").toString().equals("login") ) {
				 Url =  propertiesService.getString("sppeedUrl_T") + "user/userChk";
				 node = SmartUtil.requestHttpJson(Url, SmartUtil.NVL(sendInfo.get("sendInfo"), "").toString(), "SPEEDLOGIN", "SPEEDON", "KSES" );
				 
				 
				 if (node.get("Error_Cd").equals("SUCCESS")  ) {
					 UserInfo user = new UserInfo();
					 user.setUserBirthDy(node.get("User_Birth_Day").toString());
					 user.setUserSexMf(node.get("User_Sex").toString());
					 user.setUserPhone(node.get("User_Phone").toString());
					 user.setUserNm(node.get("User_Nm").toString());
					 user.setMode("Ins");
					 userService.updateUserInfo(user);
					 
					 //메세지 전송 확인 
					 
					 
					 
				 } 
				
			 }else if ( SmartUtil.NVL(sendInfo.get("gubun"), "").toString().equals("fep") ) {
				 //출급 정보
				 Url =  propertiesService.getString("sppeedUrl_T") +"trade/fepWithdraw";
				 node = SmartUtil.requestHttpJson(Url, SmartUtil.NVL(sendInfo.get("sendInfo"), "").toString(), "SPEEDWITHDRAW", "SPEEDON", "KSES");
				 if (node.get("Error_Cd").equals("SUCCESS")  ) {
					 //예약 테이블 출금 정보 처리 하기 
				 }
				 
			 }else {
				//취소 정보
				Url =  propertiesService.getString("sppeedUrl_T") +"trade/fepDeposit";
				node = SmartUtil.requestHttpJson(Url, SmartUtil.NVL(sendInfo.get("sendInfo"), "").toString(), "SPEEDFEPDEPOSIT", "SPEEDON", "KSES");
				if (node.get("Error_Cd").equals("SUCCESS")  ) {
					 //예약 테이블 취소 정보 처리 하기 
				}
			 }
			 model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			 model.addObject(Globals.STATUS_REGINFO, node);
		}catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		
		return model;
		
	}
	//qr checkin 검토 
	@RequestMapping(value="qrReadCheck.do", method = {RequestMethod.POST})
	public ModelAndView selectQrCheckInfo(	@RequestBody AttendInfo sendInfo,
											HttpServletRequest request) {

        ModelAndView model = new ModelAndView(Globals.JSONVIEW);
        try {
        	EgovFileScrty fileScrty = new EgovFileScrty();	
        	
        	String qrInfo = fileScrty.decode(sendInfo.getQrCode())  ;
        	
        	LOGGER.debug("qrInfo:" + qrInfo);
        	
        	String result = "";
        	if (qrInfo.contains(":")) {
        		String [] attempInfos = qrInfo.split(":");
        		String resSeq = attempInfos[0];
        		String qrTime = attempInfos[1];
        		String inOt = attempInfos[2];
        		String gubun = attempInfos[3];
        		String userId = attempInfos[4];
        		
        		
        		
        		//시간 비교 
        		if (  Integer.valueOf( SmartUtil.timeCheck(qrTime)) < -30  &&  gubun.equals("INTERVAL") ) {
        			result = "{\"ERROR_CD\": \"ERROR_01\", \"ERROR_MSG\" : \"30초 시간이 경과된 QR입니다.\"}";
        			
        		}
        		
        		// 현재 날짜/시간
        		
        		String formatedNow = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        		sendInfo.setUserId(userId);
        		sendInfo.setResvSeq(resSeq);
        		sendInfo.setInoutDvsn(inOt);
        		sendInfo.setRcvDt(formatedNow);
        		sendInfo.setQrCheckTm(formatedNow);
        		sendInfo.setRcvCd("OK");
        		sendInfo.setQrCode(sendInfo.getQrCode());
        		
        		
        		sendInfo = attendService.insertAttendInfo(sendInfo);
        		if (sendInfo.getRcvCd().equals("OK")) {
        			result = "{\"ERROR_CD\": \"OK\", \"ERROR_MSG\" : \",\"IOGUBUN\":\""+inOt +"\",\"USER_NM\":\""+  sendInfo.getUserNm() +"\"}";
        		}else {
        			String errorMessage =  sendInfo.getRcvCd().equals("ERROR_02") ? "입/출입 잘못 시도" : "시스템 에러";
        			result = "{\"ERROR_CD\": \""+ sendInfo.getRcvCd()+"\", \"ERROR_MSG\" : \""+errorMessage+"\"}";
        		}
        	}else {
        		result = "{\"ERROR_CD\": \"ERROR_04\", \"ERROR_MSG\" : \"잘못된 파라미터 입니다.\"}";
        	}
        	
        	
        	model.addObject(result);
        }catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
        return model;
	}
	//qr 새 전송 
	@RequestMapping(value="qrSend.do")
	public ModelAndView selectQrSendInfo (@RequestParam("resvSeq") String resvSeq, @RequestParam("tickPlace") String tickPlace)throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Map<String, Object> searchVO = new HashMap<String, Object>();
			String nowDate =  LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
			searchVO.put("resvSeq", resvSeq);
			searchVO.put("resvDate", nowDate);
			
			
			LOGGER.debug("resSeq:" + resvSeq);
			LOGGER.debug("resvDate:" + searchVO.get("resvDate"));
			
			Map<String, Object> resInfo = resService.selectUserResvInfo(searchVO);
			
			
			
			
			if (resInfo == null ||!resInfo.get("resv_start_dt").toString().equals(nowDate) ) {
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE,"잘못된 예약 번호 이거나 지난 예약번호 입니다.");
			}else if (SmartUtil.NVL( resInfo.get("resv_state"), "").toString().equals("RESV_STATE_4") ) {
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE,"예약 취소된 예약 번호 입니다.");
			}else {
				AttendInfo vo = new AttendInfo();
				vo.setResvSeq(resvSeq);
				String qrTime =  LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
				String inOt = "";
				Map<String, Object> attend =  attendService.selectAttendInfoDetail(vo);
				if (attend == null) {
					inOt = "IN";
				}else {
					inOt = SmartUtil.NVL(attend.get("inout_dvsn"),"OT").toString().equals("IN") ? "OT" : "IN";
				}
				EgovFileScrty fileScrty = new EgovFileScrty();
				
				String gubun = tickPlace.equals("ONLINE") ? "INTERVAL" : "PAPER";
				
				String qrCode = fileScrty.encode(resvSeq+":"+qrTime+":"+inOt+":"+ gubun + ":" + SmartUtil.NVL(resInfo.get("user_id"), "").toString());
				
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject("QRCODE", qrCode);
			}
		}catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	//무인 발권기만 남았음
	@RequestMapping(value="tickMachinRes.do")
	public ModelAndView selectTickMachinRes (@RequestBody Map<String, Object> jsonInfo )throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		
		model.addObject("IF_NO", jsonInfo.get("IF_NO"));
		model.addObject("RES_NO", jsonInfo.get("RES_NO"));
		model.addObject("RETURN_DATE", jsonInfo.get("RES_NO"));
		model.addObject("MACHINE_SERIAL", jsonInfo.get("MACHINE_SERIAL"));
		
		String resName = "";
		String resPrice = "";
		String resDay = "";
		String resTime = "";
		String seatName = "";
		String resPersonCnt = "";
		String returnCode = "";
		String returnMessage = "";
		try {
			
			Map<String, Object> searchVO = new HashMap<String, Object>();
			LOGGER.debug("RES_NO:" + jsonInfo.get("RES_NO"));
			searchVO.put("resvSeq", SmartUtil.NVL(jsonInfo.get("RES_NO"), "").toString());
			String localTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
			searchVO.put("resvDate", localTime);
			Map<String, Object> resInfo = resService.selectUserResvInfo(searchVO);
			String recDate =  SmartUtil.NVL(jsonInfo.get("RES_SEND_DATE"), "").toString();
			// 인터페이스 구문 타기
			
			if (resInfo != null && SmartUtil.NVL(resInfo.get("resv_start_dt"), "").toString().equals(localTime)) {
				
				resName = SmartUtil.NVL(resInfo.get("user_nm") , "").toString();
				resPrice = SmartUtil.NVL(resInfo.get("resv_pay_cost") , "").toString();
				resDay = SmartUtil.NVL(resInfo.get("resv_start_dt") , "").toString();
				resTime = SmartUtil.NVL(resInfo.get("resv_start_tm") , "").toString();
				seatName = SmartUtil.NVL(resInfo.get("seat_nm") , "").toString();
				resPersonCnt = "1";
				returnCode = "OK";
			}else {
				returnCode = "ERROR_01";
				returnMessage = "예약 정보가 없습니다.";
			}
		}catch(Exception e) {
			returnCode = "ERROR_02";
			returnMessage = "시스템 애러.";
		}
		model.addObject("RES_NAME", resName);
		model.addObject("RES_PRICE", resPrice  );
		model.addObject("RES_DAY", resDay  );
		model.addObject("RES_TIME", resTime  );
		model.addObject("SEAT_NAME", resPrice  );
		model.addObject("RES_PERSON_CNT", resPersonCnt  );
		model.addObject("RETURN_CODE", returnCode  );
		model.addObject("RETURN_MESSAGE", returnMessage  );
		return model;
	}
	@RequestMapping(value="tickMachinQr.do")
	public ModelAndView selectTickMachinPrice (@RequestBody Map<String, Object> jsonInfo )throws Exception{
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
	
		try {
			Map<String, Object> searchVO = new HashMap<String, Object>();
			searchVO.put("resvSeq", SmartUtil.NVL(jsonInfo.get("RES_NO"), "").toString());
			searchVO.put("resvDate", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")));
			Map<String, Object> resInfo = resService.selectUserResvInfo(searchVO);
			String recDate =  SmartUtil.NVL(jsonInfo.get("RES_SEND_DATE"), "").toString();
			
			
			if (resInfo == null) {
				returnCode = "ERROR_01";
				returnMessage = "예약 정보가 없습니다.";
			}else if (resInfo != null && 
					  Integer.valueOf(SmartUtil.NVL( jsonInfo.get("RES_PRICE"), "").toString()) != 
					  Integer.valueOf(SmartUtil.NVL( resInfo.get("resv_pay_cost"), "").toString())  
					 ) {
				returnCode = "ERROR_03";
				returnMessage = "금액 정보가 일치 하지 않습니다.";
			}else {
				resName = SmartUtil.NVL(resInfo.get("user_nm") , "").toString();
				resPrice = SmartUtil.NVL(resInfo.get("resv_pay_cost") , "").toString();
				resDay = SmartUtil.NVL(resInfo.get("resv_start_dt") , "").toString();
				resTime = SmartUtil.NVL(resInfo.get("resv_start_tm") , "").toString();
				resQrUrl =  "/urImg";
				seatName = SmartUtil.NVL(resInfo.get("seat_nm") , "").toString();
				resPersonCnt = "1";
				returnCode = "OK";
				
				ResvInfo resInfoU = new ResvInfo();
				
				resInfoU.setTradNo(SmartUtil.NVL(jsonInfo.get("IF_NO"), "").toString()); 
				resInfoU.setResvPayDvsn("RESV_PAY_DVSN_2");
				resInfoU.setResvSeq(SmartUtil.NVL(jsonInfo.get("RES_NO"), "").toString());
				
				int ret = resService.resPriceChange(resInfoU);
				if (ret > 0) {
					returnCode = "OK";
				}else {
					returnCode = "ERROR_02";
					returnMessage = "시스템 애러.";
				}
						
			}
			
		}catch (Exception e) {
			LOGGER.error("selectTickMachinPrice error:" + e.toString());
			returnCode = "ERROR_02";
			returnMessage = "시스템 애러.";
		}
		model.addObject("RES_NAME", resName);
		model.addObject("RES_PRICE", resPrice  );
		model.addObject("RES_DAY", resDay  );
		model.addObject("RES_TIME", resTime  );
		model.addObject("SEAT_NAME", resPrice  );
		model.addObject("RES_QR_URL", resQrUrl  );
		model.addObject("RES_PERSON_CNT", resPersonCnt  );
		model.addObject("RETURN_CODE", returnCode  );
		model.addObject("RETURN_MESSAGE", returnMessage  );
		return model;
	}
}
