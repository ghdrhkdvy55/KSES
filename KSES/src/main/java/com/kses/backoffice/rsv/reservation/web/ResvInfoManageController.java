package com.kses.backoffice.rsv.reservation.web;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.center.vo.CenterInfo;
import com.kses.backoffice.rsv.reservation.service.AttendInfoManageService;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.AttendInfo;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/rsv")
public class ResvInfoManageController {

    private static final Logger LOGGER = LoggerFactory.getLogger(ResvInfoManageController.class);

    @Autowired
    EgovMessageSource egovMessageSource;
	
    @Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private EgovCcmCmmnDetailCodeManageService codeDetailService;
	
	@Autowired
	private ResvInfoManageService resvService;
    
    @Autowired
    private CenterInfoManageService centerService;
    
    @Autowired
    private AttendInfoManageService attendService;
    
	@RequestMapping(value="rsvList.do")
	public ModelAndView selectRsvInfoList(	@ModelAttribute("loginVO") LoginVO loginVO, 
											@ModelAttribute("searchVO") CenterInfo searchVO, 
											HttpServletRequest request, 
											BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/rsv/rsvList"); 
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
				return model;	
			} else {
		       HttpSession httpSession = request.getSession(true);
		       loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
			}
			
			List<Map<String, Object>> centerInfoComboList = centerService.selectCenterInfoComboList();
			
