package com.kses.front.mypage;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
	
	@RequestMapping (value="mypage.do")
	public ModelAndView selectFrontMypage(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo,
											@RequestParam Map<String, String> param,
											HttpServletRequest request,
											BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/my/mypage");
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
			LOGGER.error("selectFrontMypage : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@RequestMapping (value="userResvHistory.do")
	public ModelAndView selectFrontUserResvInfopage(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo,
														@RequestParam Map<String, String> param,
														HttpServletRequest request,
														BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/my/userResvHistory");
		try {
			HttpSession httpSession = request.getSession(true);
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			
			if(userLoginInfo == null) {
				userLoginInfo = new UserLoginInfo();
				userLoginInfo.setUserDvsn("USER_DVSN_2");
				httpSession.setAttribute("userLoginInfo", userLoginInfo);
				model.setViewName("redirect:/front/main.do");
				return model;
			}
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectFrontGuestResvInfopage : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@RequestMapping (value="userMyResvInfo.do")
	public ModelAndView selectUserResvInfo(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo,
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
			
			List<Map<String, Object>> userResvInfo = resvService.selectUserMyResvInfo(params);
			
			model.addObject("userResvInfo", userResvInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectFrontGuestResvInfopage : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@RequestMapping (value="guestResvInfo.do")
	public ModelAndView selectFrontGuestResvInfopage(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo,
														@RequestParam Map<String, String> param,
														HttpServletRequest request,
														BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/my/guestResvInfo");
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
			LOGGER.error("selectFrontGuestResvInfopage : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	@RequestMapping (value="guestMyResvInfo.do")
	public ModelAndView selectGuestMyResvInfo(	@ModelAttribute("userLoginInfo") UserLoginInfo userLoginInfo,
												@RequestBody Map<String, Object> params,
												HttpServletRequest request,
												BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession(true);
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
						
			Map<String, Object> guestResvInfo = resvService.selectGuestMyResvInfo(params);
			
			model.addObject("guestResvInfo", guestResvInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectGuestMyResvInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
}