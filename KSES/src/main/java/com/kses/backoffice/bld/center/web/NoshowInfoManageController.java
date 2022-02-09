package com.kses.backoffice.bld.center.web;

import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.center.service.NoshowInfoManageService;
import com.kses.backoffice.bld.center.vo.NoshowInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
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
public class NoshowInfoManageController {
    
    @Autowired
    EgovMessageSource egovMessageSource;
    
    @Autowired
    NoshowInfoManageService noshowInfoService;
    
    @Autowired
    CenterInfoManageService centerInfoService;

	@Autowired
	protected EgovPropertyService propertiesService;

	/**
	 * 자동 취소 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "noshowInfoListAjax.do", method = RequestMethod.POST)
    public ModelAndView selectNoshownfo(@RequestBody Map<String,Object> searchVO) throws Exception {
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

		List<Map<String, Object>> noshowInfoList = noshowInfoService.selectNoshowInfoList(centerCd);
		paginationInfo.setTotalRecordCount(7);

		model.addObject(Globals .STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, noshowInfoList);
		model.addObject(Globals.PAGE_TOTALCNT, paginationInfo.getTotalRecordCount());
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

    	return model;
    }

	/**
	 * 자동 취소 수정
	 * @param noshowInfoList
	 * @return
	 * @throws Exception
	 */
	@NoLogging
    @RequestMapping(value = "noshowInfoUpdate.do", method = RequestMethod.POST)
    public ModelAndView updateNoshowInfo(@RequestBody List<NoshowInfo> noshowInfoList) throws Exception {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		noshowInfoService.updateNoshowInfo(noshowInfoList);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update"));

    	return model;
    }
    
    @RequestMapping("noshowInfoCopy.do")
    public ModelAndView copyPreOpenInfo(	@ModelAttribute("loginVO") LoginVO loginVO,
    										@RequestBody Map<String, Object> params,
											HttpServletRequest request) {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	try {
    		noshowInfoService.copyNoshowInfo(params);
			
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update"));
		} catch (Exception e) {
			log.info("copyPreOpenInfo ERROR : " + e);
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
    
}