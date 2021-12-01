package com.kses.backoffice.sym.log.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.sym.log.service.EgovSysLogService;
import com.kses.backoffice.sym.log.vo.SysLog;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

@RestController
@RequestMapping("/backoffice/sys")
public class SysLogController {
  
     private static final Logger LOGGER = LoggerFactory.getLogger(SysLogController.class);
	
	
  
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
	protected EgovSysLogService sysLogService;
	
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;
	
	@NoLogging
	@RequestMapping(value="syslogList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView selectSysLogList(@ModelAttribute("loginVO") LoginVO loginVO
			                                              , @ModelAttribute("searchVO") SysLog searchVO
			                                              , HttpServletRequest request
														  , BindingResult bindingResult)throws Exception {
		
		      ModelAndView mav = new ModelAndView("SyslogList");
		      try{
		    	  
		    	 Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		 	     if(!isAuthenticated) {
			 	    	mav.addObject("message", egovMessageSource.getMessage("fail.common.login"));
			 	    	mav.setViewName("/backoffice/login");
		 	    		return mav;
		 	     }else{
		 	    	 mav =sysLogService.selectSysLogList(searchVO); 
		 	    	 mav.addObject("status", Globals.STATUS_SUCCESS);
		 	     }
		      }catch(Exception e){
		    	  mav.addObject("message", egovMessageSource.getMessage("fail.common.select"));
		    	  mav.addObject("status", Globals.STATUS_FAIL);
		    	  LOGGER.debug("selectSysLogList error: " + e.toString());
		    	  throw e;
		      }
		      return mav;
	}
	@NoLogging
	@RequestMapping(value="SyslogInfo.do", method = {RequestMethod.POST})
	public ModelAndView selectSysLogInfo(HttpServletRequest request, 
			                                              @RequestBody SysLog log)throws Exception {
		ModelAndView mav = new ModelAndView(Globals.JSONVIEW);
		try{
			 
			 mav.addObject("status", Globals.STATUS_SUCCESS);
			 mav.addObject("sysInfo", sysLogService.selectSysLogInfo(log.getRequstId()));
		}catch(Exception e){
			LOGGER.debug("selectSysLogInfo error: " + e.toString());
			mav.addObject("message",  egovMessageSource.getMessage("fail.common.select"));
	    	mav.addObject("status", Globals.STATUS_FAIL);
	    	//throw e;
		}
		return mav;
	}
	
}
