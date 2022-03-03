package com.kses.backoffice.bld.center.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bas.holy.vo.HolyInfo;
import com.kses.backoffice.bld.center.mapper.CenterHolyInfoManageMapper;
import com.kses.backoffice.bld.center.service.CenterHolyInfoManageService;
import com.kses.backoffice.bld.center.vo.CenterHolyInfo;
import com.kses.backoffice.cus.usr.vo.UserInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/bld")
public class CenterHolyInfoManageController {

    private static final Logger LOGGER = LoggerFactory.getLogger(CenterHolyInfoManageController.class);
    
    @Autowired
    EgovMessageSource egovMessageSource;
    
    @Autowired
    CenterHolyInfoManageService centerHolyInfoService;
    
    @Autowired
    protected EgovPropertyService propertiesService;
    
    @Autowired
    CenterInfoManageService centerInfoService;
	
	@Autowired
	private CenterInfoManageService centerInfoManageService;
	
	@Autowired
	private CenterHolyInfoManageMapper centerHolyMapper;
    
    @RequestMapping("centerHolyInfoListAjax.do")
    public ModelAndView selectCenterHolyInfo(	@ModelAttribute("loginVO") LoginVO loginVO,
    											@RequestBody Map<String, Object> searchVO,    											
    											HttpServletRequest request,
    											BindingResult bindingResult) {
    	
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
			int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			  
			searchVO.put("pageSize", propertiesService.getInt("pageSize"));
			  
		              
		   	PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
			paginationInfo.setRecordCountPerPage(pageUnit);
			paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
			searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
			searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
			searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
			
			List<Map<String, Object>> centerHolyInfoList = centerHolyInfoService.selectCenterHolyInfoList(searchVO);
			//신규 추가 리스트 값 없을때 처리 
			String centerNm =   (centerHolyInfoList.size() > 0) ? 
				         centerHolyInfoList.get(0).get("center_nm").toString():
				         SmartUtil.NVL(searchVO.get("centerNm"),"").toString();
				         
			int totCnt = centerHolyInfoList.size() > 0 ?  Integer.valueOf( centerHolyInfoList.get(0).get("total_record_count").toString()) : 0;
						    
			model.addObject(Globals.STATUS_REGINFO, centerHolyInfoList);
			model.addObject(Globals.PAGE_TOTALCNT, totCnt);
			paginationInfo.setTotalRecordCount(totCnt);
			model.addObject(Globals.JSON_RETURN_RESULT, centerNm);
			model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.select"));
			
		} catch (Exception e) {
			LOGGER.info("selectCenterHolyInfo ERROR : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
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
			int ret = centerHolyInfoService.updateCenterHolyInfo(vo);
			
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
			meesage = (vo.getMode().equals("Ins")) ? "fail.common.insert" : "fail.common.update";
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
			LOGGER.info(e.toString());
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
    		LOGGER.info("selectCenterHolyInfo ERROR : " + e.toString());
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
	
	 @RequestMapping("centerHolyInfoCopy.do")
	    public ModelAndView copyPreOpenInfo(	@ModelAttribute("loginVO") LoginVO loginVO,
	    										@RequestBody Map<String, Object> params,
												HttpServletRequest request) {
	    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
	    	
	    	try {
	    		int ret =  centerHolyInfoService.copyCenterHolyInfo(params);
	    		
	    		LOGGER.info("ret : " + ret);
	    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
	    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update"));
			} catch (Exception e) {
	    		LOGGER.info("copyPreOpenInfo ERROR : " + e.toString());
	    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
	    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.update"));
			}
	    	
	    	return model;
	    }
	    
}