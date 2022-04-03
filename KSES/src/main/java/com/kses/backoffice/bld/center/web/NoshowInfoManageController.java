package com.kses.backoffice.bld.center.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.center.service.NoshowInfoManageService;
import com.kses.backoffice.bld.center.vo.NoshowInfo;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

@RestController
@RequestMapping("/backoffice/bld")
public class NoshowInfoManageController {

    private static final Logger LOGGER = LoggerFactory.getLogger(NoshowInfoManageController.class);
    
    @Autowired
    EgovMessageSource egovMessageSource;
    
    @Autowired
    NoshowInfoManageService noshowInfoService;
    
    @Autowired
    CenterInfoManageService centerInfoService;
    
    @RequestMapping("noshowInfoListAjax.do")
    public ModelAndView selectNoshownfo(	@ModelAttribute("loginVO") LoginVO loginVO,
    										@RequestParam("centerCd") String centerCd,
    										HttpServletRequest request) {
    	
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
			return model;	
		} else {
			HttpSession httpSession = request.getSession(true);
			loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
		}
    	
    	try {
    		List<Map<String, Object>> noshowInfoList = noshowInfoService.selectNoshowInfoList(centerCd);
    		String centerNm =   (noshowInfoList.size() > 0) ? 
    							 noshowInfoList.get(0).get("center_nm").toString():
    							 centerInfoService.selectCenterInfoDetail(centerCd).get("center_nm").toString();
    		
    		
    		model.addObject(Globals.JSON_RETURN_RESULT, centerNm);
    		model.addObject(Globals.STATUS_REGINFO, noshowInfoList);
    		
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.select"));
    	} catch (Exception e) {
    		LOGGER.info("selectNoshownfo ERROR : " + e.toString());
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
    
    @RequestMapping("noshowInfoUpdate.do")
    public ModelAndView updateNoshownfo(	@ModelAttribute("loginVO") LoginVO loginVO,
    										@RequestBody List<NoshowInfo> noshowInfoList,
											HttpServletRequest request) {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	try {
			noshowInfoService.updateNoshowInfo(noshowInfoList);
			
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update"));
		} catch (Exception e) {
    		LOGGER.info("updateNoshownfo ERROR : " + e.toString());
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
    
    @RequestMapping("noshowInfoCopy.do")
    public ModelAndView copyPreOpenInfo(	@ModelAttribute("loginVO") LoginVO loginVO,
    										@RequestBody Map<String, Object> params,
											HttpServletRequest request) {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	try {
    		noshowInfoService.copyNoshowInfo(params);
			
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update"));
		} catch (Exception e) {
    		LOGGER.info("copyPreOpenInfo ERROR : " + e.toString());
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
    
}