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
import com.kses.backoffice.bld.center.service.PreOpenInfoManageService;
import com.kses.backoffice.bld.center.vo.PreOpenInfo;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

@RestController
@RequestMapping("/backoffice/bld")
public class PreOpenInfoManageController {

    private static final Logger LOGGER = LoggerFactory.getLogger(PreOpenInfoManageController.class);
    
    @Autowired
    EgovMessageSource egovMessageSource;
    
    @Autowired
    PreOpenInfoManageService preOpenInfoService;
    
    @Autowired
    CenterInfoManageService centerInfoService;
    
    
    @RequestMapping("preOpenInfoListAjax.do")
    public ModelAndView selectPreOpenInfo(	@ModelAttribute("loginVO") LoginVO loginVO,
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
    		List<Map<String, Object>> preOpenInfoList = preOpenInfoService.selectPreOpenInfoList(centerCd);
    		
    		//신규 추가 리스트 값 없을때 처리 
    		String centerNm =   (preOpenInfoList.size() > 0) ? 
    				             preOpenInfoList.get(0).get("center_nm").toString():
    				             centerInfoService.selectCenterInfoDetail(centerCd).get("center_nm").toString();
    			         
    		//신규 추가 
    	    model.addObject(Globals.JSON_RETURN_RESULT, centerNm);
    		model.addObject(Globals .STATUS_REGINFO, preOpenInfoList);
    		
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.select"));
    	} catch (Exception e) {
    		LOGGER.info("selectPreOpenInfo ERROR : " + e.toString());
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
    
    @RequestMapping("preOpenInfoUpdate.do")
    public ModelAndView updatePreOpenInfo(	@ModelAttribute("loginVO") LoginVO loginVO,
    										@RequestBody List<PreOpenInfo> preOpenInfoList,
											HttpServletRequest request) {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	try {
			preOpenInfoService.updatePreOpenInfo(preOpenInfoList);
			
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update"));
		} catch (Exception e) {
    		LOGGER.info("updatePreOpenInfo ERROR : " + e.toString());
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
    
    @RequestMapping("preOpenInfoCopy.do")
    public ModelAndView copyPreOpenInfo(	@ModelAttribute("loginVO") LoginVO loginVO,
    										@RequestBody Map<String, Object> params,
											HttpServletRequest request) {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	try {
			preOpenInfoService.copyPreOpenInfo(params);
			
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