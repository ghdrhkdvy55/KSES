package com.kses.backoffice.bld.center.web;

import com.kses.backoffice.bld.center.service.BillInfoManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.center.vo.BillDayInfo;
import com.kses.backoffice.bld.center.vo.BillInfo;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

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

	@Autowired
	protected EgovPropertyService propertiesService;

	/**
	 * 지점별 영수증 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "billInfoListAjax.do", method = RequestMethod.POST)
    public ModelAndView selectBillInfoList(@RequestBody Map<String,Object> searchVO) throws Exception {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String centerCd = (String) searchVO.get("centerCd");

		List<Map<String, Object>> billInfoList = billService.selectBillInfoList(centerCd);

		model.addObject(Globals.JSON_RETURN_RESULTLISR, billInfoList);
		model.addObject(Globals.PAGE_TOTALCNT, billInfoList.size());
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

    	return model;
    }

	/**
	 * 지점별 현금영수증(요일) 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "billDayInfoListAjax.do", method = RequestMethod.POST)
    public ModelAndView selectBillDayInfoList(@RequestBody Map<String,Object> searchVO) throws Exception {
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

		List<Map<String, Object>> billInfoList = billService.selectBillInfoList(centerCd);
		List<Map<String, Object>> billDayInfoList = billService.selectBillDayInfoList(centerCd);
		paginationInfo.setTotalRecordCount(7);
		billDayInfoList.stream().forEach(x ->
			x.put("bill_info_list", billInfoList)
		);

		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, billDayInfoList);
		model.addObject(Globals.PAGE_TOTALCNT, paginationInfo.getTotalRecordCount());
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    	
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
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );		    	 
		} catch (Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}
}