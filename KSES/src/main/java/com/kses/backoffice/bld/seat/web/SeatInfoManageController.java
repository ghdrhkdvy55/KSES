package com.kses.backoffice.bld.seat.web;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorPartInfoManageService;
import com.kses.backoffice.bld.seat.service.SeatInfoManageService;
import com.kses.backoffice.bld.seat.vo.SeatInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/backoffice/bld")
public class SeatInfoManageController {
	
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
	
	/**
	 * 좌석관리 화면
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="seatList.do", method = RequestMethod.GET)
	public ModelAndView viwSeatList() throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/bld/seatList");
		model.addObject("centerList", centerInfoManageService.selectCenterInfoComboList());
        model.addObject("seatClass", cmmnDetailService.selectCmmnDetailCombo("SEAT_CLASS"));
        model.addObject("seatDvsn", cmmnDetailService.selectCmmnDetailCombo("SEAT_DVSN"));
        model.addObject("payDvsn", cmmnDetailService.selectCmmnDetailCombo("PAY_DVSN"));	      
        return model;
	}

	/**
	 * 좌석 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "seatListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectSeatInfoList(@RequestBody Map<String,Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		searchVO.put("authorCd", loginVO.getAuthorCd());
		searchVO.put("centerCd", loginVO.getCenterCd());

		List<Map<String, Object>> list = seatService.selectSeatInfoList(searchVO);
		int totCnt = list.size() > 0 ? Integer.valueOf(list.get(0).get("total_record_count").toString()) : 0;
		paginationInfo.setTotalRecordCount(totCnt);

		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

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
	    	log.info(e.toString());
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
			String meesage = vo.getMode().equals(Globals.SAVE_MODE_INSERT) ? "sucess.common.insert" : "sucess.common.update" ;
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
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}

	/**
	 * 좌석 정보 저장
	 * @param seatInfoList
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value = "seatGuiUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateSeatGuiPosition (	@RequestBody List<SeatInfo> seatInfoList) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		seatInfoList.stream().forEach(x -> x.setLastUpdusrId(userId));
		seatService.updateSeatPositionInfo(seatInfoList);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.update"));

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
	    	log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));
	    }
	    return model;

	}
}