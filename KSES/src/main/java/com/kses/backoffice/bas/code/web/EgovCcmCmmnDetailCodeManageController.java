package com.kses.backoffice.bas.code.web;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bas.code.vo.CmmnDetailCode;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.property.EgovPropertyService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/bas")
public class EgovCcmCmmnDetailCodeManageController {

	@Autowired
    private EgovCcmCmmnDetailCodeManageService cmmnDetailCodeManageService;

	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;

	/**
     * 공통상세코드 목록 조회
     * @param codeId
     * @return
     * @throws Exception
     */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="CmmnDetailCodeList.do", method = RequestMethod.GET)
    public ModelAndView selectCmmnDetailCodeList(@RequestParam("codeId") String codeId) throws Exception {
    	ModelAndView model = new 	ModelAndView(Globals.JSONVIEW);

    	List<CmmnDetailCode> codeDetailList = (List<CmmnDetailCode>) cmmnDetailCodeManageService.selectCmmnDetailCodeList(codeId);
        int totCnt = codeDetailList.size() > 0 ? codeDetailList.size()  : 0;

		model.addObject( Globals.STATUS_REGINFO, codeId);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, codeDetailList);
        model.addObject(Globals.PAGE_TOTALCNT, totCnt);
        
        return model;
	}

	/**
	 * 공통상세코드 저장
	 * @param cmmnDetailCode
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value="CodeDetailUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateCmmnDetailCodeManage(@RequestBody CmmnDetailCode cmmnDetailCode) throws Exception {
    	ModelAndView model = new 	ModelAndView(Globals.JSONVIEW);
    	
    	String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
    	cmmnDetailCode.setFrstRegisterId(userId);
    	cmmnDetailCode.setLastUpdusrId(userId);
    	
    	int ret = 0;
		switch (cmmnDetailCode.getMode()) {
			case Globals.SAVE_MODE_INSERT:
				ret = cmmnDetailCodeManageService.insertCmmnDetailCode(cmmnDetailCode);
				break;
			case Globals.SAVE_MODE_UPDATE:
				ret = cmmnDetailCodeManageService.updateCmmnDetailCode(cmmnDetailCode);
				break;
			default:
		}
		
		String messageKey = "";
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			messageKey = StringUtils.equals(cmmnDetailCode.getMode(), Globals.SAVE_MODE_INSERT) 
					? "sucess.common.insert" : "sucess.common.update";
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			messageKey = StringUtils.equals(cmmnDetailCode.getMode(), Globals.SAVE_MODE_INSERT) 
					? "fail.common.insert" : "fail.common.update";
		}
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));
    	
    	return model;
    }

	/**
	 * 공통상세코드를 삭제한다.
	 * @param cmmnDetailCode
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value="codeDetailCodeDelete.do", method = RequestMethod.POST)
	public ModelAndView deleteCmmnDetailCodeManage(@RequestBody CmmnDetailCode cmmnDetailCode) throws Exception {
    	ModelAndView model = new 	ModelAndView(Globals.JSONVIEW);
    	
    	int ret = cmmnDetailCodeManageService.deleteCmmnDetailCode(cmmnDetailCode.getCode());
    	if (ret > 0) {
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));
    	}
    	else {
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
    	}

    	return model;
	}

    /**
	 * 공통상세코드 상세항목을 조회한다.
	 * - 사용하지 않음
	 * @param loginVO
	 * @param cmmnDetailCode
	 * @param model
	 * @return
	 * @throws Exception
	 *//**
	@RequestMapping(value="CcmCmmnDetailCodeDetail.do")	
 	public ModelMap selectCmmnDetailCodeDetail(@RequestParam("code") String code)	throws Exception {
    	CmmnDetailCode cmmnDetailCode = cmmnDetailCodeManageService.selectCmmnDetailCodeDetail(code);
		model.addAttribute(Globals.JSON_RETURN_RESULT, cmmnDetailCode);
		return model;
	}
	@RequestMapping(value="CmmnDetailAjax.do")
    public ModelAndView CmmnDetailAjax (@ModelAttribute("loginVO") LoginVO loginVO
							            , @RequestParam("codeId") String codeId ) throws Exception {
    	     ModelAndView model = new 	ModelAndView(Globals.JSONVIEW);
    	     try{
    	    	 
    	    	 model.addObject(Globals.JSON_RETURN_RESULTLISR, cmmnDetailCodeManageService.selectCmmnDetailAjaxCombo(codeId)  );
        	     model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    	     }catch(Exception e){
    	    	 log.error("CmmnDetailView ERROR:" + e.toString());
    	    	 model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    	    	 model.addObject("message", egovMessageSource.getMessage("fail.common.select"));
    	     }
    	    return model;
    }
    @RequestMapping(value="CmmnDetailView.do")
    public ModelAndView CmmnDetailView (@ModelAttribute("loginVO") LoginVO loginVO
							            , @RequestParam("code") String code
                                     	, BindingResult bindingResult ) throws Exception {
    	     ModelAndView model = new 	ModelAndView(Globals.JSONVIEW);
    	     try{
    	    	 Map<String, Object> cmmDetail = cmmnDetailCodeManageService.selectCmmnDetail(code);
    	    	 
    	    	 log.debug("cmmDetail:" + cmmDetail);
    	    	 model.addObject(Globals.STATUS_REGINFO, cmmDetail);
        	     model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    	     }catch(Exception e){
    	    	 log.error("CmmnDetailView ERROR:" + e.toString());
    	    	 model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    	    	 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.select"));
    	     }
    	    return model;
    }
	*/
}
