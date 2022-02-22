package com.kses.front.resv;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.system.service.SystemInfoManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorPartInfoManageService;
import com.kses.backoffice.bld.partclass.service.PartClassInfoManageService;
import com.kses.backoffice.bld.season.service.SeasonInfoManageService;
import com.kses.backoffice.bld.season.service.SeasonSeatInfoManageService;
import com.kses.backoffice.bld.seat.service.SeatInfoManageService;
import com.kses.backoffice.cus.kko.service.SureManageSevice;
import com.kses.backoffice.cus.kko.vo.SmsDataInfo;
import com.kses.backoffice.cus.usr.service.UserInfoManageService;
import com.kses.backoffice.cus.usr.vo.UserInfo;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;
import com.kses.backoffice.sym.log.service.InterfaceInfoManageService;
import com.kses.backoffice.util.SmartUtil;
import com.kses.front.annotation.LoginUncheck;
import com.kses.front.login.vo.UserLoginInfo;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;

@RestController
@RequestMapping("/front/")
public class FrontResvInfoManageController {
    private static final Logger LOGGER = LoggerFactory.getLogger(FrontResvInfoManageController.class);
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
    
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private CenterInfoManageService centerService;
	
	@Autowired
	private FloorInfoManageService floorService;
	
	@Autowired
	private FloorPartInfoManageService floorPartService;
	
	@Autowired
	private PartClassInfoManageService partClassService;
	
	@Autowired
	private SeatInfoManageService seatService;
	
	@Autowired
	private SeasonInfoManageService seasonService;
	
	@Autowired
	private SeasonSeatInfoManageService seasonSeatService;
	
	@Autowired
	private ResvInfoManageService resvService;
	
	@Autowired
	private SureManageSevice sureService;
	
	@Autowired
	private UserInfoManageService userService;
	
	@Autowired
	private SystemInfoManageService systemService;
	
	@Autowired
	private InterfaceInfoManageService interfaceService;
		
	@LoginUncheck
	@RequestMapping (value="rsvCenter.do")
	public ModelAndView viewResvCenterList() throws Exception {
		return new ModelAndView("/front/rsv/rsvCenter");
	}
	
