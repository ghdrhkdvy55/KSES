package com.kses.backoffice.rsv.reservation.web;


import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.mng.employee.service.DeptInfoManageService;
import com.kses.backoffice.mng.employee.service.EmpInfoManageService;
import com.kses.backoffice.rsv.reservation.service.ResInfoManageService;
import com.kses.backoffice.rsv.reservation.service.ResTimeInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.ReservationInfo;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorPartInfoManageService;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/resManage")
public class ResInfoManageController {

	
	    private static final Logger LOGGER = LoggerFactory.getLogger(ResInfoManageController.class);
	 
		@Autowired
		protected EgovMessageSource egovMessageSource;
		
		@Autowired
	    protected EgovPropertyService propertiesService;

		
		@Autowired
		private ResInfoManageService resService;
		
		@Autowired
		private EmpInfoManageService empInfo;
		
		@Autowired
		private CenterInfoManageService centerService;
		
		@Autowired
		private DeptInfoManageService deptService;
		
		@Autowired
		private EgovCcmCmmnDetailCodeManageService egovCodeDetailService;
		
		//시간 관련 
		@Autowired
		private ResTimeInfoManageService timeService;
		
		@Autowired
		private FloorInfoManageService floorService;
		
		@Autowired
		private FloorPartInfoManageService partService;
		
//        @RequestMapping("reservationProcessChange.do")
//        public ModelAndView updateResProcessChange(@ModelAttribute("loginVO") LoginVO loginVO
//									                , @RequestBody ReservationInfo searchVO
//													, HttpServletRequest request
//													, BindingResult bindingResult) throws Exception{
//        	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
//        	try{
//    			  
//        		  Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
//				  if(!isAuthenticated) {
//				    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
//				    		model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
//				    		return model;
//				  }
//	        	  if (searchVO.getReservProcessGubun().equals("PROCESS_GUBUN_4") || searchVO.getReservProcessGubun().equals("PROCESS_GUBUN_5") || searchVO.getReservProcessGubun().equals("PROCESS_GUBUN_8")) {
//	        		  searchVO.setProxyUserId(EgovUserDetailsHelper.getAuthorities().toString());
//				  }
//	    		  int ret = resService.updateResManageChange(searchVO);
//	  			  //테넌트 처리 
//	  			  if (ret>0){
//	      				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//	    				model.addObject(Globals.STATUS_MESSAGE, "정상적으로 처리 되었습니다.");
//	  			  }else{
//	  				throw new Exception();
//	  			  }
//        	}catch(Exception e){
//	  			  LOGGER.error("resPreCheckString error:"+ e.toString());
//	  			  model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
//	  			  model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
//        	}
//        	return model;
//        }
//        //페이지 삭제 
//        
//		@RequestMapping(value="resInfo.do")		
//		public ModelAndView resResInfoPop(@ModelAttribute("loginVO") LoginVO loginVO
//				                                , @ModelAttribute("searchVO") ReservationInfo searchVO
//												, HttpServletRequest request
//												, BindingResult bindingResult) throws Exception{
//			
//		   String resSeq = request.getParameter("resSeq") != null ? request.getParameter("resSeq") : "";
//			
//		   ModelAndView model = new ModelAndView("/backoffice/popup/resInfo");
//		   
//		   try{
//			    searchVO.setResSeq(resSeq);
//			    
//			    Map<String, Object> resInfo = resService.selectResManageView(searchVO.getResSeq());
//				model.addObject("resInfo", resInfo);
//				//참석자
//				LOGGER.debug("resInfo.getResAttendlist():" + resInfo.get("res_attendlist"));
//				if (! SmartUtil.NVL(resInfo.get("res_attendlist"), "").equals("")){
//					List<String> empNoList =  SmartUtil.dotToList(resInfo.get("res_attendlist").toString());
//					LOGGER.debug("empNoList:" + empNoList.size());
//					model.addObject("resUserList", empInfo.selectMeetinngUserList(empNoList));
//				}
//		   }catch(Exception e){
//			   LOGGER.error("resResInfoPop error:" + e.toString());
//			   
//		   }
//		   return model;
//          
//		}
//		@RequestMapping(value="resInfoAjax.do")		
//		public ModelAndView resResInfoAjax(@ModelAttribute("loginVO") LoginVO loginVO
//			                                , @RequestParam("resSeq") String resSeq
//											, HttpServletRequest request
//											, BindingResult bindingResult) throws Exception{
//			
//		   
//		   ModelAndView model = new ModelAndView(Globals.JSONVIEW );
//		   
//		   try{
//			    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
//				if(!isAuthenticated) {
//				    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
//				    		model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
//				    		return model;
//				}
//				
//				LOGGER.debug("resSeq:" + resSeq + "=====================================================");
//			    Map<String, Object> resInfo = resService.selectResManageView(resSeq);
//				model.addObject("resInfo", resInfo);
//				//참석자
//				LOGGER.debug("resInfo.getResAttendlist():" + resInfo.get("res_attendlist"));
//				if (!SmartUtil.NVL(resInfo.get("res_attendlist"), "").equals("")){
//					List<String> empNoList =  Arrays.asList(resInfo.get("res_attendlist").toString().split("\\s*,\\s*"));
//					LOGGER.debug("empNoList:" + empNoList.size());
//					model.addObject("resUserList", empInfo.selectMeetinngUserList(empNoList));
//				}
//				//영상회의 이면 
//				if (resInfo.get("res_gubun").toString().equals("SWC_GUBUN_2") && !SmartUtil.NVL(resInfo.get("meeting_seq"), "").equals("")){
//					LOGGER.debug("resInfo.getMeetingSeq():" + resInfo.get("meeting_seq"));
//					List<String> swSeqList =   SmartUtil.dotToList(resInfo.get("meeting_seq").toString() );
//				}
//				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//		   }catch(Exception e){
//			   StackTraceElement[] ste = e.getStackTrace();
//			   int lineNumber = ste[0].getLineNumber();
//			   LOGGER.error("resResInfoPop error:" + e.toString() + ":" + lineNumber);
//			   model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
//			   model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
//		   }
//		   return model;
//          
//		}
//		
//		//좌셕 현황 리스트
//		@RequestMapping(value="seatStateInfo.do")		
//		public ModelAndView resSeatStateInfo(@RequestBody Map<String, Object> params
//												 , HttpServletRequest request
//												 , BindingResult bindingResult) throws Exception{
//		
//		  ModelAndView model = new ModelAndView(Globals.JSONVIEW);
//		  
//		  
//		  try{
//			  if ( SmartUtil.NVL(params.get("resStarttime"),"").equals("") ) {
//				  params.put("resStarttime", "0900");
//			  }
//			  if (SmartUtil.NVL(params.get("resEndtime"),"").equals("")  ) {
//				  params.put("resEndtime", "1730");
//			  }
//			  
//			  if (params.get("floorSeq") != null ) {
//					 Map<String, Object> mapInfo = params.get("partSeq") == null ? floorService.selectFloorInfoManageDetail(params.get("floorSeq").toString()) : partService.selectFloorPartInfoManageDetail(params.get("partSeq").toString());
//			    	 model.addObject("seatMapInfo", mapInfo);
//			  }
//	  		  model.addObject(Globals.JSON_RETURN_RESULTLISR, timeService.selectSeatStateInfo(params));
//	  		  model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//		  }catch(Exception e){
//			  LOGGER.error("resSeatStateInfo error:"+ e.toString());
//			  model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
//			  model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
//		  }
//		  return model;
//		}
//		@RequestMapping(value="resList.do")		
//		public ModelAndView resList(@ModelAttribute("loginVO") LoginVO loginVO
//											 , @ModelAttribute("searchVO") ReservationInfo searchVO
//											 , HttpServletRequest request
//											 , BindingResult bindingResult) throws Exception{
//		
//		  ModelAndView model = new ModelAndView("/backoffice/resManage/resList");
//		  
//		  try{
//			  
//			  Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
//			  
//			  
//			 
//			  if(!isAuthenticated) {
//				    HttpSession httpSession = request.getSession(true);
//			    	loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
//				   
//				    //로그인 시 이상하게 풀룸 신규로 잡아 놓음 나중에 다시 수정 해야함 
//				    if (!loginVO.getAuthorCode().equals("")) {
//				    	Authentication authentication = new UsernamePasswordAuthenticationToken(loginVO.getAdminId(), "USER_PASSWORD");   
//		            	SecurityContext securityContext = SecurityContextHolder.getContext();
//		                securityContext.setAuthentication(authentication);
//				    }else {
//				    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
//			    		model.setViewName("/backoffice/login");
//			    		return model;
//				    }
//			  }else{
//			    	 HttpSession httpSession = request.getSession(true);
//			    	 loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
//				     searchVO.setAuthorCode(loginVO.getAuthorCode());
//			  }
//			  model.addObject("searchCenterId", centerService.selectCenterInfoManageCombo());    
//	  		  model.addObject("selectOrg", deptService.selectOrgInfoCombo());
//	  		  model.addObject("selectResType", egovCodeDetailService.selectCmmnDetailCombo("swc_gubun"));
//	  		  model.addObject("selectItemGubun", egovCodeDetailService.selectCmmnDetailCombo("ITEM_GUBUN"));
//	  		  model.addObject("selectCancel", egovCodeDetailService.selectCmmnDetailCombo("CANCEL_CODE") );
//	  		  
//	  		  //신규 추가 
//	  		  CmmnDetailCodeVO detailvo = new CmmnDetailCodeVO();
//	  		  detailvo.setCodeId("PROCESS_GUBUN");
//	  		  model.addObject("selectProcessType", egovCodeDetailService.selectCmmnDetailResTypeCombo(detailvo));
//	  		  detailvo.setSearchCodedc("3");
//	  		  model.addObject("selectProcessTypeAdmin", egovCodeDetailService.selectCmmnDetailResTypeCombo(detailvo));
//	  		  model.addObject(Globals.STATUS_REGINFO, searchVO);
//	  		  
//	  		  //
//		  }catch(Exception e){
//			  LOGGER.error("resPreCheckString error:"+ e.toString());
//			  model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
//			  model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
//		  }
//		  return model;
//		}
//		@RequestMapping(value="resListAjax.do")
//		public ModelAndView resListAjax (@ModelAttribute("loginVO") LoginVO loginVO
//				                         , @RequestBody Map<String, Object> searchVO
//	                                     , HttpServletRequest request
//	                                     , BindingResult bindingResult) throws Exception {
//			
//			ModelAndView model = new ModelAndView(Globals.JSONVIEW);
//			
//			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
//			
//			try{
//				if(!isAuthenticated) {
//			    	 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
//			    	 model.setViewName("/backoffice/login");
//			    	 return model;
//				}else{
//					 HttpSession httpSession = request.getSession(true);
//				     loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
//				     
//				     //HashMap<String, Object> searchVO = new HashMap<String, Object>(); 
//				     
//				     searchVO.put("authorCode", loginVO.getAuthorCode());
//				     
//				     PaginationInfo paginationInfo = new PaginationInfo();
//					 paginationInfo.setCurrentPageNo( Integer.valueOf( SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
//					 paginationInfo.setRecordCountPerPage(Integer.valueOf( SmartUtil.NVL(searchVO.get("pageUnit"), propertiesService.getInt("pageUnit"))));
//					 paginationInfo.setPageSize(Integer.valueOf( SmartUtil.NVL(searchVO.get("pageSize"), propertiesService.getInt("pageSize"))));
//					 
//					 searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
//					 searchVO.put("lastIndex", paginationInfo.getLastRecordIndex());
//					 searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
//					
//					 
//			         String date1 = SmartUtil.NVL(searchVO.get("searchStartDay"),  com.kses.backoffice.util.SmartUtil.reqDay(-7)) ;
//			         String date2 =  SmartUtil.NVL(searchVO.get("searchEndDay"),  com.kses.backoffice.util.SmartUtil.reqDay(0)) ;
//			         searchVO.put("searchStartDay", date1);
//			         searchVO.put("searchEndDay", date2);
//			         searchVO.put("SearchEmpno", loginVO.getAdminId());
//			          
//			  		 List<Map<String, Object>> reslist = resService.selectResManageListByPagination(searchVO);
//			  		 int totCnt = reslist.size() > 0 ?  Integer.valueOf(reslist.get(0).get("total_record_count").toString()) : 0;
//				     model.addObject(Globals.JSON_RETURN_RESULTLISR,  reslist );
//				     model.addObject(Globals.STATUS_REGINFO, searchVO);
//				     
//				     
//				     paginationInfo.setTotalRecordCount(totCnt);
//				     model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
//				     model.addObject(Globals.PAGE_TOTALCNT, totCnt);
//				     model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//				     
//				}
//			}catch(Exception e){
//				 StackTraceElement[] ste = e.getStackTrace();
//			      
//		         int lineNumber = ste[0].getLineNumber();
//				 LOGGER.error("resPreCheckString error:"+ e.toString() + ":" + lineNumber);
//				 
//				 model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
//				 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
//			}
//			return model;
//		}
//		@RequestMapping("resListExcel.do")
//    	public ModelAndView selectBrodExcelList (@ModelAttribute("loginVO") LoginVO loginVO
//								    			 , @ModelAttribute("resInfo") ReservationInfo resInfo 
//								                 , HttpServletRequest request
//								                 , BindingResult bindingResult) throws Exception {
//			
//			
//			Map<String, Object> map = new HashMap<String, Object>();
//			try {
//				
//				Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
//				
//				
//				HashMap<String, Object> searchVO = new HashMap<String, Object>();
//				if(!isAuthenticated) {
//					 ModelAndView model = new ModelAndView();
//			    	 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
//			    	 model.setViewName("/backoffice/login");
//			    	 return model;
//				}else{
//				    	 HttpSession httpSession = request.getSession(true);
//				    	 loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
//					     searchVO.put("authorCode",loginVO.getAuthorCode());
//				}
//				
//	            //관리자 강제로 사용
//	            
//	            PaginationInfo paginationInfo = new PaginationInfo();
//	  		    paginationInfo.setCurrentPageNo(1);
//	  		    paginationInfo.setRecordCountPerPage(10000);
//	  		    paginationInfo.setPageSize(10000);
//	  		    
//	  		    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
//				searchVO.put("lastIndex", 100000000);
//				searchVO.put("recordCountPerPage", 1000000);
//				 
//				String date1 = SmartUtil.NVL(resInfo.getSearchStartDay(),  SmartUtil.reqDay(-7)) ;
//		        String date2 =  SmartUtil.NVL(resInfo.getSearchEndDay(),  SmartUtil.reqDay(0)) ;
//		        searchVO.put("searchStartDay", date1);
//		        searchVO.put("searchEndDay", date2);
//		        searchVO.put("searchDayGubun", resInfo.getSearchDayGubun());
//		        searchVO.put("searchCondition", resInfo.getSearchCondition());
//		        searchVO.put("searchKeyword", resInfo.getSearchKeyword());
//		        searchVO.put("itemGubun", resInfo.getItemGubun());
//		        searchVO.put("searchReservProcessGubun", resInfo.getSearchReservProcessGubun());
//		        
//		        searchVO.put("SearchEmpno", loginVO.getAdminId());
//		          
//		  		List<Map<String, Object>> reslist = resService.selectResManageListByPagination(searchVO);
//		  		int totCnt = reslist.size() > 0 ?  Integer.valueOf(reslist.get(0).get("total_record_count").toString()) : 0;	
//	    		map.put("resReport", reslist);
//	    		map.put("resType", searchVO.get("resType"));
//
//	    		
//			}catch(Exception e) {
//				StackTraceElement[] ste = e.getStackTrace();
//			    int lineNumber = ste[0].getLineNumber();
//				LOGGER.error("resPreCheckString error:"+ e.toString() + ":" + lineNumber);
//			}
//        	
//			return new ModelAndView("ResReportExcelView", map);
//			 
//    		
//    	}
		
}
