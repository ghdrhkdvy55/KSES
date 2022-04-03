package com.kses.backoffice.bas.authority.web;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.authority.service.AuthInfoService;
import com.kses.backoffice.bas.authority.vo.AuthInfo;
import com.kses.backoffice.bas.menu.service.MenuCreateManageService;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/bas")
public class AuthInfoManageController {
	
    @Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private UniSelectInfoManageService uniService;
	
	@Autowired
	private AuthInfoService authService;
	
	@Autowired
	private MenuCreateManageService menuCreateService;
	
	/**
	 * 권한관리 화면
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="authList.do", method = RequestMethod.GET)
	public ModelAndView viewAuthList() throws Exception {
		return new ModelAndView("/backoffice/bas/authList");
	}
	
	/**
	 * 권한관리 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="authListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectAuthInfoListAjax(@RequestBody Map<String, Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);

		int pageUnit = searchVO.get("pageUnit") == null ?  propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));

   	    PaginationInfo paginationInfo = new PaginationInfo();
	    paginationInfo.setCurrentPageNo( Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"),"1")));
	    paginationInfo.setRecordCountPerPage(pageUnit);
	    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

	    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
	    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
	    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());

	    List<Map<String, Object>> list = authService.selectAuthInfoList(searchVO);
        int totCnt =  list.size() > 0 ? Integer.valueOf(list.get(0).get("total_record_count").toString()) : 0;
		paginationInfo.setTotalRecordCount(totCnt);

		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
	    model.addObject(Globals.PAGE_TOTALCNT, totCnt);
	    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
	    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
	    
		return model;
	}
	
	/**
	 * 권한관리 정보 저장
	 * @param authInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="authUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateAuthInfoManage(@RequestBody AuthInfo authInfo) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		int ret = 0;
		switch (authInfo.getMode()) {
			case Globals.SAVE_MODE_INSERT:
				ret = authService.insertAuthInfo(authInfo);
				break;
			case Globals.SAVE_MODE_UPDATE:
				ret = authService.updateAuthInfo(authInfo);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
		}
		
		String messageKey = "";
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			messageKey = StringUtils.equals(authInfo.getMode(), Globals.SAVE_MODE_INSERT) 
					? "sucess.common.insert" : "sucess.common.update";
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			messageKey = StringUtils.equals(authInfo.getMode(), Globals.SAVE_MODE_INSERT) 
					? "fail.common.insert" : "fail.common.update";
		}
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));
		
		return model;
	}
	
	/**
	 * 권한코드 중복 코드 체크
	 * @param authorCode
	 * @return
	 * @throws Exception
	 */
    @NoLogging
    @RequestMapping (value="authorIDCheck.do", method = RequestMethod.GET)
    public ModelAndView authorIDCheck(@RequestParam("authorCode") String authorCode) throws Exception {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	int ret = uniService.selectIdDoubleCheck("AUTHOR_CODE", "COMTNAUTHORINFO", "AUTHOR_CODE = ["+ authorCode + "[");
    	if (ret == 0) {
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
     * 권한코드 삭제
     * @param authInfo
     * @return
     * @throws Exception
     */
	@RequestMapping (value="authDelete.do", method = RequestMethod.POST)
	public ModelAndView deleteAuthInfoManage(@RequestBody AuthInfo authInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		
		authService.deleteAuthInfo(authInfo.getAuthorCode());
		menuCreateService.deleteMenuCreat_S(authInfo.getAuthorCode());
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));
		
		return model;
	}
	
	/**
	 * 권한관리 상세
	 * - 사용하지 않음
	 * @param loginVO
	 * @param authorCode
	 * @param request
	 * @param bindingResult
	 * @return
	 * @throws Exception
	 *//**
	@RequestMapping (value="authInfoDetail.do")
	public ModelAndView selectHolyInfoDetail(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestParam("authorCode") String authorCode, 
												HttpServletRequest request, 
												BindingResult bindingResult) throws Exception{	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }
	    
	    try {
	    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, authService.selectAuthInfoDetail(authorCode));
	    } catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
	    }
	    return model;
	}
	*/
	
}