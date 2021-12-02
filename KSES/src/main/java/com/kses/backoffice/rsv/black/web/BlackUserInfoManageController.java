package com.kses.backoffice.rsv.black.web;

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

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.rsv.black.service.BlackUserInfoManageService;
import com.kses.backoffice.rsv.black.vo.BlackUserInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/rsv")
public class BlackUserInfoManageController {

    private static final Logger LOGGER = LoggerFactory.getLogger(BlackUserInfoManageController.class);
    
    @Autowired
    EgovMessageSource egovMessageSource;
	
    @Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private EgovCcmCmmnDetailCodeManageService codeDetailService;
	
	@Autowired
	BlackUserInfoManageService blackUserService;

	@RequestMapping(value="blackList.do")
	public ModelAndView selectBlackUserInfoList(	@ModelAttribute("loginVO") LoginVO loginVO, 
													@ModelAttribute("searchVO") BlackUserInfo searchVO, 
													HttpServletRequest request, 
													BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/rsv/blackList"); 
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
				return model;	
			} else {
		       HttpSession httpSession = request.getSession(true);
		       loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
			}
			
			model.addObject("blklstDvsn", codeDetailService.selectCmmnDetailCombo("BLKLST_DVSN"));
			
		    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectBlackUserInfoList : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;	
	}
    
	@RequestMapping(value="blackListAjax.do")
	public ModelAndView selectCenterAjaxInfo(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestBody Map<String,Object> searchVO, 
												HttpServletRequest request, 
												BindingResult bindingResult	) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		try {
			  int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			  
			  searchVO.put("pageSize", propertiesService.getInt("pageSize"));
			  
			  LOGGER.debug("------------------------pageUnit : " + pageUnit);
			  
			  //Paging
		   	  PaginationInfo paginationInfo = new PaginationInfo();
			  paginationInfo.setCurrentPageNo(Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
			  paginationInfo.setRecordCountPerPage(pageUnit);
			  paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
			  
			  searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
			  searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
			  searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
			  
			  LOGGER.debug("pageUnit End");
			  List<Map<String, Object>> list = blackUserService.selectBlackUserInfoManageListByPagination(searchVO);
			  LOGGER.debug("[-------------------------------------------list:" + list.size() + "------]");
		      model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		      model.addObject(Globals.STATUS_REGINFO, searchVO);
		      int totCnt = list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		      
		      LOGGER.debug("totCnt:" + totCnt);
		      
		      paginationInfo.setTotalRecordCount(totCnt);
		      model.addObject("paginationInfo", paginationInfo);
		      model.addObject("totalCnt", totCnt);
		      
		} catch(Exception e) {
			LOGGER.debug("---------------------------------------");
			StackTraceElement[] ste = e.getStackTrace();
			LOGGER.error(e.toString() + ":" + ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
		return model;
	}
	
	@RequestMapping (value="updateBlackUserInfo.do")
	public ModelAndView updateCenterInfo(	@ModelAttribute("LoginVO") LoginVO loginVO, 
											@RequestBody BlackUserInfo vo,
											HttpServletRequest request,
											BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		String meesage = "";
		
		try {
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				return model;
			} else {
				loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
				vo.setAdminId(loginVO.getAdminId());
			}
	
			meesage = vo.getMode().equals("Ins") ? "sucess.common.insert" : "sucess.common.update";

			int ret = blackUserService.updateBlackUserInfoManage(vo);
			
			if(ret > 0) {
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			} else {
				throw new Exception();
			}
		} catch (Exception e){
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		return model;
	}
}