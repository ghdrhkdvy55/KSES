package com.kses.backoffice.bld.center.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bld.center.service.CenterHolyInfoManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.center.vo.CenterHolyInfo;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/bld")
public class CenterHolyInfoManageController {
    
    @Autowired
    EgovMessageSource egovMessageSource;
    
    @Autowired
    CenterHolyInfoManageService centerHolyInfoService;
    
    @Autowired
    CenterInfoManageService centerInfoService;
	
	@Autowired
	private CenterInfoManageService centerInfoManageService;
	
	@Autowired
	private UniSelectInfoManageService uniService;

	@Autowired
	protected EgovPropertyService propertiesService;

	/**
	 * 지점 휴일 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "centerHolyInfoListAjax.do", method = RequestMethod.POST)
    public ModelAndView selectCenterHolyInfo(@RequestBody Map<String,Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String centerCd = (String) searchVO.get("centerCd");
		int pageUnit = searchVO.get("pageUnit") == null ?  propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));

		// 센터 값이 안들어 오면 에러 보내기
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

		searchVO.put("centerCd",  centerCd);
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());

		List<Map<String, Object>> centerHolyInfoList = centerHolyInfoService.selectCenterHolyInfoList(searchVO);
		int totCnt = centerHolyInfoList.size() > 0 ?  Integer.valueOf(centerHolyInfoList.get(0).get("total_record_count").toString()) : 0;
		paginationInfo.setTotalRecordCount(totCnt);

		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, centerHolyInfoList);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

    	return model;
    }
    
	@RequestMapping (value="centerHolyInfoUpdate.do")
	public ModelAndView updateCenterInfo(	HttpServletRequest request,  
											@ModelAttribute("LoginVO") LoginVO loginVO, 
											@RequestBody CenterHolyInfo vo, 
											BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		String meesage = "";
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
			
			return model;
		} else {
			HttpSession httpSession = request.getSession(true);
			loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
			vo.setFrstRegterId(loginVO.getAdminId());
			vo.setLastUpdusrId(loginVO.getAdminId());
	    }
		
		try {	
			Map<String, Object> centerUpdateSelect = centerHolyInfoService.centerUpdateSelect(vo.getCenterHolySeq());
			
			int ret;
			if (centerUpdateSelect.get("holy_dt").equals(vo.getHolyDt()) && centerUpdateSelect.get("center_holy_seq").toString().equals(vo.getCenterHolySeq())) {
				ret = centerHolyInfoService.updateCenterHolyInfo(vo);
			} else {
				ret = (uniService.selectIdDoubleCheck("HOLY_DT", "TSEB_CENTERHOLY_INFO_I", "HOLY_DT = ["+ vo.getHolyDt() + "[ AND CENTER_CD = ["+ vo.getCenterCd() + "[" ) > 0) ? -1 : centerHolyInfoService.updateCenterHolyInfo(vo);
			}
	
			meesage = (vo.getMode().equals("Edt")) ? "sucess.common.update" : "sucess.common.insert";
			
			if (ret > 0) {
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			} else if (ret == -1) {
				meesage = "fail.common.overlap";
				model.addObject(Globals.STATUS, Globals.STATUS_OVERLAPFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			} else {
				throw new Exception();
			}		
		} catch (Exception e){
			meesage = (vo.getMode().equals(Globals.SAVE_MODE_INSERT)) ? "fail.common.insert" : "fail.common.update";
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));	
		}	
		return model;
	}
	
	@RequestMapping (value="centerHolyInfoDelete.do")
	public ModelAndView deleteholyInfoManage(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestParam("centerHolySeq") int centerHolySeq, 
												HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }	
	    try {
	    	centerHolyInfoService.deleteCenterHolyInfo(centerHolySeq);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );		    	 
		} catch (Exception e) {
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}
	
	@RequestMapping("centerHolyUpdateSelect.do")
    public ModelAndView centerHolyUpdateSelect(	@ModelAttribute("loginVO") LoginVO loginVO,
    											@RequestParam("centerHolySeq") String centerHolySeq,
    											HttpServletRequest request) {
    	
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
			return model;	
		} else {
			HttpSession httpSession = request.getSession(true);
			loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
		}
    	
    	try {
    		
    		Map<String, Object> centerUpdateSelect = centerHolyInfoService.centerUpdateSelect(centerHolySeq);
    		
    		model.addObject(Globals.STATUS_REGINFO, centerUpdateSelect);
    		//신규 추가 
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.select"));
    	} catch (Exception e) {
    		log.info("selectCenterHolyInfo ERROR : " + e);
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
}