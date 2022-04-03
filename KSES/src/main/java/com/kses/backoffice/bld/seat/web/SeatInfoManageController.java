package com.kses.backoffice.bld.seat.web;

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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import com.google.gson.reflect.TypeToken;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorPartInfoManageService;
import com.kses.backoffice.bld.seat.service.SeatInfoManageService;
import com.kses.backoffice.bld.seat.vo.SeatInfo;
import com.kses.backoffice.util.SmartUtil;

import javax.servlet.ServletContext;

@RestController
@RequestMapping("/backoffice/bld")
public class SeatInfoManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SeatInfoManageController.class);
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private EgovCcmCmmnDetailCodeManageService cmmnDetailService;
	
	@Autowired
	private SeatInfoManageService seatService;
	
	@Autowired
	private FloorInfoManageService floorService;
	
	@Autowired
	private FloorPartInfoManageService partService;
	
	@Autowired
	private CenterInfoManageService centerInfoManageService;
	
	@Autowired
    ServletContext servletContext;
	
	@RequestMapping(value="seatList.do")
	public ModelAndView selectCenterInfoList(@ModelAttribute("loginVO") LoginVO loginVO
															, HttpServletRequest request
															, BindingResult bindingResult	) throws Exception {
		
		
        ModelAndView model = new ModelAndView(); 
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
        
        if(!isAuthenticated) {
        	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
        	model.setViewName("/backoffice/login");
        	return model;	
        } else {
        	HttpSession httpSession = request.getSession(true);
        	loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
        }
		  
        model.addObject("centerList", centerInfoManageService.selectCenterInfoComboList()); 
        model.addObject("seatClass", cmmnDetailService.selectCmmnDetailCombo("SEAT_CLASS"));
        model.addObject("seatDvsn", cmmnDetailService.selectCmmnDetailCombo("SEAT_DVSN"));
        model.addObject("payDvsn", cmmnDetailService.selectCmmnDetailCombo("PAY_DVSN"));	      
        model.setViewName("/backoffice/bld/seatList");
        model.addObject("loginVO" , loginVO);
        return model;	
	}
	
	//좌석 리스트 보여 주기 
	@RequestMapping(value="seatListAjax.do")
	public ModelAndView selectSeatInfoList(	@ModelAttribute("loginVO") LoginVO loginVO, 
											@RequestBody Map<String,Object> searchVO, 
											HttpServletRequest request, 
											BindingResult bindingResult	) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		
		try {
			
			int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			  
		    searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		  
		    LOGGER.info("pageUnit:" + pageUnit);
		  
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
			  
			  
			List<Map<String, Object>> seatList = seatService.selectSeatInfoList(searchVO);
			int totCnt = seatList.size() > 0 ?  Integer.valueOf( seatList.get(0).get("total_record_count").toString()) : 0;
			model.addObject(Globals.JSON_RETURN_RESULTLISR, seatList);
			
			//System.out.println(seatList);
			
		    model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		    paginationInfo.setTotalRecordCount(totCnt);
		    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		    
		    //지도 이미지 
		    if (searchVO.get("searchFloorCd") != null ) {
		    	LOGGER.info(searchVO.get("searchPartCd").toString());
		    	Map<String, Object> mapInfo = "0".equals((String)searchVO.get("searchPartCd")) ? floorService.selectFloorInfoDetail(searchVO.get("searchFloorCd").toString()) : partService.selectFloorPartInfoDetail(searchVO.get("searchPartCd").toString());
		    	model.addObject("seatMapInfo", mapInfo);
		    }

		    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

		} catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
		return model;
	}
	
	/*
	 * 좌석 정보 상세 조회 
	 * 
	 */
	@RequestMapping (value="seatInfoDetail.do")
	public ModelAndView selectSeatInfoDetail(	@ModelAttribute("LoginVO") LoginVO loginVO, 
												@RequestBody SeatInfo vo) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }
	    try {
	    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, seatService.selectSeatInfoDetail(vo.getSeatCd()));
	    } catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
	    }
	    return model;
	}
	
	@NoLogging
	@RequestMapping (value="seatInfoUpdate.do")
	public ModelAndView updateSeatInfo(	HttpServletRequest request, 
										@ModelAttribute("LoginVO") LoginVO loginVO, 
										@RequestBody SeatInfo vo, 
										BindingResult result ) throws Exception{
		
        ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
		} else {
			HttpSession httpSession = request.getSession(true);
			loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
			vo.setFrstRegterId(loginVO.getAdminId());
			vo.setLastUpdusrId(loginVO.getAdminId());
	    }
		
		try {
			model.addObject(Globals.STATUS_REGINFO , vo);
			int ret  = seatService.updateSeatInfo(vo);
			String meesage = vo.getMode().equals("Ins") ? "sucess.common.insert" : "sucess.common.update" ;
//			if (ret >0){		
//				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
//			 }else if(ret == -1){
//				meesage = "fail.common.overlap";
//				model.addObject(Globals.STATUS, Globals.STATUS_OVERLAPFAIL);
//				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));		
//			 }else {
//				throw new Exception();
//			 }
			 // hgp 2021.12.14 오라클 멀티쿼리 반환값 이슈로 임시 주석처리			
             model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
		} catch (Exception e) {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		return model;
	}
	
	/*
	 * 좌석 삭제 
	 * 
	 */
	@RequestMapping (value="seatInfoDelete.do")
	public ModelAndView seatInfoDelete(	@ModelAttribute("loginVO") LoginVO loginVO,
										@RequestParam("seatCd") String seatCd )throws Exception{
		
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }	
		
	    try {
	    	//삭제 관련 내용 수정 공용에서 수정으로 
	    	int ret =  seatService.deleteSeatInfo(SmartUtil.dotToList(seatCd));
	    	// hgp 2021.12.14 오라클 멀티쿼리 반환값 이슈로 임시 주석처리			
            model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));
