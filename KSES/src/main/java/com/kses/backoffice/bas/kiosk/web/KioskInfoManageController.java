package com.kses.backoffice.bas.kiosk.web;

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

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bas.kiosk.service.KioskInfoService;
import com.kses.backoffice.bas.kiosk.vo.KioskInfo;
import com.kses.backoffice.bas.kiosk.web.KioskInfoManageController;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/bas")
public class KioskInfoManageController {
private static final Logger LOGGER = LoggerFactory.getLogger(KioskInfoManageController.class);
	
    @Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private KioskInfoService kioskService;
	
	@Autowired
	private UniSelectInfoManageService uniService;
	
	@Autowired
	private CenterInfoManageService centerInfoManageService;
	
	@Autowired
	private EgovCcmCmmnDetailCodeManageService codeDetailService;
	
	@RequestMapping(value="kioskList.do")
	public ModelAndView selectKioskInfoList(@ModelAttribute("loginVO") LoginVO loginVO, 
											@ModelAttribute("kioskInfo") KioskInfo kioskInfo,
											HttpServletRequest request, 
											BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/bas/kioskList");

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
			return model;	
		} 
		
		List<Map<String, Object>> centerInfoComboList = centerInfoManageService.selectCenterInfoComboList();
		
		
		
		model.addObject("centerInfo", centerInfoComboList);
		model.addObject("machInfo", codeDetailService.selectCmmnDetailCombo("MACH_GUBUN"));
		model.setViewName("/backoffice/bas/kioskList");
		return model;
	}
	
	@RequestMapping(value="kioskListAjax.do")
	public ModelAndView selectKioskInfoListAjax(@ModelAttribute("loginVO") LoginVO loginVO, 
												@ModelAttribute("kioskInfo") KioskInfo kioskInfo,
												@RequestBody Map<String, Object> searchVO,
												HttpServletRequest request, 
												BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
			
		try {
			int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			  
		    searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		  
		    LOGGER.info("pageUnit:" + pageUnit);
		                
	   	    PaginationInfo paginationInfo = new PaginationInfo();
		    paginationInfo.setCurrentPageNo( Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
		    paginationInfo.setRecordCountPerPage(pageUnit);
		    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

		    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		    			  
			List<Map<String, Object>> list = kioskService.selectKioskInfoList(searchVO);
	        int totCnt =  list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) :0;
	   
			model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		    model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		    paginationInfo.setTotalRecordCount(totCnt);
		    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);	    
		  
		}catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
		return model;
	}
	
	@RequestMapping (value="kioskInfoDetail.do")
	public ModelAndView selectKioskInfoDetail(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestParam("ticketMchnSno") String ticketMchnSno,
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
			model.addObject(Globals.STATUS_REGINFO, kioskService.selectKioskInfoDetail(ticketMchnSno));
	    } catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
	    }
	    return model;
	}
	@RequestMapping(value="kisokSerialCheck.do")
	public ModelAndView selectKisokSerialCheckManger(@RequestParam("ticketMchnSno") String ticketMchnSno) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			int IDCheck = uniService.selectIdDoubleCheck("TICKET_MCHN_SNO", "TSEC_TICKET_MCHN_M", "TICKET_MCHN_SNO = ["+ ticketMchnSno+ "[" );
			String result =  (IDCheck> 0) ? Globals.STATUS_FAIL : Globals.STATUS_OK;
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.JSON_RETURN_RESULT, result);
		}catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		
		return model;
	}
	
	@RequestMapping (value="kioskUpdate.do")
	public ModelAndView updateKioskInfo(	@ModelAttribute("loginVO") LoginVO loginVO, 
										@RequestBody KioskInfo vo, 
										HttpServletRequest request, 
										BindingResult result) throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		String meesage = null;
		
		try {
			 Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			 if(!isAuthenticated) {
				 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				 model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
				 return model;	
		     }
			 loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			 vo.setUserId(loginVO.getAdminId());
			 int ret  = kioskService.updateKioskInfo(vo);
			
			 meesage = (vo.getMode().equals("Ins")) ? "sucess.common.insert" : "sucess.common.update";
			 if (ret >-1){
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			 }else if(ret == -1){
				meesage = "fail.common.overlap";
				model.addObject(Globals.STATUS, Globals.STATUS_OVERLAPFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));		
			 }else {
				throw new Exception();
			 }
		} catch (Exception e) {
			meesage = (vo.getMode().equals("Ins")) ? "fail.common.insert" : "fail.common.update";
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));			
		}
		return model;
	}
	
	@RequestMapping (value="kioskDelete.do")
	public ModelAndView deleteKioskInfoManage(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestParam("ticketMchnSno") String ticketMchnSno, 
												HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }	
		
	    try {
	    	try {
				uniService.deleteUniStatement("", "TSEC_TICKET_MCHN_M", "TICKET_MCHN_SNO IN (SELECT COLUMN_VALUE FROM TABLE (UF_SPLICT(["+  ticketMchnSno+"[, [,[)))");
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );
			}catch(Exception e) {
				throw new Exception();		
			}	    	 
		} catch (Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}

}