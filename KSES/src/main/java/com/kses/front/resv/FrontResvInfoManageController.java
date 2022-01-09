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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorPartInfoManageService;
import com.kses.backoffice.bld.season.service.SeasonInfoManageService;
import com.kses.backoffice.bld.season.service.SeasonSeatInfoManageService;
import com.kses.backoffice.bld.seat.service.SeatInfoManageService;
import com.kses.backoffice.cus.kko.service.SureManageSevice;
import com.kses.backoffice.cus.kko.vo.SmsDataInfo;
import com.kses.backoffice.cus.usr.service.UserInfoManageService;
import com.kses.backoffice.cus.usr.vo.UserInfo;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;
import com.kses.backoffice.util.SmartUtil;
import com.kses.front.login.vo.UserLoginInfo;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
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
	private EgovCcmCmmnDetailCodeManageService codeDetailService;
	
	@Autowired
	private CenterInfoManageService centerService;
	
	@Autowired
	private FloorInfoManageService floorService;
	
	@Autowired
	private FloorPartInfoManageService floorPartService;
	
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
		
	@RequestMapping (value="rsvCenter.do")
	public ModelAndView selectRsvCenterList(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo,
												@RequestParam Map<String, Object> params,
												HttpServletRequest request,
												BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/rsv/rsvCenter");
		try {
			HttpSession httpSession = request.getSession(true);
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if(userLoginInfo == null) {
				userLoginInfo = new UserLoginInfo();
				userLoginInfo.setUserDvsn("USER_DVSN_2");
				httpSession.setAttribute("userLoginInfo", userLoginInfo);
			}
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectRsvCenterList : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@RequestMapping (value="rsvCenterListAjax.do")
	public ModelAndView selectRsvCenterListAjax(	@ModelAttribute("loginVO") LoginVO loginVO, 
													@RequestParam("resvDate") String resvDate,
													HttpServletRequest request,
													BindingResult result) throws Exception {
		
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
	
	@RequestMapping (value="rsvSeat.do")
	public ModelAndView selectRsvSeatList(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo, 
											@RequestParam Map<String, Object> params,
											HttpServletRequest request,
											BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/rsv/rsvSeat");
		try {
			HttpSession httpSession = request.getSession(true);
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if(userLoginInfo == null) {
				userLoginInfo = new UserLoginInfo();
				userLoginInfo.setUserDvsn("USER_DVSN_2");
				httpSession.setAttribute("userLoginInfo", userLoginInfo);
				model.setViewName("redirect:/front/main.do");
			}
			
			String centerCd = (String)params.get("centerCd");
			String resvDate = (String)params.get("resvDate");
			

			Map<String, Object> resvInfo = centerService.selectCenterInfoDetail(centerCd);
			List<Map<String, Object>> floorList = floorService.selectFloorInfoComboList(centerCd);
			List<Map<String, Object>>  seatClass = codeDetailService.selectCmmnDetailCombo("SEAT_CLASS");
			
			
			resvInfo.put("centerCd", centerCd);
			resvInfo.put("resvDate", resvDate);
			
			resvInfo.forEach((key, value) -> params.merge(key, value, (v1, v2) -> v2));
			
			model.addObject("seatClass", seatClass);
			model.addObject("resvInfo", params);
			model.addObject("floorList", floorList);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectRsvSeatList : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@RequestMapping (value="rsvPartListAjax.do")
	public ModelAndView selectRsvPartListAjax(	@ModelAttribute("loginVO") UserLoginInfo userLoginInfo, 
												@RequestBody Map<String, Object> params,
												HttpServletRequest request,
												BindingResult result) throws Exception {
		
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
	
	@RequestMapping (value="rsvSeatListAjax.do")
	public ModelAndView selectRsvSeatListAjax(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo, 
												@RequestBody Map<String, Object> params,
												HttpServletRequest request,
												BindingResult result) throws Exception {
		
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
	
	@RequestMapping(value="resvCertifiSms.do")
	public ModelAndView insertResvCertifiSmsInfo(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo, 
													@RequestBody Map<String, Object> params,
													HttpServletRequest request,
													BindingResult result) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try {
			SmsDataInfo smsDataInfo = new SmsDataInfo();
			
			smsDataInfo.setSendid("kcycle");
			smsDataInfo.setSendname("SYSTEM");
			
			LOGGER.debug(params.get("certifiNum").toString());
			LOGGER.debug(SmartUtil.NVL(params.get("certifiNum"), ""));
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
	
	@RequestMapping(value="getResvInfo.do")
	public ModelAndView getResvInfo(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo, 
										@RequestParam("resvSeq") String resvSeq,
										HttpServletRequest request,
										BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession(true);
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if(userLoginInfo == null) {
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				return model;
			}
			
			model.addObject("resvInfo", resvService.selectResInfoDetail(resvSeq));
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("getResvInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@RequestMapping (value="updateUserResvInfo.do")
	@Transactional(rollbackFor = Exception.class)
	public ModelAndView updateUserResvInfo(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo, 
											@RequestBody ResvInfo vo,
											HttpServletRequest request,
											BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession(true);
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if(userLoginInfo == null) {
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				return model;
			} else {
				vo.setUserId(userLoginInfo.getUserId());
			}
			
			int ret = resvService.updateUserResvInfo(vo);
			if(ret > 0) {
				// 방금 예약한 정보 조회 (지점,층,구역,좌석 명칭)
				Map<String, Object> resvInfo = resvService.selectInUserResvInfo(vo);
				model.addObject("resvInfo", resvInfo);
				
				UserInfo user = new UserInfo();
				if("USER_DVSN_2".equals(vo.getResvUserDvsn())) {
					user.setUserDvsn("USER_DVSN_2");
					user.setUserId(resvInfo.get("user_id").toString());
					user.setUserBirthDy("19700000");
					user.setUserSexMf("N");
					user.setUserPhone(vo.getResvUserClphn());
					user.setUserNm(vo.getResvUserNm());
					user.setIndvdlinfoAgreYn(vo.getResvIndvdlinfoAgreYn());
					user.setMode(Globals.SAVE_MODE_INSERT);
					
					userService.updateUserInfo(user);
				}
				
				if(sureService.insertResvSureData("RESERVATION", resvInfo.get("resv_seq").toString())) {
					LOGGER.info("예약번호 : " + resvInfo.get("resv_seq").toString() + "번 알림톡 발송성공");
				} else {
					LOGGER.info("예약번호 : " + resvInfo.get("resv_seq").toString() + "번 알림톡 발송실패");
				}
				
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
	
	@RequestMapping (value="resvInfoCancel.do")
	public ModelAndView resvInfoCancel(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo, 
										@RequestBody Map<String, Object> params,
										HttpServletRequest request,
										BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession(true);
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if(userLoginInfo == null) {
				userLoginInfo = new UserLoginInfo();
				userLoginInfo.setUserDvsn("USER_DVSN_2");
				httpSession.setAttribute("userLoginInfo", userLoginInfo);
				
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				return model;
			}
			
			int ret = resvService.resvInfoCancel(params);
			
			if(ret > 0) {
				if(sureService.insertResvSureData("CANCEL", params.get("resv_seq").toString())) {
					LOGGER.info("예약번호 : " + params.get("resv_seq").toString() + "번 예약취소 알림톡 발송성공");
				} else {
					LOGGER.info("예약번호 : " + params.get("resv_seq").toString() + "번 예약취소 알림톡 발송실패");
				}
				
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
	
	@RequestMapping (value="resvInfoDuplicateCheck.do")
	public ModelAndView resvInfoDuplicateCheck(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo, 
												@RequestBody Map<String, Object> params,
												HttpServletRequest request,
												BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession(true);
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if("USER_DVSN_1".equals(params.get("resvDvsn")) && userLoginInfo == null) {
				userLoginInfo = new UserLoginInfo();
				userLoginInfo.setUserDvsn("USER_DVSN_2");
				httpSession.setAttribute("userLoginInfo", userLoginInfo);
				
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				return model;
			}
			
			params.put("userId", userLoginInfo.getUserId());
			int resvCount = resvService.resvInfoDuplicateCheck(params);
	    	
	    	model.addObject("resvCount", resvCount);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectRsvPartListAjax : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@RequestMapping (value="resvValidCheck.do")
	public ModelAndView resvValidCheck(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo, 
										@RequestBody Map<String, Object> params,
										HttpServletRequest request,
										BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession(true);
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if(userLoginInfo == null) {
				userLoginInfo = new UserLoginInfo();
				userLoginInfo.setUserDvsn("USER_DVSN_2");
				httpSession.setAttribute("userLoginInfo", userLoginInfo);
				
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				return model;
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