package com.kses.backoffice.rsv.longcustomers.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.rsv.longcustomers.service.LongcustomersInfoService;
import com.kses.backoffice.rsv.longcustomers.vo.LongcustomersInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.sym.log.vo.LoginLog;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/rsv")
public class LongcustomersInfoManageController {
	
	@Autowired
	private LongcustomersInfoService longcustomerService;
	
	@Autowired
	protected EgovPropertyService propertiesService;
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
    @Autowired
    private CenterInfoManageService centerService;
	
	/**
	 * 장기예약 화면
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value = "longcustomersList.do", method = RequestMethod.GET)
	public ModelAndView viewLongcustomersList() throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/rsv/longcustomersList");
		
		model.addObject("centerInfo", centerService.selectCenterInfoComboList());
		return model;
	}

	/**
	 * 장기예약 목록 조회
	 * @param searchVO
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "longCustomerListsAjax.do", method = RequestMethod.POST)
	public ModelAndView selectLongcustomerInfo(@RequestBody Map<String,Object> searchVO, 
											   @ModelAttribute("loginVO") LoginVO loginVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		searchVO.put("authorCd", loginVO.getAuthorCd());
		searchVO.put("centerCd", loginVO.getCenterCd());
		
		int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
		
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		searchVO.put("searchFrom", SmartUtil.NVL(searchVO.get("searchFrom"), "").toString());
		searchVO.put("searchTo", SmartUtil.NVL(searchVO.get("searchTo"), "").toString());
		
		List<Map<String, Object>> longcustomerInfo =  longcustomerService.selectLongcustomerList(searchVO);
		int totCnt = longcustomerInfo.size() > 0 ? Integer.valueOf( longcustomerInfo.get(0).get("total_record_count").toString()) : 0;
		paginationInfo.setTotalRecordCount(totCnt);
		
		model.addObject(Globals.JSON_RETURN_RESULTLISR, longcustomerInfo);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

		return model;
	}
	
	/**
	 * 장기예매 하위 예약 목록 조회
	 * @param longResvSeq
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="longcustomerResvInfo.do", method = RequestMethod.GET)
	public ModelAndView selectLongcustomerResvInfo(@RequestParam("longResvSeq") String longResvSeq) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		List<LongcustomersInfo> longcustomerResvInfo =  (List<LongcustomersInfo>) longcustomerService.selectLongcustomerResvList(longResvSeq);
		int totCnt = longcustomerResvInfo.size() > 0 ? longcustomerResvInfo.size()  : 0;
		
		model.addObject(Globals.JSON_RETURN_RESULTLISR, longcustomerResvInfo);
		model.addObject(Globals.STATUS_REGINFO, longResvSeq);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);

		return model;
	}
}