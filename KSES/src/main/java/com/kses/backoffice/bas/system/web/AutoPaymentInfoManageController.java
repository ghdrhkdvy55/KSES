package com.kses.backoffice.bas.system.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.system.service.AutoPaymentInfoManageService;
import com.kses.backoffice.bas.system.vo.AutoPaymentInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/bas")
public class AutoPaymentInfoManageController {
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	AutoPaymentInfoManageService autoPaymentSerivce;
	
    /**
     * 스피드온 자동결제정보 목록 조회
     * @param searchVO
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "autoPaymentInfoListAjax.do", method = RequestMethod.POST)
    public ModelAndView selectAutoPaymentInfo(@RequestBody Map<String,Object> searchVO) throws Exception {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		//Paging
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(1);
		paginationInfo.setRecordCountPerPage(10);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		searchVO.put("pageSize", paginationInfo.getPageSize());
		
		List<Map<String, Object>> autoPaymentInfoList = autoPaymentSerivce.selectAutoPaymentInfoList();
		paginationInfo.setTotalRecordCount(7);

		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, autoPaymentInfoList);
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
    @RequestMapping(value = "autoPaymentInfoUpdate.do", method = RequestMethod.POST)
    public ModelAndView updateAutoPaymentInfo(@RequestBody List<AutoPaymentInfo> autoPaymentInfoList) throws Exception {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		autoPaymentSerivce.updateAutoPaymentInfo(autoPaymentInfoList);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.update"));

    	return model;
    }
}