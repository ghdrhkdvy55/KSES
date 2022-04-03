package com.kses.backoffice.bas.system.web;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bas.system.service.SystemInfoManageService;
import com.kses.backoffice.bas.system.vo.SystemInfo;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

@RestController
@RequestMapping("/backoffice/bas")
public class SystemInfoManageController {
	private static final Logger LOGGER = LoggerFactory.getLogger(SystemInfoManageController.class);
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;
		
	@Autowired
    protected EgovCcmCmmnDetailCodeManageService detailService;
	
	@Autowired
	SystemInfoManageService systemInfoService;
	
	@RequestMapping(value="systemInfo.do")
	public ModelAndView selectSystemInfo(	@ModelAttribute("loginVO") LoginVO loginVO, 
											@ModelAttribute("searchVO") SystemInfo searchVO, 
											HttpServletRequest request, 
											BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView();
		SystemInfo result = systemInfoService.selectSystemInfo();   	

        model.addObject(Globals.STATUS_REGINFO, result);
        model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
        model.setViewName("/backoffice/bas/systemInfo");
        return model;	
	}
	

	@RequestMapping (value="systemInfoUpdate.do")
	public ModelAndView updateSystemInfo(	@ModelAttribute("loginVO") LoginVO loginVO,
											@RequestBody SystemInfo vo, 
											BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		String meesage = null;
		
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;	
			}
			
			int ret = systemInfoService.updateSystemInfo(vo);
			meesage = "sucess.common.update";
			
			if (ret > 0) {
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
						
			}else {
				throw new Exception();
			}
		} catch (Exception e) {
			LOGGER.error("updateSystemInfo ERROR : " + e.toString());
			meesage = "fail.common.update";
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));			
		}
		
		return model;
	}
}