			model.addObject("centerInfo", centerInfoComboList);
			model.addObject("resvPayDvsn", codeDetailService.selectCmmnDetailCombo("RESV_PAY_DVSN"));
			model.addObject("resvState", codeDetailService.selectCmmnDetailCombo("RESV_STATE"));
			model.addObject("loginVO" , loginVO);
		    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectRsvInfoList : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;	
	}
    
	@RequestMapping(value="rsvListAjax.do")
	public ModelAndView selectCenterAjaxInfo(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestBody Map<String,Object> searchVO, 
												HttpServletRequest request, 
												BindingResult bindingResult	) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		try {
			  
	          Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
				
			  if(!isAuthenticated) {
					model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
					model.setViewName("/backoffice/login");
					return model;
			  } 
			
			  int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			  
			  searchVO.put("pageSize", propertiesService.getInt("pageSize"));
			  
			  LOGGER.debug("------------------------pageUnit : " + pageUnit);
			  
			  //Paging
		   	  PaginationInfo paginationInfo = new PaginationInfo();
			  paginationInfo.setCurrentPageNo(Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
			  paginationInfo.setRecordCountPerPage(pageUnit);
			  paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
			  
			  searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
			  searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
			  searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
			  
			  loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			  
			  
			  searchVO.put("authorCd", loginVO.getAuthorCd());
			  searchVO.put("centerCd", loginVO.getCenterCd());
			  
			  
			  List<Map<String, Object>> list = resvService.selectResInfoManageListByPagination(searchVO);
			  LOGGER.debug("[-------------------------------------------list:" + list.size() + "------]");
		      model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		      model.addObject(Globals.STATUS_REGINFO, searchVO);
		      int totCnt = list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		      
		      LOGGER.debug("totCnt:" + totCnt);
		      
		      paginationInfo.setTotalRecordCount(totCnt);
		      model.addObject("paginationInfo", paginationInfo);
		      model.addObject("totalCnt", totCnt);
		      
		} catch(Exception e) {
			LOGGER.debug("---------------------------------------");
			StackTraceElement[] ste = e.getStackTrace();
			LOGGER.error(e.toString() + ":" + ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
		return model;
	}
	
	@RequestMapping (value="rsvSeatChange.do")
	public ModelAndView rsvSeatChange(	HttpServletRequest request, 
										@RequestBody Map<String,Object> params, 
										BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			return model;
		}
		
		try {
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("userId", loginVO.getAdminId());
			int ret = resvService.resvSeatChange(params);
			System.out.println(ret);
			
			if(ret > 0) {
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.update"));
			}
		} catch (Exception e){
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		return model;
	}
	
	@RequestMapping (value="longResvInfoUpdate.do")
	@Transactional(rollbackFor = Exception.class)
	public ModelAndView rsvLongSeatUpdate(	HttpServletRequest request, 
											@RequestBody ResvInfo vo, 
											BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			return model;
		}
		
		try {
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			vo.setAdminId(loginVO.getAdminId());
			
			List<String> resvDateList = resvService.selectResvDateList(vo);
			vo.setResvDateList(resvDateList);
			
			int ret = resvService.updateUserLongResvInfo(vo);
			
			if(ret > 0) {
				ret = resvService.updateLongResvInfo(vo); 
				if(ret > 0) {
					model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.update"));
				} else {
					throw new Exception();
				}
			} else {
				throw new Exception();
			}
		} catch (Exception e){
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		return model;
	}
	
	@RequestMapping (value="rsvInfoDetail.do")
	public ModelAndView selectCenterInfoDetail(	@RequestParam("resvSeq") String resvSeq, 
												HttpServletRequest request) throws Exception {	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
			return model;	
	    }	
		
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_REGINFO, resvService.selectResInfoDetail(resvSeq));	     	
		return model;
	}
	
	@RequestMapping (value="resvInfoCancel.do")
	public ModelAndView resvInfoCancel(	@RequestParam("resvSeq") String resvSeq, 
										HttpServletRequest request) throws Exception {	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		try {
		    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;	
		    }
			
			Map<String, String> resultMap = resvService.resvInfoAdminCancel(resvSeq);
			
			model.addObject(Globals.STATUS, resultMap.get(Globals.STATUS));
			model.addObject(Globals.STATUS_MESSAGE, resultMap.get(Globals.STATUS_MESSAGE));
		} catch(Exception e) {
			LOGGER.debug("---------------------------------------");
			StackTraceElement[] ste = e.getStackTrace();
			LOGGER.error(e.toString() + ":" + ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
	     	
		return model;
	}
	
	@RequestMapping (value="resvInfoCancelAll.do")
	public ModelAndView resvInfoCancelAll(	@RequestBody Map<String,Object> params, 
											HttpServletRequest request) throws Exception {	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		List<Map<String, String>> resvCancelList = new LinkedList<Map<String, String>>();
		int failCount = 0;
		int ticketCount = 0;
		try {
		    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;	
		    }
			
			params.put("firstIndex", 0);
			params.put("recordCountPerPage", 5000);
			params.put("searchCenterCd",params.get("centerCd").toString());
			params.put("searchFrom",params.get("resvDate").toString());
			params.put("searchTo",params.get("resvDate").toString());
			params.put("searchDayCondition","resvDate");
			params.put("searchResvState","RESV_STATE_4");
			params.put("searchStateCondition","cancel");
			
			List<Map<String, Object>> resvList = resvService.selectResInfoManageListByPagination(params);

			for(Map<String,Object> resvInfo : resvList) {
				if(!SmartUtil.NVL(resvInfo.get("resv_ticket_dvsn"),"").equals("RESV_TICKET_DVSN_2")) {
					String resvSeq = resvInfo.get("resv_seq").toString();
					Map<String, String> resultMap = resvService.resvInfoAdminCancel(resvSeq);
				
					if(!resultMap.get(Globals.STATUS).equals("SUCCESS")) {
						failCount ++;
					}
				
					resultMap.put("resvSeq", resvSeq);
					resvCancelList.add(resultMap);
				} else {
					ticketCount ++;
				}
			}
			
			model.addObject("allCount", resvList.size());
			model.addObject("successCount", resvList.size() - (failCount + ticketCount));
			model.addObject("failCount", failCount);
			model.addObject("ticketCount", ticketCount);
			model.addObject("resvCancelList", resvCancelList);
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("request.success.msg"));

		} catch(Exception e) {
			LOGGER.debug("---------------------------------------");
			StackTraceElement[] ste = e.getStackTrace();
			LOGGER.error(e.toString() + ":" + ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
	     	
		return model;
	}
	
	@RequestMapping(value="attendListAjax.do")
	public ModelAndView selectAttendListAjax(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestBody Map<String,Object> searchVO, 
												HttpServletRequest request, 
												BindingResult bindingResult	) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		try {
			  int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			  
			  searchVO.put("pageSize", propertiesService.getInt("pageSize"));
			  
			  LOGGER.debug("------------------------pageUnit : " + pageUnit);
			  
			  //Paging
		   	  PaginationInfo paginationInfo = new PaginationInfo();
			  paginationInfo.setCurrentPageNo(Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
			  paginationInfo.setRecordCountPerPage(pageUnit);
			  paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
			  
			  searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
			  searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
			  searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
			  
			  LOGGER.debug("pageUnit End");
			  List<Map<String, Object>> list = attendService.selectAttendInfoListPage(searchVO);
			  LOGGER.debug("[-------------------------------------------list:" + list.size() + "------]");
		      model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		      model.addObject(Globals.STATUS_REGINFO, searchVO);
		      int totCnt = list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		      
		      LOGGER.debug("totCnt:" + totCnt);
		      
		      paginationInfo.setTotalRecordCount(totCnt);
		      model.addObject("paginationInfo", paginationInfo);
		      model.addObject("totalCnt", totCnt);
		      
		} catch(Exception e) {
			LOGGER.debug("---------------------------------------");
			StackTraceElement[] ste = e.getStackTrace();
			LOGGER.error(e.toString() + ":" + ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
		return model;
	}
	
	@RequestMapping (value="attendInfoUpdate.do")
	public ModelAndView updateAttendInfo(	HttpServletRequest request,  
											@RequestBody AttendInfo vo, 
											BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			return model;
		}
		
		try {
			vo = attendService.insertAttendInfo(vo);
			
			if(vo.getRet() > 0) {
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.insert"));
			} else {
				throw new Exception();
			}
		} catch (Exception e){
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		return model;
	}
}