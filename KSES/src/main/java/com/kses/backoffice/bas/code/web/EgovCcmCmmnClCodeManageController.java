package com.kses.backoffice.bas.code.web;

import java.util.List;
import java.util.Map;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import com.kses.backoffice.bas.code.service.EgovCcmCmmnClCodeManageService;
import com.kses.backoffice.bas.code.vo.CmmnClCode;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class EgovCcmCmmnClCodeManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovCcmCmmnClCodeManageController.class);
	
	@Autowired
    private EgovCcmCmmnClCodeManageService cmmnClCodeManageService;

    /** EgovPropertyService */
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	protected EgovMessageSource egovMessageSource;

	/**
	 * 공통분류코드를 삭제한다.
	 * @param loginVO
	 * @param cmmnClCode
	 * @param model
	 * @return "forward:/sym/ccm/ccc/EgovCcmCmmnClCodeList.do"
	 * @throws Exception
	 */
    @RequestMapping(value="/sym/ccm/ccc/EgovCcmCmmnClCodeRemove.do")
	public String deleteCmmnClCode (@ModelAttribute("LoginVO") LoginVO loginVO
			, CmmnClCode cmmnClCode
			, ModelMap model
			) throws Exception {
    	 cmmnClCodeManageService.deleteCmmnClCode(cmmnClCode);
        return "forward:/sym/ccm/ccc/EgovCcmCmmnClCodeList.do";
	}

	/**
	 * 공통분류코드를 등록한다.
	 * @param loginVO
	 * @param cmmnClCode
	 * @param bindingResult
	 * @return "/cmm/sym/ccm/EgovCcmCmmnClCodeRegist"
	 * @throws Exception
	 */
    @RequestMapping(value="/sym/ccm/ccc/EgovCcmCmmnClCodeRegist.do")
	public String insertCmmnClCode(	@ModelAttribute("LoginVO") LoginVO loginVO, 
									@ModelAttribute("cmmnClCode") CmmnClCode cmmnClCode, 
									ModelMap model, 
									BindingResult bindingResult) throws Exception {
    	
    	Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
        if(!isAuthenticated) {
    		model.addAttribute("message", egovMessageSource.getMessage("fail.common.login"));
    		return "/backoffice/login";
        }
        
    	if (cmmnClCode.getClCode() == null ||cmmnClCode.getClCode().equals("")) {
    		return "/cmm/sym/ccm/EgovCcmCmmnClCodeRegist";
    	}
		
    	if (bindingResult.hasErrors()){
    		return "/cmm/sym/ccm/EgovCcmCmmnClCodeRegist";
		}

    	cmmnClCode.setFrstRegisterId(EgovUserDetailsHelper.getAuthenticatedUser().toString());
    	cmmnClCodeManageService.updateCmmnClCode(cmmnClCode);
        return "forward:/sym/ccm/ccc/EgovCcmCmmnClCodeList.do";
    }

	/**
	 * 공통분류코드 상세항목을 조회한다.
	 * @param loginVO
	 * @param cmmnClCode
	 * @param model
	 * @return "cmm/sym/ccm/EgovCcmCmmnClCodeDetail"
	 * @throws Exception
	 */
	@RequestMapping(value="/sym/ccm/ccc/EgovCcmCmmnClCodeDetail.do")
 	public String selectCmmnClCodeDetail(	@ModelAttribute("LoginVO") LoginVO loginVO, 
 											CmmnClCode cmmnClCode, 
 											ModelMap model) throws Exception {
		//공용 확인 하기 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
        if(!isAuthenticated) {
    		model.addAttribute("message", egovMessageSource.getMessage("fail.common.login"));
    		return "/backoffice/login";
        }
	       
		Map<String, Object> vo = cmmnClCodeManageService.selectCmmnClCodeDetail(cmmnClCode.getClCode());
		model.addAttribute("result", vo);

		return "cmm/sym/ccm/EgovCcmCmmnClCodeDetail";
	}

    /**
	 * 공통분류코드 목록을 조회한다.
     * @param loginVO
     * @param searchVO
     * @param model
     * @return "/cmm/sym/ccm/EgovCcmCmmnClCodeList"
     * @throws Exception
     */
    @RequestMapping(value="/sym/ccm/ccc/EgovCcmCmmnClCodeList.do")
	public String selectCmmnClCodeList(	@ModelAttribute("LoginVO") LoginVO loginVO, 
										@RequestBody Map<String, Object> searchVO, 
										ModelMap model) throws Exception {

    	Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
        if(!isAuthenticated) {
    		model.addAttribute("message", egovMessageSource.getMessage("fail.common.login"));
    		return "/backoffice/login";
        }
        
        int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
		int pageSize = searchVO.get("pageSize") == null ?   propertiesService.getInt("pageSize") : Integer.valueOf((String) searchVO.get("pageSize"));  
	   
	    
    	/** pageing */
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo( Integer.valueOf( searchVO.get("pageIndex").toString() ));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(pageSize);

		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
	    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
	    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
	    
	    List<Map<String, Object>> codeList = (List<Map<String, Object>>) cmmnClCodeManageService.selectCmmnClCodeList(searchVO);
	    int totCnt = codeList.size() > 0 ?  Integer.valueOf( codeList.get(0).get("total_record_count").toString().replace("-", "") ) :0;
        model.addAttribute("resultList", codeList);

		paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);

        return "/cmm/sym/ccm/EgovCcmCmmnClCodeList";
	}

	/**
	 * 공통분류코드를 수정한다.
	 * @param loginVO
	 * @param cmmnClCode
	 * @param bindingResult
	 * @param commandMap
	 * @param model
	 * @return "/cmm/sym/ccm/EgovCcmCmmnClCodeModify"
	 * @throws Exception
	 */
    @RequestMapping(value="/sym/ccm/ccc/EgovCcmCmmnClCodeModify.do")
	public String updateCmmnClCode(	@ModelAttribute("LoginVO") LoginVO loginVO, 
									@ModelAttribute("administCode") CmmnClCode cmmnClCode, 
									BindingResult bindingResult, 
									@RequestParam Map <String, Object> commandMap, 
									ModelMap model) throws Exception {
    	
    	Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
        if(!isAuthenticated) {
    		model.addAttribute("message", egovMessageSource.getMessage("fail.common.login"));
    		return "/backoffice/login";
        }
        
		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");
    	if (sCmd.equals("")) {
    		Map<String, Object> vo = cmmnClCodeManageService.selectCmmnClCodeDetail(cmmnClCode.getClCode());
    		model.addAttribute("cmmnClCode", vo);

    		return "/cmm/sym/ccm/EgovCcmCmmnClCodeModify";
    	} else if (sCmd.equals("Modify")) {
    		if (bindingResult.hasErrors()){
    			Map<String, Object> vo = cmmnClCodeManageService.selectCmmnClCodeDetail(cmmnClCode.getClCode());
        		model.addAttribute("cmmnClCode", vo);
        		return "/cmm/sym/ccm/EgovCcmCmmnClCodeModify";
    		}
    		cmmnClCode.setLastUpdusrId(EgovUserDetailsHelper.getAuthenticatedUser().toString());
	    	cmmnClCodeManageService.updateCmmnClCode(cmmnClCode);
	        return "forward:/sym/ccm/ccc/EgovCcmCmmnClCodeList.do";
    	} else {
    		return "forward:/sym/ccm/ccc/EgovCcmCmmnClCodeList.do";
    	}
    }
}