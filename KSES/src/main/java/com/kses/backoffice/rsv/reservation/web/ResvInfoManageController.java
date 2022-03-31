package com.kses.backoffice.rsv.reservation.web;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.rsv.reservation.service.AttendInfoManageService;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.AttendInfo;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

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
	 * 예약정보 화면 호출
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="rsvList.do", method = RequestMethod.GET)
	public ModelAndView viewRsvInfoList() throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/rsv/rsvList"); 
			
		model.addObject("centerInfo", centerService.selectCenterInfoComboList());
		model.addObject("resvUserDvsn", codeDetailService.selectCmmnDetailCombo("USER_DVSN"));
		model.addObject("resvState", codeDetailService.selectCmmnDetailCombo("RESV_STATE"));
		model.addObject("resvPayDvsn", codeDetailService.selectCmmnDetailCombo("RESV_PAY_DVSN"));
		model.addObject("resvTicketDvsn", codeDetailService.selectCmmnDetailCombo("RESV_TICKET_DVSN"));
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

		return model;	
	}
    
	/**
	 * 예약정보 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="rsvListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectResvInfoListAjAX(@RequestBody Map<String,Object> searchVO) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		int pageUnit = searchVO.get("pageUnit") == null ?  propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));

   	    PaginationInfo paginationInfo = new PaginationInfo();
	    paginationInfo.setCurrentPageNo( Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"),"1")));
	    paginationInfo.setRecordCountPerPage(pageUnit);
	    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

	    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
	    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
	    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		searchVO.put("authorCd", loginVO.getAuthorCd());
		searchVO.put("centerCd", loginVO.getCenterCd());
	    
	    List<Map<String, Object>> list = resvService.selectResvInfoManageListByPagination(searchVO);
        int totCnt =  list.size() > 0 ? Integer.valueOf(list.get(0).get("total_record_count").toString()) : 0;
		paginationInfo.setTotalRecordCount(totCnt);
		      
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		model.addObject(Globals.STATUS_REGINFO, searchVO);		      
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);	    

		return model;
	}
	
	/**
	 * 예약정보 단건 상세조회 
	 * @param resvSeq
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="rsvInfoDetail.do", method = RequestMethod.GET)
	public ModelAndView selectRsvInfoDetail(@RequestParam("resvSeq") String resvSeq) throws Exception {	
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.JSON_RETURN_RESULT, resvService.selectResvInfoDetail(resvSeq));	     	
		return model;
	}
	
	/**
	 * 예약 좌석정보 변경
	 * @param params
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="rsvSeatChange.do", method = RequestMethod.POST)
	public ModelAndView updateRsvSeatChange(@RequestBody Map<String,Object> params) throws Exception {
		String adminId = EgovUserDetailsHelper.getAuthenticatedUserId();
		params.put("adminId", adminId);
		ModelMap modelMap = resvService.resvSeatChange(params);		
		return new ModelAndView(Globals.JSONVIEW, modelMap);
	}
	
	/**
	 * 예약 상태정보 갱신
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="rsvStateChange.do", method = RequestMethod.POST)
	public ModelAndView rsvStateChange(@RequestBody ResvInfo vo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String adminId = EgovUserDetailsHelper.getAuthenticatedUserId();
		vo.setLastUpdusrId(adminId);
		int ret = resvService.updateResvState(vo);
		
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.update"));
		} else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.update"));
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
			log.info("rsvLongSeatUpdate : " + e.toString() + " : " + ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		return model;
	}
	
	/**
	 * 예약정보 취소
	 * @param resvSeq
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="resvInfoCancel.do", method=RequestMethod.GET)
	public ModelAndView updateResvInfoCancel(@RequestParam("resvSeq") String resvSeq) throws Exception {	
		ModelMap modelMap = resvService.resvInfoAdminCancel(resvSeq, "", false);
		return new ModelAndView(Globals.JSONVIEW,modelMap);
	}
	
	/**
	 * 예약 전체 취소
	 * @param params
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="resvInfoCancelAll.do", method=RequestMethod.POST)
	public ModelAndView updateResvInfoCancelAll(@RequestBody Map<String,Object> params) throws Exception {	
		
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

			if(SmartUtil.NVL(params.get("mode"), "").toString().equals("Long")) {
				params.put("searchResvState","RESV_STATE_1");
				params.put("searchResvPayDvsn","RESV_PAY_DVSN_1");
				params.put("searchLongResvSeq", params.get("longResvSeq").toString());
			} else {
				params.put("searchCenterCd", params.get("centerCd").toString());
				params.put("searchFrom", params.get("resvDate").toString());
				params.put("searchTo", params.get("resvDate").toString());
				params.put("searchDayCondition","resvDate");
				params.put("searchResvState","RESV_STATE_4");
				params.put("searchStateCondition","cancel");
			}
			params.put("firstIndex", 0);
			params.put("recordCountPerPage", 5000);

			List<Map<String, Object>> resvList = resvService.selectResvInfoManageListByPagination(params);

			for(Map<String,Object> resvInfo : resvList) {
				if(!SmartUtil.NVL(resvInfo.get("resv_ticket_dvsn"),"").equals("RESV_TICKET_DVSN_2")) {
					String resvSeq = resvInfo.get("resv_seq").toString();
					ModelMap resultMap = resvService.resvInfoAdminCancel(resvSeq, "", false);
				
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
	
	/**
	 * 예약 출입정보 목록 조회 
	 * @param searchVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="attendListAjax.do", method=RequestMethod.POST)
	public ModelAndView selectAttendListAjax(@RequestBody Map<String,Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		int pageUnit = searchVO.get("pageUnit") == null ?  propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));

   	    PaginationInfo paginationInfo = new PaginationInfo();
	    paginationInfo.setCurrentPageNo( Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"),"1")));
	    paginationInfo.setRecordCountPerPage(pageUnit);
	    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

	    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
	    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
	    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());

	    List<Map<String, Object>> list = attendService.selectAttendInfoListPage(searchVO);
        int totCnt =  list.size() > 0 ? Integer.valueOf(list.get(0).get("total_record_count").toString()) : 0;
		paginationInfo.setTotalRecordCount(totCnt);

		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
	    model.addObject(Globals.PAGE_TOTALCNT, totCnt);
	    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
	    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
	    
		return model;
	}
	
	/**
	 * 예약 출입정보 갱신
	 * @param request
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="attendInfoUpdate.do", method=RequestMethod.POST)
	public ModelAndView updateAttendInfo(@RequestBody AttendInfo vo) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String adminId = EgovUserDetailsHelper.getAuthenticatedUserId();
		vo.setEnterAdminId(adminId);
		vo = attendService.insertAttendInfo(vo);
			
		if(vo.getRet() > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.insert"));
		} else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}

		return model;
	}
	
	/**
	 * 예약정보 유효성 검사 (좌석변경/장기예약)
	 * @param params
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="resvValidCheck.do", method=RequestMethod.POST)
	public ModelAndView resvValidCheck(@RequestBody Map<String, Object> params) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		resvService.resvValidCheck(params); 
		model.addObject(Globals.JSON_RETURN_RESULT, params);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		return model;
	}
}