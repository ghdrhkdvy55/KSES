package com.kses.backoffice.stt.dashboard.web;

import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.stt.dashboard.service.DashboardInfoManageService;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/backoffice/stt")
public class DashboardInfoManageController {

	@Autowired
	DashboardInfoManageService dashboardInfoManageService;
	
	@Autowired
	CenterInfoManageService centerService;
	
    @Autowired
    EgovMessageSource egovMessageSource;

	/**
	 * 통합이용현황 화면
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="dashboardList.do", method = RequestMethod.GET)
	public ModelAndView dashboardList() throws Exception {
		ModelMap model = new ModelMap();
		model.addAttribute("entryMaximumNumber", dashboardInfoManageService.selectEntryMaximumNumber());
		return new ModelAndView("/backoffice/stt/dashboardList", model);
	}

	/**
	 * 총예약인원 수 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="todayResvNumberAjax.do", method = RequestMethod.POST)
	public ModelAndView selectTodayResvNumber() throws Exception {
		ModelMap model = new ModelMap();
		List<String> resvStates = Arrays.asList(new String[] { "RESV_STATE_1", "RESV_STATE_2", "RESV_STATE_3" });
		model.addAttribute("todayResvNumber", dashboardInfoManageService.selectTodayResvNumber(resvStates));
		model.addAttribute(Globals.STATUS, Globals.STATUS_SUCCESS);
		return new ModelAndView(Globals.JSONVIEW, model);
	}

	/**
	 * 현재입장인원 수 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="nowEntryNumberAjax.do", method = RequestMethod.POST)
	public ModelAndView selectNowEntryNumber() throws Exception {
		ModelMap model = new ModelMap();
		List<String> resvStates = Arrays.asList(new String[] { "RESV_STATE_2", "RESV_STATE_3" });
		model.addAttribute("nowEntryNumber", dashboardInfoManageService.selectTodayResvNumber(resvStates));
		model.addAttribute(Globals.STATUS, Globals.STATUS_SUCCESS);
		return new ModelAndView(Globals.JSONVIEW, model);
	}

	/**
	 * 통합이용현황 목록 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="dashboardListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectDashboardList() throws Exception {
		ModelMap model = new ModelMap();
		model.addAttribute("dashboardList", dashboardInfoManageService.selectDashboardList());
		model.addAttribute(Globals.STATUS, Globals.STATUS_SUCCESS);
		return new ModelAndView(Globals.JSONVIEW, model);
	}
	
	/**
	 * 지점별 이용통계 화면
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="dashboardByCenterList.do", method = RequestMethod.GET)
	public ModelAndView dashboardByCenterList() throws Exception {
		ModelMap model = new ModelMap();
		model.addAttribute("centerList", centerService.selectCenterInfoComboList());
		model.addAttribute(Globals.STATUS, Globals.STATUS_SUCCESS);
		return new ModelAndView("/backoffice/stt/dashboardByCenterList", model);
	}
	
	/**
	 * 지점별 이용통계 화면
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="dashboardByCenterListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectDashboardByCenterList(	HttpServletRequest request,
														@RequestBody Map<String,Object> params) throws Exception {
		ModelMap model = new ModelMap();
		List<Map<String, Object>> usageStatList = dashboardInfoManageService.selectCenterUsageStatList(params);
		usageStatList.add(dashboardInfoManageService.selectCenterUsageStatTotal(params));
		
		model.addAttribute("usageStatList", usageStatList);
		model.addAttribute(Globals.STATUS, Globals.STATUS_SUCCESS);
		return new ModelAndView(Globals.JSONVIEW, model);
	}
}