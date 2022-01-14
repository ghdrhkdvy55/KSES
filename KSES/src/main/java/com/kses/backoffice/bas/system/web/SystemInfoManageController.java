package com.kses.backoffice.bas.system.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bas.system.service.SystemInfoManageService;
import com.kses.backoffice.bas.system.vo.SystemInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/bas")
public class SystemInfoManageController {
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;
		
	@Autowired
    protected EgovCcmCmmnDetailCodeManageService detailService;
	
	@Autowired
	SystemInfoManageService systemInfoService;
	
	/**
	 * 환경설정 화면
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="systemInfo.do", method = RequestMethod.GET)
	public ModelAndView viewSystemInfo(@ModelAttribute("searchVO") SystemInfo searchVO) throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/bas/systemInfo");
		SystemInfo result = systemInfoService.selectSystemInfo();   	
        model.addObject(Globals.STATUS_REGINFO, result);
        model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
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
			log.error("updateSystemInfo ERROR : " + e.toString());
			meesage = "fail.common.update";
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));			
		}
		
		return model;
	}
}