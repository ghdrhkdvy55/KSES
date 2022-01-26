package com.kses.backoffice.rsv.entrance.web;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

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

import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.rsv.entrance.service.EntranceInfoManageService;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.AttendInfo;
import com.kses.backoffice.rsv.reservation.web.ResvInfoManageController;
import com.kses.backoffice.sym.log.vo.LoginLog;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/rsv")
public class EntranceInfoManageController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ResvInfoManageController.class);
	
	@Autowired
	protected EgovPropertyService propertiesService;
	
	@Autowired
	private ResvInfoManageService resvService;
	
    @Autowired
    private EntranceInfoManageService EntranceService;
    
	@Autowired
	private CenterInfoManageService centerInfoManageService;
	
	@RequestMapping(value = "enterRegistList.do")
	public ModelAndView selectLoginLogInf(@ModelAttribute("searchVO") LoginLog loginLog) throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/rsv/enterRegistList");
		
		List<Map<String, Object>> centerInfoComboList =	centerInfoManageService.selectCenterInfoComboList();
		
		model.addObject("centerInfo", centerInfoComboList);
		return model;
	}

	@RequestMapping(value="enterRegistAjax.do")
	public ModelAndView selectEnterRegistInfo(@RequestBody Map<String,Object> searchVO,
											  @ModelAttribute("loginVO") LoginVO loginVO,
											  BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		String nowDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		searchVO.put("searchDayCondition", "resvDate");
		searchVO.put("searchTo", nowDate);
		searchVO.put("searchFrom", nowDate);
		
		loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		searchVO.put("authorCd", loginVO.getAuthorCd());
		searchVO.put("centerCd", loginVO.getCenterCd());
				
		int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
		
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		
		searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		
		List<Map<String, Object>> list = resvService.selectResvInfoManageListByPagination(searchVO);

		
	    model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
	    model.addObject(Globals.STATUS_REGINFO, searchVO);
	    int totCnt = list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
	    
	    paginationInfo.setTotalRecordCount(totCnt);
	    model.addObject("paginationInfo", paginationInfo);
	    model.addObject("totalCnt", totCnt);
		
		return model;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="enterRegistListAjax.do")
	public ModelAndView selectEnterRegistListAjax(@RequestParam("resvSeq") String resvSeq) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		List<AttendInfo> entranceInfo =  (List<AttendInfo>) EntranceService.selectEnterRegistList(resvSeq);
		int totCnt = entranceInfo.size() > 0 ? entranceInfo.size() : 0;
		
		model.addObject(Globals.JSON_RETURN_RESULTLISR, entranceInfo);
		model.addObject(Globals.STATUS_REGINFO, resvSeq);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		
		return model;
	}
}

