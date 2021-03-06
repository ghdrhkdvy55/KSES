package com.kses.backoffice.bas.code.web;


import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import com.kses.backoffice.bas.code.service.EgovCcmCmmnCodeManageService;
import com.kses.backoffice.bas.code.vo.CmmnCode;
import com.kses.backoffice.sym.log.annotation.NoLogging;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kses.backoffice.util.service.UniSelectInfoManageService;
import com.kses.backoffice.util.SmartUtil;

@RestController 
@RequestMapping("/backoffice/bas")

public class EgovCcmCmmnCodeManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovCcmCmmnCodeManageController.class);
	
	@Autowired
    private EgovCcmCmmnCodeManageService cmmnCodeManageService;

	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;

	@Autowired
	private UniSelectInfoManageService  uniService;
	
	/**
	 * 공통분류코드 목록 조회
	 * 
	 * @param adminLoginVO
	 * @param searchVO
	 * @param request
	 * @param bindingResult
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value="codeList.do")
	public ModelAndView selectCmmnCodeList(	@ModelAttribute("LoginVO") LoginVO loginVO, 
											HttpServletRequest request,
											BindingResult bindingResult) throws Exception {
    	
    	ModelAndView model = new ModelAndView("/backoffice/bas/codeList");
    	
    	try {
    		
    		//Redirect 처리
    		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
    		if(!isAuthenticated) {
    			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
    			model.setViewName("/backoffice/login");
    			return model;	
    		} else {
    			HttpSession httpSession = request.getSession(true);
    			loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
    			
    		}
    	}catch(Exception e) {
    		StackTraceElement[] ste = e.getStackTrace();
    		LOGGER.info("codeList.do error:" + e.toString() + " : error line =" +  ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
    	}
    	
        return model;
	}
    @RequestMapping(value="codeListAjax.do")
	public ModelAndView selectCmmnCodeListAjax(	@ModelAttribute("LoginVO") LoginVO loginVO
			                                    , @RequestBody Map<String,Object>  searchVO
											    , HttpServletRequest request
											    , BindingResult bindingResult) throws Exception {
    	
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	try {
    		
    		//Redirect 처리
    		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
    		if(!isAuthenticated) {
    			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
    			model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
    			return model;	
    		} 
    		
    		int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			  
		    searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		  
		    LOGGER.info("pageUnit:" + pageUnit);
		  
	              
	   	    PaginationInfo paginationInfo = new PaginationInfo();
		    paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
		    paginationInfo.setRecordCountPerPage(pageUnit);
		    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		    
		    searchVO.put("searchKeyword", SmartUtil.NVL(searchVO.get("searchKeyword"), ""));

		    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		    		    
    		model.addObject(Globals.STATUS_REGINFO, searchVO);
    		LOGGER.info("searchVO:" + searchVO);
    		
    		List<Map<String, Object>> list = cmmnCodeManageService.selectCmmnCodeListByPagination(searchVO);
            model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
            
            int totCnt =  list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
           
            model.addObject(Globals.PAGE_TOTALCNT, totCnt);
            
    		paginationInfo.setTotalRecordCount(totCnt);
            model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
    	}catch(Exception e) {
    		StackTraceElement[] ste = e.getStackTrace();
    		LOGGER.info("codeList.do error:" + e.toString() + " : error line =" +  ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
    	}
    	
        return model;
	}
    
    /**
     * 공통 분류 코드 상세정보 조회
     * 
     * @param codeId
     * @return
     * @throws Exception
     */
  	@RequestMapping ("codeDetail.do")
  	public ModelAndView selectGroupDetail(@RequestParam("codeId") String codeId) throws Exception{
  		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
  		Map<String, Object> cmmCode = cmmnCodeManageService.selectCmmnCodeDetail(codeId);
  		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
  		model.addObject(Globals.STATUS_REGINFO, cmmCode);
  	 	return model;
  	}
	
  	/**
  	 * 공통 분류 코드 수정
  	 * 
  	 * @param adminLoginVO
  	 * @param cmmnCodeVO
  	 * @param request
  	 * @param bindingResult
  	 * @return
  	 * @throws Exception
  	 */
  	@RequestMapping (value="codeUpdate.do")
  	public ModelAndView updateCmmCode(	@ModelAttribute("LoginVO") LoginVO LoginVO, 
  										@RequestBody CmmnCode cmmnCode, 
  										HttpServletRequest request,
  										RedirectAttributes redirect,
  										BindingResult bindingResult) throws Exception {
  		
  		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
  		
  		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;
			} else {
				HttpSession httpSession = request.getSession(true);
				LoginVO = (LoginVO)httpSession.getAttribute("LoginVO");
				cmmnCode.setFrstRegisterId(LoginVO.getAdminId());
				cmmnCode.setLastUpdusrId(LoginVO.getAdminId());
			}
  			
            String message = "";
  			int ret  = 0;  	    	
  	        message = cmmnCode.getMode().equals("Ins") ? "sucess.common.insert" : "sucess.common.update";
  	        ret = cmmnCodeManageService.updateCmmnCode(cmmnCode);
  	        
  	        if (ret > 0) {
  	        	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
  	        	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(message));			
			} else {
				throw new Exception();
			}
  		} catch(Exception e) {
  			LOGGER.debug("ERROR : " + e.toString());
  			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
  			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.update"));			
  		}
  		
  		return model;
  	}
  	
	/**
	 * 공통코드를 삭제한다.
	 * @param AdminLoginVO
	 * @param cmmnCode
	 * @param model
	 * @return "forward:/sym/ccm/cca/EgovCcmCmmnCodeList.do"
	 * @throws Exception
	 */
    @RequestMapping(value="codeDelete.do")
	public ModelAndView deleteCmmnCode(	@ModelAttribute("LoginVO") LoginVO loginVO, 
			                             @RequestBody Map<String,Object> cmmnCode, 
										HttpServletRequest request,
										RedirectAttributes redirect,
										BindingResult bindingResult) throws Exception {
    	
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	try {
    		
    		cmmnCodeManageService.deleteCmmnCode(cmmnCode.get("codeId").toString());
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));    		
    	} catch(Exception e) {
    		LOGGER.info(e.toString());
    		redirect.addAttribute(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
    	}
        return model;
	}

    /**
     * 공통분류코드 코드값 중복 체크
     * 
     * @param request
     * @param codeId
     * @return
     * @throws Exception
     */
    @NoLogging
    @RequestMapping (value="codeIDCheck.do")
    public ModelAndView selectIdCheck(	HttpServletRequest request, 
    									@RequestParam("codeId") String codeId )throws Exception{
    	
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	try {
    		String result = uniService.selectIdDoubleCheck("CODE_ID", "COMTCCMMNCODE", "CODE_ID = ["+ codeId + "[") > 0 ? "FAIL" : "OK";
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.JSON_RETURN_RESULT, result);
    		
    	} catch(Exception e) {
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
    	}
    	return model;
    }
}