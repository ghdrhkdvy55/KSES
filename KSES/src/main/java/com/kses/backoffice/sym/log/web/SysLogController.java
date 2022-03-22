package com.kses.backoffice.sym.log.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.sym.log.service.EgovSysLogService;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/sys")
public class SysLogController {
  
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
	protected EgovSysLogService sysLogService;
	
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;
	
	/**
	 * 시스템 로그 화면
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="syslogList.do", method = RequestMethod.GET)
	public ModelAndView viewSyslogList() throws Exception {
	      return new ModelAndView("/backoffice/sys/syslogList");
	}
	
	@NoLogging
	@RequestMapping(value="selectlogListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectlogListAjax(@RequestBody Map<String, Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

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

		List<Map<String, Object>> loginInfo =  sysLogService.selectSysLogList(searchVO);
		int totCnt = loginInfo.size() > 0 ? Integer.valueOf( loginInfo.get(0).get("total_record_count").toString()) : 0;
			
		model.addObject(Globals.JSON_RETURN_RESULTLISR, loginInfo);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

		return model;
	}
//	@NoLogging
//	@RequestMapping(value="selectlogInfoDetail.do")
//	public ModelAndView selectlogInfoDetail(HttpServletRequest request, 
//			                             @RequestParam("requstId") String  requstId)throws Exception {
//		ModelAndView mav = new ModelAndView(Globals.JSONVIEW);
//		try{ 
//			 mav.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//			 mav.addObject(Globals.STATUS_REGINFO, sysLogService.selectSysLogInfo(requstId));
//		}catch(Exception e){
//			StackTraceElement[] ste = e.getStackTrace();
//			int lineNumber = ste[0].getLineNumber();
//			log.info("e:" + e.toString() + ":" + lineNumber);
//			mav.addObject(Globals.STATUS_MESSAGE,  egovMessageSource.getMessage("fail.common.select"));
//	    	mav.addObject(Globals.STATUS, Globals.STATUS_FAIL);
//	    	//throw e;
//		}
//		return mav;
//	}
	
}
