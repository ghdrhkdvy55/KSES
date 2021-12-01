package com.kses.backoffice.sym.log.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import com.kses.backoffice.sym.log.vo.SysLog;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/sys")
public class SysLogController {
  
     private static final Logger LOGGER = LoggerFactory.getLogger(SysLogController.class);
	
	
  
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
	protected EgovSysLogService sysLogService;
	
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;
	
	@NoLogging
	@RequestMapping(value="syslogList.do")
	public ModelAndView selectSysLogList(@ModelAttribute("loginVO") LoginVO loginVO
                                         , HttpServletRequest request
									     , BindingResult bindingResult)throws Exception {
		
		      ModelAndView mav = new ModelAndView("/backoffice/sys/SyslogList");
		      try{
		    	  
		    	  Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		          if(!isAuthenticated) {
			          	mav.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			          	mav.setViewName("/backoffice/login");
			          	return mav;	
		          } else {
			          	HttpSession httpSession = request.getSession(true);
			          	loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
			      }
		      }catch(Exception e){
		    	  mav.addObject("message", egovMessageSource.getMessage("fail.common.select"));
		    	  mav.addObject("status", Globals.STATUS_FAIL);
		    	  LOGGER.debug("selectSysLogList error: " + e.toString());
		    	  throw e;
		      }
		      return mav;
	}
	@NoLogging
	@RequestMapping(value="selectlogListAjax.do")
	public ModelAndView selectlogListAjax(@ModelAttribute("loginVO") LoginVO loginVO
                                          , @RequestBody Map<String, Object>  searchVO
                                          , HttpServletRequest request
										  , BindingResult bindingResult)throws Exception {
		
		      ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		      try{
		    	  
		    	 Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		 	     if(!isAuthenticated) {
		 	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    			model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
	    			return model;
		 	     }else{
		 	    	 
		 	    	 
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
					
					
		 	     }
		      }catch(Exception e){
		    	  StackTraceElement[] ste = e.getStackTrace();
				  int lineNumber = ste[0].getLineNumber();
				  LOGGER.info("e:" + e.toString() + ":" + lineNumber);
				  model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				  model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		      }
		      return model;
	}
	@NoLogging
	@RequestMapping(value="SyslogInfo.do")
	public ModelAndView selectSysLogInfo(HttpServletRequest request, 
			                             @RequestParam("requestId") String  requestId)throws Exception {
		ModelAndView mav = new ModelAndView(Globals.JSONVIEW);
		try{ 
			 mav.addObject("status", Globals.STATUS_SUCCESS);
			 mav.addObject("sysInfo", sysLogService.selectSysLogInfo(requestId));
		}catch(Exception e){
			LOGGER.debug("selectSysLogInfo error: " + e.toString());
			mav.addObject("message",  egovMessageSource.getMessage("fail.common.select"));
	    	mav.addObject("status", Globals.STATUS_FAIL);
	    	//throw e;
		}
		return mav;
	}
	
}
