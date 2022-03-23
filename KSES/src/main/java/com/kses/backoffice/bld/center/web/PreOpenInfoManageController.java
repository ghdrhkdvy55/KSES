package com.kses.backoffice.bld.center.web;

import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.center.service.PreOpenInfoManageService;
import com.kses.backoffice.bld.center.vo.PreOpenInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/backoffice/bld")
public class PreOpenInfoManageController {
    
    @Autowired
    EgovMessageSource egovMessageSource;
    
    @Autowired
    PreOpenInfoManageService preOpenInfoService;
    
    @Autowired
    CenterInfoManageService centerInfoService;
    
    @Autowired
    protected EgovPropertyService propertiesService;
    
    /**
     * 지점 사전예약시간 목록 조회
     * @param searchVO
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "preOpenInfoListAjax.do", method = RequestMethod.POST)
    public ModelAndView selectPreOpenInfo(@RequestBody Map<String,Object> searchVO) throws Exception {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	String centerCd = (String) searchVO.get("centerCd");
    	
		//Paging
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(1);
		paginationInfo.setRecordCountPerPage(10);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		searchVO.put("pageSize", paginationInfo.getPageSize());
		
		List<Map<String, Object>> preOpenInfoList = preOpenInfoService.selectPreOpenInfoList(centerCd);
		paginationInfo.setTotalRecordCount(7);

		model.addObject(Globals .STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, preOpenInfoList);
		model.addObject(Globals.PAGE_TOTALCNT, paginationInfo.getTotalRecordCount());
	    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
	    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

    	return model;
    }

	/**
	 * 지점 사전예약시간 수정
	 * @param preOpenInfoList
	 * @return
	 * @throws Exception
	 */
	@NoLogging
    @RequestMapping(value = "preOpenInfoUpdate.do", method = RequestMethod.POST)
    public ModelAndView updatePreOpenInfo(@RequestBody List<PreOpenInfo> preOpenInfoList) throws Exception {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		preOpenInfoList.stream().forEach(x -> x.setLastUpdusrId(userId));
		preOpenInfoService.updatePreOpenInfo(preOpenInfoList);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.update"));

    	return model;
    }
    
	/**
	 * 사전예약시간 지점 복사
	 * @param params
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "preOpenInfoCopy.do", method = RequestMethod.POST)
    public ModelAndView updateCopyPreOpenInfo(@RequestBody PreOpenInfo preOpenInfo) throws Exception {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
    	preOpenInfo.setLastUpdusrId(userId);
    	preOpenInfoService.copyPreOpenInfo(preOpenInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update"));

    	return model;
    }
}