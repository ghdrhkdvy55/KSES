package com.kses.backoffice.bld.center.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.center.vo.BillDayInfo;
import com.kses.backoffice.bld.center.vo.BillInfo;
import com.kses.backoffice.bld.center.service.BillInfoManageService;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

@RestController
@RequestMapping("/backoffice/bld")
public class BillInfoManageController {

    private static final Logger LOGGER = LoggerFactory.getLogger(BillInfoManageController.class);
    
    @Autowired
    EgovMessageSource egovMessageSource;
    
    @Autowired
    BillInfoManageService billService;
    
    @Autowired
    CenterInfoManageService centerInfoService;
    
    @RequestMapping("billInfoListAjax.do")
    public ModelAndView selectBillInfoList(	@RequestParam("centerCd") String centerCd,
    										HttpServletRequest request) {
    	
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
				return model;	
			}
    	
    		List<Map<String, Object>> billInfoList = billService.selectBillInfoList(centerCd);
    		
    		String centerNm =  	billInfoList.size() > 0 ? 
    							billInfoList.get(0).get("center_nm").toString():
    			         		centerInfoService.selectCenterInfoDetail(centerCd).get("center_nm").toString();
    			         
    		model.addObject("centerNm", centerNm);
    		model.addObject("billInfoList", billInfoList);
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.select"));
    	} catch (Exception e) {
    		LOGGER.info("selectBillInfoList ERROR : " + e.toString());
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
    
    @RequestMapping("billDayInfoListAjax.do")
    public ModelAndView selectBillDayInfoList(	@RequestParam("centerCd") String centerCd,
    											HttpServletRequest request) {
    	
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
				return model;	
			}
    	
    		List<Map<String, Object>> billInfoList = billService.selectBillInfoList(centerCd);
    		List<Map<String, Object>> billDayInfoList = billService.selectBillDayInfoList(centerCd);
    		
    		String centerNm =  	billDayInfoList.size() > 0 ? 
    							billDayInfoList.get(0).get("center_nm").toString():
    			         		centerInfoService.selectCenterInfoDetail(centerCd).get("center_nm").toString();
    			         
    		model.addObject("centerNm", centerNm);
    		model.addObject("billDayInfoList", billDayInfoList);
    		model.addObject("billInfoList", billInfoList);
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.select"));
    	} catch (Exception e) {
    		LOGGER.info("selectBillInfoList ERROR : " + e.toString());
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
     
	@RequestMapping (value="billInfoDetail.do")
	public ModelAndView selectCenterInfoDetail( @RequestParam("billSeq") String billSeq , 
												HttpServletRequest request) throws Exception {	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
			return model;	
	    }	
		
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_REGINFO, billService.selectBillInfoDetail(billSeq));	     	
		return model;
	}
    
	@RequestMapping (value="billInfoUpdate.do")
	public ModelAndView updateBillInfo(	HttpServletRequest request,  
										@RequestBody BillInfo vo) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		String meesage = "";
		
		try {	
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
				return model;
			} else {
				HttpSession httpSession = request.getSession();
				LoginVO loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
				vo.setFrstRegterId(loginVO.getAdminId());
				vo.setLastUpdusrId(loginVO.getAdminId());
			}
		
			int ret = billService.updateBillInfo(vo);
			meesage = vo.getMode().equals("Ins") ? "sucess.common.insert" : "sucess.common.update";
			
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
			LOGGER.error("updateBillInfo ERROR : " + e.toString());
			meesage = (vo.getMode().equals("Ins")) ? "fail.common.insert" : "fail.common.update";
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));	
		}	
		return model;
	}
	
    @RequestMapping("billDayInfoUpdate.do")
    public ModelAndView updateBillDayInfo(	@RequestBody List<BillDayInfo> billDayInfoList,
											HttpServletRequest request) {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
				return model;
			}
			
			HttpSession httpSession = request.getSession();
			LoginVO loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
			
			for(BillDayInfo billDayInfo : billDayInfoList) {
				billDayInfo.setLastUpdusrId(loginVO.getAdminId());
			}
    		
			billService.updateBillDayInfo(billDayInfoList);
			
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update"));
		} catch (Exception e) {
    		LOGGER.error("updateBillDayInfo ERROR : " + e.toString());
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
	
	@RequestMapping (value="billInfoDelete.do")
	public ModelAndView deleteBillInfoManage(	@RequestParam("billSeq") String billSeq, 
												HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		    if(!isAuthenticated) {
		    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
		    	model.setViewName("/backoffice/login");
		    	return model;	
		    }	
	    
	    	billService.deleteBillInfo(billSeq);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));		    	 
		} catch (Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}
}