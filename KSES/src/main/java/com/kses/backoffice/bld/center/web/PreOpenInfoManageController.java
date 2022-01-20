package com.kses.backoffice.bld.center.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.center.service.PreOpenInfoManageService;
import com.kses.backoffice.bld.center.vo.PreOpenInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

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
     * 사전예약시간 목록 조회
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
		paginationInfo.setTotalRecordCount(7);
		paginationInfo.setCurrentPageNo(1);
		paginationInfo.setRecordCountPerPage(10);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		searchVO.put("pageSize", paginationInfo.getPageSize());
		
		List<Map<String, Object>> preOpenInfoList = preOpenInfoService.selectPreOpenInfoList(centerCd);
		
		String centerNm = (preOpenInfoList.size() > 0) 
				? preOpenInfoList.get(0).get("center_nm").toString()
				: centerInfoService.selectCenterInfoDetail(centerCd).get("center_nm").toString();
		
		model.addObject(Globals.JSON_RETURN_RESULTLISR, preOpenInfoList);
		model.addObject(Globals.PAGE_TOTALCNT, paginationInfo.getTotalRecordCount());
	    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
	    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals .STATUS_REGINFO, centerNm);
    	
    	return model;
    }
    
    @RequestMapping("preOpenInfoUpdate.do")
    public ModelAndView updatePreOpenInfo(	@ModelAttribute("loginVO") LoginVO loginVO,
    										@RequestBody List<PreOpenInfo> preOpenInfoList,
											HttpServletRequest request) {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	try {
			preOpenInfoService.updatePreOpenInfo(preOpenInfoList);
			
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update"));
		} catch (Exception e) {
    		log.info("updatePreOpenInfo ERROR : " + e.toString());
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
    
    @RequestMapping("preOpenInfoCopy.do")
    public ModelAndView copyPreOpenInfo(	@ModelAttribute("loginVO") LoginVO loginVO,
    										@RequestBody Map<String, Object> params,
											HttpServletRequest request) {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	try {
			preOpenInfoService.copyPreOpenInfo(params);
			
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update"));
		} catch (Exception e) {
    		log.info("copyPreOpenInfo ERROR : " + e.toString());
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
}