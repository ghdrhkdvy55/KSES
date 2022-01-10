package com.kses.front.login.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
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

import com.kses.backoffice.cus.usr.service.UserInfoManageService;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.util.SmartUtil;
import com.kses.front.login.service.UserLoginService;
import com.kses.front.login.vo.UserLoginInfo;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;

@RestController
@RequestMapping("/front/")
public class LoginPageInfoManageController {
	private static final Logger LOGGER = LoggerFactory.getLogger(LoginPageInfoManageController.class);
		
	@Autowired
	protected EgovMessageSource egovMessageSource;
	    
	@Autowired
	protected EgovPropertyService propertiesService;
	
	@Autowired
	protected UserLoginService loginService;
	
	@Autowired
	private ResvInfoManageService resvService;
	
	@Autowired
	private UserInfoManageService userService;
	
	/**
	 * 사용자페이지 테스트 로그인
	 * 
	 * @param userLoginInfo
	 * @param param
	 * @param request
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="actionLogin.do")
	public ModelAndView actionLogin( 	@RequestBody Map<String, Object> params,
										HttpServletRequest request,
										BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {		
			
			params.put("Error_Cd", loginService.getUserLoginCheck(params));
			Map<String, Object> userInfo = loginService.getUserLoginInfo(params);
			
			model.addObject("RESULT", userInfo);
		} catch(Exception e) {
			LOGGER.error("actionLogin : " + e.toString());
			model.addObject("RESULT", null);
		}
		return model;
	}
	
	@RequestMapping (value="actionLogout.do")
	public ModelAndView actionLogout(HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/main/mainpage");
		try {		
			HttpSession httpSession = request.getSession(true);
			httpSession.removeAttribute("userLoginInfo");

			UserLoginInfo userLoginInfo = new UserLoginInfo();
			userLoginInfo.setUserDvsn("USER_DVSN_2");
			httpSession.setAttribute("userLoginInfo", userLoginInfo);			
		} catch(Exception e) {
			LOGGER.error("actionLogout : " + e.toString());
		}
		return model;
	}
			
	@RequestMapping (value="userSessionCreate.do")
	public ModelAndView setUserSession(	@RequestBody UserLoginInfo userLoginInfo,
										HttpServletRequest request,
										BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			if(!StringUtils.isBlank(userLoginInfo.getIndvdlinfoAgreYn()) && userLoginInfo.getIndvdlinfoAgreYn().equals("Y")) {
				String envType = propertiesService.getString("Globals.envType");
				Map<String, Object> vacntnInfo = null;
				if(envType.equals("DEV")) {
					userLoginInfo.setEnvType("DEV");
					vacntnInfo = userService.selectSpeedOnVacntnInfo(userLoginInfo);
					userLoginInfo.setVacntnDt(SmartUtil.NVL(vacntnInfo.get("covid_dy"), ""));
				} else if(envType.equals("PROD")){
					userLoginInfo.setEnvType("PROD");
					vacntnInfo = userService.selectSpeedOnVacntnInfo(userLoginInfo);
					userLoginInfo.setVacntnDt(SmartUtil.NVL(vacntnInfo.get("covid_dy"), ""));
				}
				
				userService.updateUserInfo(userLoginInfo);
			}
			
		    HttpSession httpSession = request.getSession(true);
			httpSession.setAttribute("userLoginInfo", userLoginInfo);
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("setUserSession : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@RequestMapping (value="login.do")
	public ModelAndView selectFrontLoginPage(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo, 
												@RequestParam Map<String, String> param,
												HttpServletRequest request,
												BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/login/loginpage");
		try {		
			HttpSession httpSession = request.getSession();
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if(userLoginInfo != null) {
				String view = userLoginInfo.getUserDvsn().equals("USER_DVSN_1") ? "/front/main/mainpage" : "/front/login/loginpage";
				model.setViewName(view);
			} 
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectFrontLoginPage : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@RequestMapping (value="ssoLogin.do")
	public ModelAndView frontSSOLogin(	@RequestParam Map<String, Object> params,
										HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/main/mainpage");
		try {
			UserLoginInfo userLoginInfo = userService.selectSSOUserInfo(params);
			
			if(userLoginInfo != null) {
				HttpSession httpSession = request.getSession();
				httpSession.setAttribute("userLoginInfo",userLoginInfo);
				httpSession.setMaxInactiveInterval(600);
			}
 			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("frontSSOLogin : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@RequestMapping (value="qrEnter.do")
	public ModelAndView selectFrontQrEnterPage(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo,
												@RequestParam("resvSeq") String resvSeq,
												@RequestParam("accessType") String accessType,
												HttpServletRequest request,
												BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/login/qrEnter");
		try {		
			HttpSession httpSession = request.getSession();
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if(userLoginInfo == null && accessType.equals("WEB")) {
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));	
				model.setViewName("/front/main/mainpage");
				return model;
			}
			
			model.addObject("accessType", accessType);
			model.addObject("resvSeq", resvSeq);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectFrontQrEnterPage : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@RequestMapping (value="resvQrInfo.do")
	public ModelAndView selectResvQrInfo(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo, 
											@RequestParam("resvSeq") String resvSeq,
											HttpServletRequest request,
											BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {		
			
			Map<String, Object> resvQrInfo = resvService.selectResvQrInfo(resvSeq);
			model.addObject("resvQrInfo", resvQrInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectResvQrInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
}