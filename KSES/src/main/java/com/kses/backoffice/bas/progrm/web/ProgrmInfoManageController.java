package com.kses.backoffice.bas.progrm.web;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.authority.web.AuthInfoManageController;
import com.kses.backoffice.bas.progrm.service.ProgrmInfoService;
import com.kses.backoffice.bas.progrm.vo.ProgrmInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/bas")
public class ProgrmInfoManageController {
	private static final Logger LOGGER = LoggerFactory.getLogger(AuthInfoManageController.class);
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private ProgrmInfoService progrmService;
	
	@Autowired
	private UniSelectInfoManageService uniService;

	/**
	 * 프로그램 관리 화면
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="programList.do", method = RequestMethod.GET)
	public ModelAndView selectProgrmInfoList() throws Exception {
		return new ModelAndView("/backoffice/bas/programList");
	}
	
	/**
	 * 프로그램 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="progrmListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectProgrmInfoListAjax(@RequestBody Map<String, Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
		
		int pageUnit = searchVO.get("pageUnit") == null ?  propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
		  
	    searchVO.put("pageSize", propertiesService.getInt("pageSize"));
	  
	    LOGGER.info("pageUnit:" + pageUnit);
	  
   	    PaginationInfo paginationInfo = new PaginationInfo();
	    paginationInfo.setCurrentPageNo( Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"),"1")));
	    paginationInfo.setRecordCountPerPage(pageUnit);
	    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

	    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
	    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
	    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
	    			  
		List<Map<String, Object>> list = progrmService .selectProgrmInfoList(searchVO);
        int totCnt =  list.size() > 0 ? Integer.valueOf(list.get(0).get("total_record_count").toString()) : 0;
   
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
	    model.addObject(Globals.PAGE_TOTALCNT, totCnt);
	    paginationInfo.setTotalRecordCount(totCnt);
	    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
	    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		
		return model;
	}
	
	/**
	 * 프로그램 저장
	 * @param progrmInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="programeUpdate.do", method = RequestMethod.POST)
	public ModelAndView programeUpdate(@RequestBody ProgrmInfo progrmInfo) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		int ret = 0;
		switch (progrmInfo.getMode()) {
			case "Ins":
				ret = progrmService.insertProgrmInfo(progrmInfo);
				break;
			case "Edt":
				ret = progrmService.updateProgrmInfo(progrmInfo);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
		}
		
		String messageKey = "";
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			messageKey = StringUtils.equals(progrmInfo.getMode(), "Ins") ? "sucess.common.insert" : "sucess.common.update";
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			messageKey = StringUtils.equals(progrmInfo.getMode(), "Ins") ? "fail.common.insert" : "fail.common.update";
		}
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));
		
		return model;
	}
	
	/**
	 * 프로그램 삭제
	 * @param progrmInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="programeDelete.do", method = RequestMethod.POST)
	public ModelAndView deleteProgrameInfoManage(@RequestBody ProgrmInfo progrmInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		int ret = progrmService.deleteProgrmInfo(progrmInfo.getProgrmFileNm());
		
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
	 * 프로그램 중복 체크
	 * @param progrmFileNm
	 * @return
	 * @throws Exception
	 */
	@NoLogging
    @RequestMapping (value="programIDCheck.do", method = RequestMethod.GET)
    public ModelAndView selectIdCheck(@RequestParam("progrmFileNm") String progrmFileNm) throws Exception {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	String result = uniService.selectIdDoubleCheck("PROGRM_FILE_NM", "COMTNPROGRMLIST", "PROGRM_FILE_NM = ["+ progrmFileNm + "[") > 0 ? 
    			"FAIL" 
    			: "OK";
    	if (StringUtils.equals(result, "OK")) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("common.codeOk.msg"));
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("common.codeFail.msg"));
		}
		
    	return model;
    }
	
	/**
	 * 사용하지 않음
	 *//**
	@RequestMapping (value="programeDetail.do")
	public ModelAndView programeDetail(	@ModelAttribute("loginVO") LoginVO loginVO, 
										@RequestParam("progrmFileNm") String progrmFileNm, 
										HttpServletRequest request, 
										BindingResult bindingResult) throws Exception{	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
			return model;	
	    }
	    
	    try {
	    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, progrmService.selectProgrmInfoDetail(progrmFileNm));
	    } catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
	    }
	    return model;
	}*/
}