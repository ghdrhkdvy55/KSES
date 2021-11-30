package com.kses.backoffice.bas.code.web;


import java.util.List;
import java.util.Map;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bas.code.vo.CmmnDetailCode;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;


@RestController
@RequestMapping("/backoffice/bas")
public class EgovCcmCmmnDetailCodeManageController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovCcmCmmnDetailCodeManageController.class);

	@Autowired
    private EgovCcmCmmnDetailCodeManageService cmmnDetailCodeManageService;

	@Autowired
	protected EgovMessageSource egovMessageSource;
	
    /** EgovPropertyService */
	@Autowired
    protected EgovPropertyService propertiesService;

	

	/**
	 * 공통상세코드를 삭제한다.
	 * @param loginVO
	 * @param cmmnDetailCode
	 * @param model
	 * @return "forward:/sym/ccm/cde/EgovCcmCmmnDetailCodeList.do"
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
    @RequestMapping(value="codeDetailCodeDelete.do")
	public ModelAndView deleteCmmnDetailCode (@ModelAttribute("loginVO") LoginVO loginVO,
			                                  @RequestParam("code") String code,
			                                  ModelMap modelMe,
			                                  HttpServletRequest request) throws Exception {
    	
    	
    	ModelAndView model = new 	ModelAndView(Globals.JSONVIEW);
    	try{
    		
    		
    		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
            if(!isAuthenticated) {
            	modelMe.addAttribute(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
            	model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
        		return model;
            }
            
    		
    		int ret = cmmnDetailCodeManageService.deleteCmmnDetailCode(code);
    		if (ret > 0) {
    			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    			model.addObject("resutl", ret );   	
    		}else {
    			new Exception();
    		}
    	}catch(Exception e){
    		LOGGER.error("codeDetailCodeDelete ERROR:" + e.toString());
	    	model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
    		return model;
    	}
    	return model;
	}

	/**
	* 공통상세코드 상세항목을 조회한다.
	* @param loginVO
	 * @param cmmnDetailCode
	 * @param model
	 * @return "cmm/sym/ccm/EgovCcmCmmnDetailCodeDetail"
	 * @throws Exception
	 */
	@RequestMapping(value="CcmCmmnDetailCodeDetail.do")	
 	public ModelMap selectCmmnDetailCodeDetail (@ModelAttribute("loginVO") LoginVO loginVO
									 			, CmmnDetailCode cmmnDetailCode
									 			, ModelMap model)	throws Exception {
    	CmmnDetailCode vo = cmmnDetailCodeManageService.selectCmmnDetailCodeDetail(cmmnDetailCode);
		model.addAttribute("result", vo);
		return model;
	}
	
    /**
	 * 공통상세코드 목록을 조회한다.
     * @param loginVO
     * @param searchVO
     * @param model 
     * @throws Exception
     */
	@SuppressWarnings("unchecked")
    @RequestMapping(value="CmmnDetailCodeList.do")
    public ModelAndView selectCmmnDetailCodeList ( @ModelAttribute("LoginVO") LoginVO loginVO,
    		                                       @RequestBody CmmnDetailCode vo, 
    		                                       HttpServletRequest request)  {
    	//나중에 권한 설정 값 넣기 
    	
    	
    	ModelAndView model = new 	ModelAndView(Globals.JSONVIEW);
    	try{
    		
            List<CmmnDetailCode> codeDetailList = (List<CmmnDetailCode>) cmmnDetailCodeManageService.selectCmmnDetailCodeList(vo.getCodeId());
            int totCnt = codeDetailList.size() > 0 ? codeDetailList.size()  : 0;
            model.addObject(Globals.JSON_RETURN_RESULTLISR, codeDetailList);
            model.addObject( Globals.STATUS_REGINFO, vo.getCodeId());
            model.addObject(Globals.PAGE_TOTALCNT, totCnt);
            return model;
    	}catch(Exception e){
    		LOGGER.error("CmmnDetailView ERROR:" + e.toString());
	    	model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.select"));
    		return model;
    	}    	
	}
    @RequestMapping(value="CmmnDetailView.do")
    public ModelAndView CmmnDetailView (@ModelAttribute("loginVO") LoginVO loginVO
							            , @RequestParam("code") String code
                                     	, BindingResult bindingResult ) throws Exception {
    	     ModelAndView model = new 	ModelAndView(Globals.JSONVIEW);
    	     try{
    	    	 Map<String, Object> cmmDetail = cmmnDetailCodeManageService.selectCmmnDetail(code);
    	    	 
    	    	 LOGGER.debug("cmmDetail:" + cmmDetail);
    	    	 model.addObject(Globals.STATUS_REGINFO, cmmDetail);
        	     model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    	     }catch(Exception e){
    	    	 LOGGER.error("CmmnDetailView ERROR:" + e.toString());
    	    	 model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    	    	 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.select"));
    	     }
    	    return model;
    }
    /*
     *  신규 코드 
     * 
     */
    @RequestMapping(value="CmmnDetailAjax.do")
    public ModelAndView CmmnDetailAjax (@ModelAttribute("loginVO") LoginVO loginVO
							            , @RequestParam("codeId") String codeId ) throws Exception {
    	     ModelAndView model = new 	ModelAndView(Globals.JSONVIEW);
    	     try{
    	    	 
    	    	 model.addObject(Globals.JSON_RETURN_RESULTLISR, cmmnDetailCodeManageService.selectCmmnDetailAjaxCombo(codeId)  );
        	     model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    	     }catch(Exception e){
    	    	 LOGGER.error("CmmnDetailView ERROR:" + e.toString());
    	    	 model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    	    	 model.addObject("message", egovMessageSource.getMessage("fail.common.select"));
    	     }
    	    return model;
    }
    @SuppressWarnings("unchecked")
    @RequestMapping(value="CodeDetailUpdate.do")
	public ModelAndView updateCmmnDetailCode (@ModelAttribute("loginVO") LoginVO loginVO
			                                  , @RequestBody CmmnDetailCode vo
			                                  , ModelMap modelMe
											  , BindingResult bindingResult ) throws Exception {
    	
    	ModelAndView model = new 	ModelAndView(Globals.JSONVIEW);
    	Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
    	
    	String message = vo.getMode().equals("Ins") ? "sucess.common.insert" : "sucess.common.update";
    	
        if(!isAuthenticated) {
        	model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
    		return model;
        }
        LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
    	vo.setLastUpdusrId(user.getAdminId());
    	int ret  = cmmnDetailCodeManageService.updateCmmnDetailCode(vo);
    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(message));		
    	
    	
    	return model;
    }
}
