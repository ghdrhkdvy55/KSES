package com.kses.front.login.web;

import com.kses.backoffice.cus.usr.service.UserInfoManageService;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.util.SmartUtil;
import com.kses.front.annotation.LoginUncheck;
import com.kses.front.annotation.ReferrerUncheck;
import com.kses.front.login.vo.UserLoginInfo;
import com.kses.front.resv.AutoPaymentThread;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.property.EgovPropertyService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

@RestController
@RequestMapping("/front/")
public class LoginPageInfoManageController {
	private static final Logger LOGGER = LoggerFactory.getLogger(LoginPageInfoManageController.class);
		
	@Autowired
	protected EgovMessageSource egovMessageSource;
	    
	@Autowired
	protected EgovPropertyService propertiesService;

	@Autowired
	private UserInfoManageService userService;
	
	@Autowired
	private ResvInfoManageService resvService;
	
	@Autowired
	private ApplicationContext applicationContext;
	
	@LoginUncheck
	@RequestMapping (value="actionLogout.do")
	public ModelAndView actionLogout(HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView("redirect:/front/main.do");
		try {		
			HttpSession httpSession = request.getSession();
			httpSession.invalidate();
		} catch(Exception e) {
			LOGGER.error("actionLogout Exception ERROR : " + e.toString());
		}
		return model;
	}
			
	@LoginUncheck
	@RequestMapping (value="userSessionCreate.do")
	public ModelAndView createUserSession(	@RequestBody UserLoginInfo userLoginInfo,
											HttpServletRequest request) throws Exception {
		
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
			
		    HttpSession httpSession = request.getSession();
		    userLoginInfo.setSecretKey(EgovFileScrty.encryptPassword(userLoginInfo.getUserId(),httpSession.getId().getBytes()));
			httpSession.setAttribute("userLoginInfo", userLoginInfo);
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("createUserSession : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping (value="login.do")
	public ModelAndView viewFrontLoginpage(HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/login/loginpage");
		try {		
			HttpSession httpSession = request.getSession();
			UserLoginInfo userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if(userLoginInfo != null) {
				String view = userLoginInfo != null ? "/front/main/mainpage" : "/front/login/loginpage";
				model.setViewName(view);
			} 
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("viewFrontLoginpage : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@LoginUncheck
	@ReferrerUncheck
	@RequestMapping (value="ssoLogin.do")
	public ModelAndView frontSSOLogin(	HttpServletRequest request,
										@RequestParam Map<String, Object> params) throws Exception {
		
		ModelAndView model = new ModelAndView("redirect:/front/main.do");
		try {
			String envType = propertiesService.getString("Globals.envType");
			params.put("envType", envType);
			UserLoginInfo userLoginInfo = userService.selectSSOUserInfo(params);
			
			if(userLoginInfo != null && userLoginInfo.getIndvdlinfoAgreYn().equals("N")) {
				HttpSession httpSession = request.getSession();
				userLoginInfo.setSecretKey(EgovFileScrty.encryptPassword(userLoginInfo.getUserId(),httpSession.getId().getBytes()));
				httpSession.setAttribute("userLoginInfo",userLoginInfo);
			} else {
				String decodeCardId = envType.equals("CLOUD") ? SmartUtil.NVL(params.get("cardId"),"") : userService.selectDecodeCardId(SmartUtil.NVL(params.get("cardId"),""));
				model.addObject("decodeCardId", decodeCardId);
				model.setViewName("/front/login/loginpage");
				return model;
			}
			
			String resvSeq = resvService.selectAutoPaymentResvInfo(userLoginInfo.getUserId());
			if(resvSeq != null) {
				AutoPaymentThread autoPaymentThread = new AutoPaymentThread(resvSeq);
				applicationContext.getAutowireCapableBeanFactory().autowireBean(autoPaymentThread);
				autoPaymentThread.start();
			}
 			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("frontSSOLogin : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@LoginUncheck
	@ReferrerUncheck
	@RequestMapping (value="qrEnter.do")
	public ModelAndView viewFrontQrEnterpage(	HttpServletRequest request,
												@RequestParam("resvSeq") String resvSeq,
												@RequestParam("accessType") String accessType) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/login/qrEnter");
		try {		
			String referer = request.getHeader("referer");
			if(referer == null) {
				if(!accessType.equals("BUTTON")) {
					model.addObject(Globals.STATUS, Globals.STATUS_REFERRERFAIL);
					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.referrer"));
					model.setViewName("/front/main/mainpage");
					return model;
				}
			}
			
			model.addObject("accessType", accessType);
			model.addObject("resvSeq", resvSeq);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("viewFrontQrEnterpage : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
}