	@LoginUncheck
	@RequestMapping (value="rsvCenterListAjax.do")
	public ModelAndView selectRsvCenterListAjax(	@RequestParam("resvDate") String resvDate,
													HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			List<Map<String, Object>> resultList = centerService.selectResvCenterList(resvDate);
			model.addObject(Globals.JSON_RETURN_RESULTLISR, resultList);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectRsvCenterListAjax : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping (value="rsvSeat.do")
	public ModelAndView viewResvSeatList(	@RequestParam Map<String, Object> params,
											HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/rsv/rsvSeat");
		try {
			String centerCd = (String)params.get("centerCd");
			String resvDate = (String)params.get("resvDate");
			
			Map<String, Object> resvInfo = centerService.selectCenterInfoDetail(centerCd);
			List<Map<String, Object>> floorList = floorService.selectFloorInfoComboList(centerCd);
			List<Map<String, Object>> partClass = partClassService.selectPartClassComboList(centerCd);
			
			resvInfo.put("centerCd", centerCd);
			resvInfo.put("resvDate", resvDate);
			resvInfo.forEach((key, value) -> params.merge(key, value, (v1, v2) -> v2));
			
			model.addObject("partClass", partClass);
			model.addObject("resvInfo", params);
			model.addObject("floorList", floorList);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("viewResvSeatList : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping (value="rsvPartListAjax.do")
	public ModelAndView selectRsvPartListAjax(	@RequestBody Map<String, Object> params,
												HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			
			List<Map<String, Object>> resultList = floorPartService.selectResvPartList(params);
	    	Map<String, Object> mapInfo = floorService.selectFloorInfoDetail(params.get("floorCd").toString());
	    	model.addObject("seatMapInfo", mapInfo);
			
			model.addObject(Globals.JSON_RETURN_RESULTLISR, resultList);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectRsvPartListAjax : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping (value="rsvSeatListAjax.do")
	public ModelAndView selectRsvSeatListAjax(	@RequestBody Map<String, Object> params,
												HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			String seasonCd = seasonService.selectCenterSeasonCd(params);
			List<Map<String, Object>> resultList = null;
			
			if(StringUtils.isBlank(seasonCd)) {
				resultList = seatService.selectReservationSeatList(params);
			} else {
				params.put("seasonCd", seasonCd);
				model.addObject("seasonCd", seasonCd);
				resultList = seasonSeatService.selectReservationSeasonSeatList(params);
			}
			
			Map<String, Object> mapInfo = floorPartService.selectFloorPartInfoDetail(params.get("partCd").toString());
	    	
			model.addObject("seatMapInfo", mapInfo);
			model.addObject(Globals.JSON_RETURN_RESULTLISR, resultList);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectRsvSeatListAjax : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping(value="resvCertifiSms.do")
	public ModelAndView insertResvCertifiSmsInfo(	@RequestBody Map<String, Object> params,
													HttpServletRequest request) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try {
			SmsDataInfo smsDataInfo = new SmsDataInfo();
			
			smsDataInfo.setSendid("kcycle");
			smsDataInfo.setSendname("SYSTEM");
			
			String phNum[] = SmartUtil.getSplitPhNum(SmartUtil.NVL(params.get("certifiNum"), ""));
			smsDataInfo.setRecvname(SmartUtil.NVL(params.get("certifiNm"), ""));
			smsDataInfo.setRphone1(phNum[0]);
			smsDataInfo.setRphone2(phNum[1]);
			smsDataInfo.setRphone3(phNum[2]);
			
			smsDataInfo.setSphone1("02");
			smsDataInfo.setSphone2("2067");
			smsDataInfo.setSphone3("5000");
			
			String certifiCode = sureService.selectCertifiCode();
			String msg = "입장신청 인증번호는 [" + certifiCode + "] 입니다.";
			smsDataInfo.setMsg(msg);
			smsDataInfo.setSysGbn("MOBILE_KCYCLE");
			smsDataInfo.setUserid("14080");
			
			int ret = sureService.insertSmsData(smsDataInfo);
			if(ret > 0) {
				model.addObject("certifiCode", certifiCode);
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.request.msg"));
			} else {
				throw new Exception();
			}
		} catch(Exception e) {
			LOGGER.error("insertResvCertifiSmsInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		
		return model;
	}
	
	@LoginUncheck
	@RequestMapping(value="selectResvInfo.do")
	public ModelAndView selectResvInfo(	@RequestParam("resvSeq") String resvSeq,
										HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			model.addObject("resvInfo", resvService.selectResvInfoDetail(resvSeq));
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectResvInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping(value="selectSystemInfo.do")
	public ModelAndView selectSystemInfo(HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			model.addObject("systemInfo", systemService.selectSystemInfo());
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectSystemInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping (value="updateUserResvInfo.do")
	@Transactional
	public ModelAndView updateUserResvInfo( @RequestBody ResvInfo vo,
											HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession();
			UserLoginInfo userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if(userLoginInfo != null) {
				vo.setUserId(userLoginInfo.getUserId());
				vo.setResvUserDvsn("USER_DVSN_1");
			} else {
				vo.setResvUserDvsn("USER_DVSN_2");
			}
			
			int ret = resvService.updateUserResvInfo(vo);
			if(ret > 0) {
				// 방금 예약한 정보 조회 (지점,층,구역,좌석 명칭)
				Map<String, Object> resvInfo = resvService.selectInUserResvInfo(vo);
				String autoPaymentYn = systemService.selectTodayAutoPaymentYn();
				
				if(vo.getResvUserDvsn().equals("USER_DVSN_1")) {
					new Thread(()->{
						try {
							if(resvInfo.get("center_pilot_yn").toString().equals("Y") && autoPaymentYn.equals("Y")) {
								interfaceService.SpeedOnPayMent(vo.getResvSeq(), "", false);
							}
						} catch (Exception e) {
							LOGGER.info("RESV_SEQ : " + resvInfo.get("resv_seq") + " RESERVATION AUTO PAYMENT FAIL");
						}
					}).start();
				} else {
					UserInfo user = new UserInfo();
					user.setUserDvsn("USER_DVSN_2");
					user.setUserId(resvInfo.get("user_id").toString());
					user.setUserBirthDy("19700000");
					user.setUserSexMf("N");
					user.setUserPhone(vo.getResvUserClphn());
					user.setUserNm(vo.getResvUserNm());
					user.setIndvdlinfoAgreYn(vo.getResvIndvdlinfoAgreYn());
					user.setMode("Ins");
					
					userService.updateUserInfo(user);
				}
				
				sureService.insertResvSureData("RESERVATION", resvInfo.get("resv_seq").toString());
				
				model.addObject("resvInfo", resvInfo);
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
			} else {
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.reservation"));
			}
		} catch(Exception e) {
			LOGGER.error("updateUserResvInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping (value="resvInfoCancel.do")
	public ModelAndView resvInfoCancel( @RequestBody Map<String, Object> params,
										HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		String Message = "";
		
		try {
			params.put("resvSeq", params.get("resv_seq"));
			Map<String, Object> resvInfo = resvService.selectUserResvInfo(params);
			
			if(!SmartUtil.NVL(resvInfo.get("resv_state"),"").equals("RESV_STATE_1")) {
				switch (SmartUtil.NVL(resvInfo.get("resv_state"),"")) {
					case "RESV_STATE_2" : Message = "이미 이용중인 예약정보 입니다.";  break;
					case "RESV_STATE_3" : Message = "이미 이용완료 처리된 예약정보 입니다.";  break;
					case "RESV_STATE_4" : Message = "이미 취소된 예약정보 입니다.";  break;
					default: Message = "알수없는 예약정보 입니다."; break;
				}
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, Message);
				return model;
			}
			
			int ret = resvService.resvInfoCancel(params);
			if(ret > 0) {
				sureService.insertResvSureData("CANCEL", params.get("resv_seq").toString());

				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.reservation"));
			} else {
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.reservation"));
			}
		} catch(Exception e) {
			LOGGER.error("resvInfoCancel : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping (value="resvInfoDuplicateCheck.do")
	public ModelAndView resvInfoDuplicateCheck( @RequestBody Map<String, Object> params,
												HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession();
			UserLoginInfo userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			String userId = userLoginInfo != null ? userLoginInfo.getUserId() : "";
			params.put("userId", userId);
			int resvCount = resvService.resvInfoDuplicateCheck(params);
	    	
	    	model.addObject("resvCount", resvCount);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("resvInfoDuplicateCheck : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping (value="resvValidCheck.do")
	public ModelAndView resvValidCheck(	@RequestBody Map<String, Object> params,
										HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession();
			UserLoginInfo userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			if(userLoginInfo != null) {
				params.put("userDvsn", "USER_DVSN_1");
				params.put("userId", userLoginInfo.getUserId());
			} else {
				params.put("userDvsn", "USER_DVSN_2");
			}
			
			resvService.resvValidCheck(params);
			
			model.addObject("validResult", params);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("resvValidCheck : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
}