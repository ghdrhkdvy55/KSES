package com.kses.backoffice.rsv.reservation.web;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.rsv.reservation.service.AttendInfoManageService;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.AttendInfo;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/backoffice/rsv")
public class ResvInfoManageController {

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
    
    /**
     * 예약현황 화면
     * @return
     * @throws Exception
     */
    @NoLogging
	@RequestMapping(value="rsvList.do", method = RequestMethod.GET)
	public ModelAndView viewRsvList() throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/rsv/rsvList"); 

		List<Map<String, Object>> centerInfoComboList = centerService.selectCenterInfoComboList();
		model.addObject("centerInfo", centerInfoComboList);
		model.addObject("resvPayDvsn", codeDetailService.selectCmmnDetailCombo("RESV_PAY_DVSN"));
		model.addObject("resvState", codeDetailService.selectCmmnDetailCombo("RESV_STATE"));
	    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

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
			  
			  log.debug("------------------------pageUnit : " + pageUnit);
			  
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

			  List<Map<String, Object>> list = resvService.selectResvInfoManageListByPagination(searchVO);
			  log.debug("[-------------------------------------------list:" + list.size() + "------]");
		      model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		      model.addObject(Globals.STATUS_REGINFO, searchVO);
		      int totCnt = list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		      
		      log.debug("totCnt:" + totCnt);
		      
		      paginationInfo.setTotalRecordCount(totCnt);
		      model.addObject("paginationInfo", paginationInfo);
		      model.addObject("totalCnt", totCnt);
		      
		} catch(Exception e) {
			log.debug("---------------------------------------");
			StackTraceElement[] ste = e.getStackTrace();
			log.error(e.toString() + ":" + ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
		return model;
	}
	
	@RequestMapping (value="rsvSeatChange.do")
	public ModelAndView rsvSeatChange(	HttpServletRequest request, 
										@RequestBody Map<String,Object> params) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				return model;
			}

			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("userId", loginVO.getAdminId());
			
			ModelMap resultMap = resvService.resvSeatChange(params);
			model.addObject(resultMap);
		} catch (Exception e){
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			log.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		return model;
	}
	
	@RequestMapping (value="longResvInfoUpdate.do")
	@Transactional(rollbackFor = Exception.class)
	public ModelAndView rsvLongSeatUpdate(	HttpServletRequest request, 
											@RequestBody ResvInfo vo) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		try {
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				return model;
			}

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
			log.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		return model;
	}
	
	@RequestMapping (value="rsvInfoDetail.do")
	public ModelAndView selectRsvInfoDetail(	@RequestParam("resvSeq") String resvSeq, 
												HttpServletRequest request) throws Exception {	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
			return model;	
	    }	
		
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_REGINFO, resvService.selectResvInfoDetail(resvSeq));	     	
		return model;
	}
	
	@RequestMapping (value="resvInfoCancel.do")
	public ModelAndView updateResvInfoCancel(	@RequestParam("resvSeq") String resvSeq, 
										HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		try {
		    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;	
		    }
			
			ModelMap modelMap = resvService.resvInfoAdminCancel(resvSeq);
			model.addObject(modelMap);
		} catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			log.error(e.toString() + ":" + ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
	     	
		return model;
	}
	
	@RequestMapping (value="resvInfoCancelAll.do")
	public ModelAndView updateResvInfoCancelAll( 	@RequestBody Map<String,Object> params,
													HttpServletRequest request) throws Exception {	

		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		List<Map<String, Object>> resvCancelList = new LinkedList<Map<String, Object>>();

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
			
			List<Map<String, Object>> resvList = resvService.selectResvInfoManageListByPagination(params);

			for(Map<String,Object> resvInfo : resvList) {
				if(!SmartUtil.NVL(resvInfo.get("resv_ticket_dvsn"),"RESV_TICKET_DVSN_1").equals("RESV_TICKET_DVSN_2")) {
					String resvSeq = resvInfo.get("resv_seq").toString();
					ModelMap resultMap = resvService.resvInfoAdminCancel(resvSeq);
				
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
			StackTraceElement[] ste = e.getStackTrace();
			log.error(e.toString() + ":" + ste[0].getLineNumber());
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
			  
			  log.debug("------------------------pageUnit : " + pageUnit);
			  
			  //Paging
		   	  PaginationInfo paginationInfo = new PaginationInfo();
			  paginationInfo.setCurrentPageNo(Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
			  paginationInfo.setRecordCountPerPage(pageUnit);
			  paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
			  
			  searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
			  searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
			  searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
			  
			  log.debug("pageUnit End");
			  List<Map<String, Object>> list = attendService.selectAttendInfoListPage(searchVO);
			  log.debug("[-------------------------------------------list:" + list.size() + "------]");
		      model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		      model.addObject(Globals.STATUS_REGINFO, searchVO);
		      int totCnt = list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		      
		      log.debug("totCnt:" + totCnt);
		      
		      paginationInfo.setTotalRecordCount(totCnt);
		      model.addObject("paginationInfo", paginationInfo);
		      model.addObject("totalCnt", totCnt);
		      
		} catch(Exception e) {
			log.debug("---------------------------------------");
			StackTraceElement[] ste = e.getStackTrace();
			log.error(e.toString() + ":" + ste[0].getLineNumber());
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
	
	@RequestMapping (value="resvValidCheck.do")
	public ModelAndView resvValidCheck(	@ModelAttribute("loginVO") LoginVO loginVO,
										@RequestBody Map<String, Object> params,
										HttpServletRequest request,
										BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession(true);
			loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
			
			if(loginVO == null) {
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				return model;
			}
			
			resvService.resvValidCheck(params);
			
			model.addObject("validResult", params);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			log.error("resvValidCheck : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
}