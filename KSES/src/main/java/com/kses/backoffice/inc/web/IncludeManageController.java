package com.kses.backoffice.inc.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.sym.log.annotation.NoLogging;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

@RestController
public class IncludeManageController {

	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@NoLogging
	@RequestMapping(value="/backoffice/inc/top_inc.do")
	public ModelAndView smartworkTop(HttpServletRequest request) throws Exception{		
		ModelAndView model = new ModelAndView("/backoffice/inc/top_inc");
		
		return model;
	}
	@NoLogging
	@RequestMapping(value="/backoffice/inc/user_menu.do")
	public ModelAndView smartworkUserMenu(HttpServletRequest request) throws Exception{		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if(!isAuthenticated) {
			model.addObject("message", egovMessageSource.getMessage("fail.common.login"));
			model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
			return model;	
		} else {
			
			HttpSession httpSession = request.getSession(true);
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> menu =  (List<Map<String, Object>>) httpSession.getAttribute("Menu");
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.JSON_RETURN_RESULTLISR, menu);
		}
		return model;
	}
	@NoLogging
	@RequestMapping(value="/backoffice/inc/popup_common.do")
	public ModelAndView smartworkPopup() throws Exception{		
		ModelAndView model = new ModelAndView("/backoffice/inc/popup_common");
		return model;
	}
	/*
	@NoLogging
	@RequestMapping(value="/backoffice/inc/bottom_inc.do")	
	public ModelAndView smartworkBottom() throws Exception{				
		ModelAndView model = new ModelAndView();
		
		
		model.setViewName("/backoffice/inc/bottom_inc");
		return model;		
	}
	*/
	@NoLogging
	@RequestMapping(value="/backoffice/inc/uni_pop.do")	
	public ModelAndView smartworkPop() throws Exception{				
		ModelAndView model = new ModelAndView();
		
		model.setViewName("/backoffice/inc/back_uniPop");
		return model;		
	}
}
