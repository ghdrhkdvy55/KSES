package com.kses.backoffice.stt.dashboard.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.sym.log.annotation.NoLogging;

import egovframework.com.cmm.EgovMessageSource;

@RestController
@RequestMapping("/backoffice/stt")
public class DashboardInfoManageController {
    
    @Autowired
    EgovMessageSource egovMessageSource;	

    /**
     * 통합이용현황 화면
     * @return
     * @throws Exception
     */
    @NoLogging
	@RequestMapping(value="dashboardList.do")
	public ModelAndView viewDashboardList() throws Exception {
		return new ModelAndView("/backoffice/stt/dashboardList"); 
	}
    
}