package com.kses.backoffice.sym.log.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.sym.log.service.InterfaceInfoManageService;
import com.kses.backoffice.util.SmartUtil;


import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/backoffice/sys")
public class InterfaceController {
	
	@Autowired
	private InterfaceInfoManageService interService;
	
	@Autowired
	protected EgovPropertyService propertiesService;
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@RequestMapping(value = "interfaceLog.do", method = RequestMethod.GET)
	public ModelAndView selectLoginLogInf() throws Exception {		
		return new ModelAndView("/backoffice/sys/interfaceLog");
	}
	
	@RequestMapping(value = "selectInterfaceListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectLoginLogInf(@RequestBody Map<String,Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit") 
				: Integer.valueOf((String) searchVO.get("pageUnit"));
		
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		searchVO.put("searchFrom", SmartUtil.NVL(searchVO.get("searchFrom"), "").toString());
		searchVO.put("searchTo", SmartUtil.NVL(searchVO.get("searchTo"), "").toString());
		
		model.addObject(Globals.STATUS_REGINFO, searchVO);
		log.info("searchVO:" + searchVO);
		
		List<Map<String, Object>> list =  interService.selectInterfaceLogInfo(searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		
		int totCnt = list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		
		paginationInfo.setTotalRecordCount(totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			
		return model;
	}
/*	@RequestMapping(value = "selectInterfaceDetail.do")
	public ModelAndView selectLoginLog(@ModelAttribute("LoginVO") LoginVO loginVO, 
			                           @RequestParam("requstId") String requstId, 
			                           HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, interService.selectInterfaceDetail(requstId));
		}catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}*/

}
