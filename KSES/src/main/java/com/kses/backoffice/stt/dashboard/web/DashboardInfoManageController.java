package com.kses.backoffice.stt.dashboard.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;


@RestController
@RequestMapping("/backoffice/stt")
public class DashboardInfoManageController {

    private static final Logger LOGGER = LoggerFactory.getLogger(DashboardInfoManageController.class);
    
    @Autowired
    EgovMessageSource egovMessageSource;	

	@RequestMapping(value="dashboardList.do")
	public ModelAndView selectBlackUserInfoList(	@ModelAttribute("loginVO") LoginVO loginVO,
													HttpServletRequest request, 
													BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/stt/dashboardList"); 
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
				return model;	
			} else {
		       HttpSession httpSession = request.getSession(true);
		       loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
			}			
		    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectDashboardInfoList : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;	
	}
    
}