//	    	if (ret > 0) {		
//	    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//	    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );		    	 
//	    	} else {
//	    		throw new Exception();		    	  
//	    	}
		} catch (Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}

	//수정 구문 
	@RequestMapping(value="seatGuiUpdate.do", method=RequestMethod.POST)
	public ModelAndView updateSeatGuiPosition (	@RequestBody Map<String, Object> params, 
												HttpServletRequest request, 
												BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }
		try {
			
			Gson gson = new GsonBuilder().create();
			List<SeatInfo> seatInfos = gson.fromJson(params.get("data").toString(), new TypeToken<List<SeatInfo>>(){}.getType());
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    	String userId = loginVO.getAdminId();
	    	seatInfos.forEach(SeatInfo -> SeatInfo.setUserId(userId));
			
			
			int result = seatService.updateSeatPositionInfo(seatInfos);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
            model.addObject("resutlCnt", result);
		}catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.update"));
		}
		return model;
		
	}
	//신규 excel upload
	@RequestMapping(value="SeatExcelUpload.do", method=RequestMethod.POST)
	public ModelAndView updateExcelUpload (@RequestBody Map<String, Object> params, 
										  HttpServletRequest request, 
										  BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }
	    
	    try {
	    	
	    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    	String userId = loginVO.getAdminId();
	    	
	    	Gson gson = new GsonBuilder().create();
	    	List<SeatInfo> seatInfos = gson.fromJson(params.get("data").toString(), new TypeToken<List<SeatInfo>>(){}.getType());
			//좌석/ 회의실 정리 하기 
	    	seatInfos.forEach(SeatInfo -> SeatInfo.setUserId(userId));
			
	    	int result = seatService.updateSeatPositionInfo(seatInfos);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
            model.addObject("resutlCnt", result);
            
	    } catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));
	    }
	    return model;
		
	}
}