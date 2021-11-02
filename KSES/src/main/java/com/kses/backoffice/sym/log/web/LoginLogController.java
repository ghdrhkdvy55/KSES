package com.kses.backoffice.sym.log.web;


import java.util.Map;
import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kses.backoffice.sym.log.service.LoginLogService;
import com.kses.backoffice.sym.log.vo.LoginLog;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
public class LoginLogController {

	@Resource(name="LoginLogService")
	private LoginLogService loginLogService;

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertyService;

	/**
	 * 로그인 로그 목록 조회
	 *
	 * @param loginLog
	 * @return sym/log/clg/EgovLoginLogList
	 * @throws Exception
	 */
	/*
	@RequestMapping(value = "/sym/log/clg/SelectLoginLogList.do")
	public String selectLoginLogInf(@ModelAttribute("searchVO") LoginLog loginLog
			                        , ModelMap model) throws Exception {
		System.out.println("eeee:::" + loginLog);
		loginLog.setPageUnit(propertyService.getInt("pageUnit"));
		loginLog.setPageSize(propertyService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(loginLog.getPageIndex());
		paginationInfo.setRecordCountPerPage(loginLog.getPageUnit());
		paginationInfo.setPageSize(loginLog.getPageSize());

		loginLog.setFirstIndex(paginationInfo.getFirstRecordIndex());
		loginLog.setLastIndex(paginationInfo.getLastRecordIndex());
		loginLog.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		loginLog.setSearchBgnDe(loginLog.getSearchBgnDe().replaceAll("-", ""));
		loginLog.setSearchEndDe(loginLog.getSearchEndDe().replaceAll("-", ""));

		HashMap<?, ?> _map = (HashMap<?, ?>) loginLogService.selectLoginLogInf(loginLog);
		int totCnt = Integer.parseInt((String) _map.get("resultCnt"));

		model.addAttribute("resultList", _map.get("resultList"));
		model.addAttribute("resultCnt", _map.get("resultCnt"));
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "sym/log/clg/EgovLoginLogList";
	}
    */
	/**
	 * 로그인 로그 상세 조회
	 *
	 * @param loginLog
	 * @param model
	 * @return sym/log/clg/EgovLoginLogInqire
	 * @throws Exception
	 */
	@RequestMapping(value = "/sym/log/clg/InqireLoginLog.do")
	public String selectLoginLog(@ModelAttribute("searchVO") LoginLog loginLog, 
			                     @RequestParam("logId") String logId, 
			                     ModelMap model) throws Exception {

		loginLog.setLogId(logId.trim());

		Map<String, Object> vo = loginLogService.selectLoginLogInfoDetail(logId);
		model.addAttribute("result", vo);
		return "sym/log/clg/EgovLoginLogInqire";
	}
}
