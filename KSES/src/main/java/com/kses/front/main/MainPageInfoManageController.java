package com.kses.front.main;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.front.login.vo.UserLoginInfo;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

@RestController
@RequestMapping("/front/")
public class MainPageInfoManageController {

    private static final Logger LOGGER = LoggerFactory.getLogger(MainPageInfoManageController.class);
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
    
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private ResvInfoManageService resvService;
		
	@RequestMapping (value="main.do")
	public ModelAndView selectFrontMainPage(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestParam Map<String, String> param,
												HttpServletRequest request,
												BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/main/mainpage");
		try {
			
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				
			} else {
				HttpSession httpSession = request.getSession(true);
				loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
			}
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectFrontMainPage : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@RequestMapping (value="userInfo.do")
	public ModelAndView selectUserInfo(	@RequestParam("userId") String userId,
										HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession(true);
			UserLoginInfo userLoginInfo = new UserLoginInfo();
			
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			if(userLoginInfo ==  null) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;	
			}
			
			model.addObject("reservationInfo", resvService.selectUserLastResvInfo(userId));
			model.addObject("userLoginInfo", userLoginInfo);
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectUserInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@RequestMapping (value="userResvInfo.do")
	public ModelAndView selectUserResvInfo(	@RequestBody Map<String, Object> params,
											HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession(true);
			UserLoginInfo userLoginInfo = new UserLoginInfo();
			
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			if(userLoginInfo ==  null) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;	
			}
			
			model.addObject("userLoginInfo", userLoginInfo);
			model.addObject(Globals.JSON_RETURN_RESULTLISR, resvService.selectUserResvInfo(params));
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectUserResvInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
}