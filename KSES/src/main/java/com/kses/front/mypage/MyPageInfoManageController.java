package com.kses.front.mypage;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.cus.usr.service.UserInfoManageService;
import com.kses.backoffice.cus.usr.vo.UserInfo;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.front.annotation.LoginUncheck;
import com.kses.front.login.vo.UserLoginInfo;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;

@RestController
@RequestMapping("/front/")
public class MyPageInfoManageController {
    private static final Logger LOGGER = LoggerFactory.getLogger(MyPageInfoManageController.class);
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
    
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private ResvInfoManageService resvService;
	
	@Autowired
	private UserInfoManageService userService;
	
	@Autowired
	private CenterInfoManageService centerInfoManageService;
	
	@LoginUncheck
	@RequestMapping (value="mypage.do")
	public ModelAndView viewFrontmypage() throws Exception {
		return new ModelAndView("/front/my/mypage");
	}
	
	@RequestMapping (value="userResvHistory.do")
	public ModelAndView viewFrontUserResvHistory(	@RequestParam Map<String, String> param,
													HttpServletRequest request) throws Exception {
		return new ModelAndView("/front/my/userResvHistory");
	}
	
	@RequestMapping (value="userRcptInfo.do")
	public ModelAndView viewFrontUserRcptInfo(HttpServletRequest request) throws Exception {
		return new ModelAndView("/front/my/userRcptInfo");
	}
	
	@RequestMapping (value="userRcptInfoAjax.do")
	public ModelAndView selectFrontUserRcptInfoAjax(HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession();
			UserLoginInfo userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if(userLoginInfo == null) {
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				return model;
			} 
			
			Map<String, Object> userRcptInfo = userService.selectUserInfoDetail(userLoginInfo.getUserId());
			
			model.addObject("userRcptInfo", userRcptInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectFrontUserRcptInfoAjax : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@RequestMapping (value="updateUserRcptInfo.do")
	public ModelAndView updateUserRcptInfo(	HttpServletRequest request,
											@RequestBody UserInfo userInfo) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession(true);
			UserLoginInfo userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			userInfo.setUserId(userLoginInfo.getUserId());
			int ret = userService.updateUserRcptInfo(userInfo);
			
			if(ret > 0) {
				userLoginInfo.setUserRcptYn(userInfo.getUserRcptYn());
				userLoginInfo.setUserRcptDvsn(userInfo.getUserRcptDvsn());
				userLoginInfo.setUserRcptNumber(userInfo.getUserRcptNumber());
				
				httpSession.setAttribute("userLoginInfo", userLoginInfo);
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.insert"));
			} else {
				throw new Exception();
			}
		} catch(Exception e) {
			LOGGER.error("selectFrontUserRcptInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@RequestMapping (value="userMyResvInfo.do")
	public ModelAndView selectFrontUserMyResvInfo(	HttpServletRequest request,
													@RequestBody Map<String, Object> params) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			List<Map<String, Object>> userResvInfo = resvService.selectUserMyResvInfo(params);
			
			model.addObject("userResvInfo", userResvInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectFrontUserMyResvInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping (value="guestResvInfo.do")
	public ModelAndView viewGuestResvInfopage() throws Exception {
		return new ModelAndView("/front/my/guestResvInfo");
	}
	
	@LoginUncheck
	@RequestMapping (value="guestMyResvInfo.do")
	public ModelAndView selectGuestMyResvInfo(	HttpServletRequest request,
												@RequestBody Map<String, Object> params) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {	
			List<Map<String, Object>> guestResvInfo = resvService.selectGuestMyResvInfo(params);
			model.addObject("guestResvInfo", guestResvInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectGuestMyResvInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping (value="notice.do")
	public ModelAndView selectnoticeInfo() throws Exception {
		
		ModelAndView model = new ModelAndView("/front/my/notice");
		try {
			model.addObject("centerInfo", centerInfoManageService.selectCenterInfoComboList());
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectGuestMyResvInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
}