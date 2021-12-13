package com.kses.backoffice.cus.kko.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.cus.kko.service.KkoMsgManageSevice;
import com.kses.backoffice.cus.kko.vo.KkoMsgInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/companyManage")
public class KkoMsgManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(KkoMsgManageController.class);
	
	
	
	@Autowired
	private KkoMsgManageSevice kkoservice;
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private SmartUtil util;
	
	public ModelAndView selectKkoList(@ModelAttribute("LoginVO") LoginVO loginVO
				                               , @ModelAttribute("kkoinfo") KkoMsgInfo kkoinfo
											   , HttpServletRequest request
											   , BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView();
		try {
			  Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			  if(!isAuthenticated) {
					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
					model.setViewName("/backoffice/login");
					return model;	
			  }else {
		    	   HttpSession httpSession = request.getSession(true);
		    	   loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
		    	   
			  }
			
		      model.setViewName("/backoffice/companyManage/kkolist");
		}catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			LOGGER.info(e.toString() + ':' + ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
		return model;
		
	}
	public ModelAndView selectKkoListAjax(@ModelAttribute("LoginVO") LoginVO loginVO
			                              , @RequestBody Map<String,Object>  searchVO
										  , HttpServletRequest request
										  , BindingResult bindingResult) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			  
		    searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		  
		    LOGGER.info("pageUnit:" + pageUnit);
		  
	              
	   	    PaginationInfo paginationInfo = new PaginationInfo();
		    paginationInfo.setCurrentPageNo( Integer.parseInt( util.NVL(searchVO.get("pageIndex"), "1") ) );
		    paginationInfo.setRecordCountPerPage(pageUnit);
		    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

		    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
			  
			List<Map<String, Object>> seatList = kkoservice.selectKkoMsgInfoList(searchVO);
			int totCnt = seatList.size() > 0 ?  Integer.valueOf( seatList.get(0).get("total_record_count").toString().replace("-", "") ) :0;
			model.addObject(Globals.JSON_RETURN_RESULTLISR, seatList);
		    model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		    paginationInfo.setTotalRecordCount(totCnt);
		    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		    
		    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		}catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			LOGGER.info(e.toString() + ':' + ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
    }
}
