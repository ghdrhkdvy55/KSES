package com.kses.backoffice.sym.log.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.sym.log.service.LoginLogService;
import com.kses.backoffice.sym.log.vo.LoginLog;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/sys")
public class LoginLogController {
			
	@Autowired
	private LoginLogService loginLogService;

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertyService;
	
	@Autowired
	protected EgovPropertyService propertiesService;
	
	@Autowired
	protected EgovMessageSource egovMessageSource;

	/**
	 * 로그인 로그 화면
	 * @param loginLog
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value = "loginLogList.do", method = RequestMethod.GET)
	public ModelAndView viewLoginLogList(@ModelAttribute("searchVO") LoginLog loginLog) throws Exception {
		return new ModelAndView("/backoffice/sys/loginLogList");
	}
	
	@RequestMapping(value = "selectLoginLogListAjax.do")
	public ModelAndView selectLoginLogInf(@ModelAttribute("LoginVO") LoginVO loginVO, 
										  @RequestBody Map<String,Object> searchVO, 
										  HttpServletRequest request) throws Exception {
		
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
            int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			
			PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
			paginationInfo.setRecordCountPerPage(pageUnit);
			paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
			
			

			searchVO.put("pageSize", propertiesService.getInt("pageSize"));
			searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
			searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
			searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
			searchVO.put("searchBgnDe", SmartUtil.NVL(searchVO.get("searchBgnDe"), "").toString());
			searchVO.put("searchEndDe", SmartUtil.NVL(searchVO.get("searchEndDe"), "").toString());
			
			

			List<Map<String, Object>> loginInfo =  loginLogService.selectLoginLogInfo(searchVO);
			int totCnt = loginInfo.size() > 0 ? Integer.valueOf( loginInfo.get(0).get("total_record_count").toString()) : 0;
			
			model.addObject(Globals.JSON_RETURN_RESULTLISR, loginInfo);
			model.addObject(Globals.PAGE_TOTALCNT, totCnt);
			paginationInfo.setTotalRecordCount(totCnt);
			model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		}catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			log.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
    
	/**
	 * 로그인 로그 상세 조회
	 *
	 * @param loginLog
	 * @param model
	 * @return sym/log/clg/EgovLoginLogInqire
	 * @throws Exception
	 */
	@RequestMapping(value = "LoginLogDetail.do")
	public ModelAndView selectLoginLog(@ModelAttribute("LoginVO") LoginVO loginVO, 
			                           @RequestParam("logId") String logId, 
			                           HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Map<String, Object> vo = loginLogService.selectLoginLogInfoDetail(logId);
		}catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			log.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
		

	}
}
