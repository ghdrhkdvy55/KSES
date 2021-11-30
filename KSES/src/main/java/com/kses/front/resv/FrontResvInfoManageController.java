package com.kses.front.resv;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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

import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorPartInfoManageService;
import com.kses.backoffice.bld.seat.service.SeatInfoManageService;
import com.kses.backoffice.cus.usr.service.UserInfoManageService;
import com.kses.backoffice.cus.usr.vo.UserInfo;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;
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
	private CenterInfoManageService centerService;
	
	@Autowired
	private FloorInfoManageService floorService;
	
	@Autowired
	private FloorPartInfoManageService floorPartService;
	
	@Autowired
	private SeatInfoManageService seatService;
	
	@Autowired
	private ResvInfoManageService resvService;
	
	@Autowired
	private UserInfoManageService userService;
		
	@RequestMapping (value="rsvCenter.do")
	public ModelAndView selectRsvCenterList(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo,
												@RequestParam Map<String, Object> param,
												HttpServletRequest request,
												BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/rsv/rsvCenter");
		try {
			HttpSession httpSession = request.getSession(true);
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if(userLoginInfo ==  null) {
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
			
			if(userLoginInfo ==  null) {
				userLoginInfo = new UserLoginInfo();
				userLoginInfo.setUserDvsn("USER_DVSN_2");
				httpSession.setAttribute("userLoginInfo", userLoginInfo);
			}
			
			String centerCd = (String)params.get("centerCd");
			String resvDate = (String)params.get("resvDate");
			
			Map<String, Object> resvInfo = centerService.selectCenterInfoDetail(centerCd);
			List<Map<String, Object>> floorList = floorService.selectFloorInfoComboList(centerCd);
			
			resvInfo.put("centerCd", centerCd);
			resvInfo.put("resvDate", resvDate);
			model.addObject("resvInfo", resvInfo);
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
			
			List<Map<String, Object>> resultList = seatService.selectReservationSeatList(params);
	    	Map<String, Object> mapInfo = floorPartService.selectFloorPartInfoDetail(params.get("partCd").toString());
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
			
			if("USER_DVSN_1".equals(vo.getResvUserDvsn()) && userLoginInfo == null) {
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				return model;
			} else {
				vo.setUserId(userLoginInfo.getUserId());
			}
			
			// resvService.resvInfoValidCheck(vo);
			int ret = resvService.updateUserResvInfo(vo);
			if(ret > 0) {
				// 방금 예약한 정보 조회 (지점,층,구역,좌석 명칭)
				Map<String, Object> resvInfo = resvService.selectInUserResvInfo(vo);
				model.addObject("resvInfo", resvInfo);
				
				UserInfo user = new UserInfo();
				if("USER_DVSN_1".equals(vo.getResvUserDvsn())) {
					user.setUserId(userLoginInfo.getUserId());
					user.setUserBirthDy(userLoginInfo.getUserBirthDy());
					user.setUserSexMf(userLoginInfo.getUserSexMf());
					user.setUserPhone(userLoginInfo.getUserPhone());
					user.setUserNm(userLoginInfo.getUserNm());
				} else {
					user.setUserId((String)resvInfo.get("user_id"));
					user.setUserBirthDy("19000000");
					user.setUserSexMf("N");
					user.setUserPhone(vo.getResvUserClphn());
					user.setUserNm(vo.getResvUserNm());
				}

				user.setMode("Ins");
				userService.updateUserInfo(user);
				
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
			
			if("USER_DVSN_1".equals(params.get("resvDvsn")) && userLoginInfo == null) {
				userLoginInfo = new UserLoginInfo();
				userLoginInfo.setUserDvsn("USER_DVSN_2");
				httpSession.setAttribute("userLoginInfo", userLoginInfo);
				
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				return model;
			} else {
				params.put("resvState", "RESV_STATE_3");
				params.put("resvCancelCd", "RESV_CANCEL_CD_2");
				params.put("resvCancelId", userLoginInfo.getUserId());
			}
			
			int ret = resvService.resvInfoCancel(params);
			
			if(ret > 0) {
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
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
	
	@RequestMapping (value="checkUserResvInfo.do")
	public ModelAndView checkUserResvInfo(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo, 
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
			int resvCount = resvService.checkUserResvInfo(params);
	    	
	    	model.addObject("resvCount", resvCount);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectRsvPartListAjax : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
}