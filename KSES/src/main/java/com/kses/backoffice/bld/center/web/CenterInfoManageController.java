package com.kses.backoffice.bld.center.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.center.vo.CenterInfo;
import com.kses.backoffice.bld.floor.service.FloorInfoManageService;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;
import com.kses.backoffice.util.service.fileService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/bld")
public class CenterInfoManageController {
	
	//파일 업로드
    @Autowired
	private fileService uploadFile;
    
	@Autowired
	private CenterInfoManageService centerInfoManageService;
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private UniSelectInfoManageService uniService;
	
	@Autowired
	private EgovCcmCmmnDetailCodeManageService codeDetailService;
	
	@Autowired
	private FloorInfoManageService floorService;

	/**
	 * 지점관리 화면
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="centerList.do", method = RequestMethod.GET)
	public ModelAndView viewCenterList(@ModelAttribute("searchVO") CenterInfo searchVO) throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/bld/centerList"); 
		List<Map<String, Object>> centerInfoComboList = centerInfoManageService.selectCenterInfoComboList();
		model.addObject("centerInfoComboList", centerInfoComboList);
		model.addObject("floorInfo", codeDetailService.selectCmmnDetailCombo("CENTER_FLOOR"));
		model.addObject(Globals.STATUS_REGINFO , searchVO);
		return model;	
	}
	
	//combo box 신규 추가 
	@RequestMapping(value="centerCombo.do")
	public ModelAndView selectCenterComboInfoList(@ModelAttribute("loginVO") LoginVO loginVO, 
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
			List<Map<String, Object>> centerInfoComboList = centerInfoManageService.selectCenterInfoComboList();
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.JSON_RETURN_RESULTLISR, centerInfoComboList);
			
		}catch(Exception e) {
			log.debug("---------------------------------------");
			StackTraceElement[] ste = e.getStackTrace();
			log.error(e.toString() + ":" + ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
		
		return model;	
	}
	
	/**
	 * 지점 목록 조회
	 * @param searchVO
	 * @param request
	 * @param bindingResult
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="centerListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectCenterAjaxInfo(@RequestBody Map<String,Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
		  
		searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		
		log.debug("------------------------pageUnit : " + pageUnit);
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//Paging
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1").toString()));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		searchVO.put("authorCd", loginVO.getAuthorCd());
		searchVO.put("centerCd", loginVO.getCenterCd());
		
		List<Map<String, Object>> list = centerInfoManageService.selectCenterInfoList(searchVO);
		log.debug("[-------------------------------------------list:" + list.size() + "------]");
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		model.addObject(Globals.STATUS_REGINFO, searchVO);
		int totCnt = list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) :0;
		
		log.debug("totCnt:" + totCnt);
		
		paginationInfo.setTotalRecordCount(totCnt);
		model.addObject("paginationInfo", paginationInfo);
		model.addObject("totalCnt", totCnt);
		
		return model;
	}
	
	//센터 정보 상세
	// post 에서 get으로 변경 
	@RequestMapping (value="centerInfoDetail.do")
	public ModelAndView selectCenterInfoDetail(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestParam("centerCd") String centerCd , 
												HttpServletRequest request, 
												BindingResult bindingResult) throws Exception {	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
			return model;	
	    }	
		
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_REGINFO, centerInfoManageService.selectCenterInfoDetail(centerCd));	     	
		return model;
	}
	
	@NoLogging
	@RequestMapping (value="centerInfoUpdate.do")
	public ModelAndView updateCenterInfo(	HttpServletRequest request, 
											MultipartRequest mRequest, 
											@ModelAttribute("LoginVO") LoginVO loginVO, 
											@ModelAttribute("CenterInfo") CenterInfo vo, 
											BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
		} 	
		try {
			
			model.addObject(Globals.STATUS_REGINFO , vo);
			String meesage = "";
			
	    	vo.setCenterImg(uploadFile.uploadFileNm(mRequest.getFiles("centerImg"), propertiesService.getString("Globals.filePath")));
			vo.setCenterMap(uploadFile.uploadFileNm(mRequest.getFiles("setCenterMap"), propertiesService.getString("Globals.filePath")));
			
			meesage = vo.getMode().equals(Globals.SAVE_MODE_INSERT) ? "sucess.common.insert" : "sucess.common.update";
			//userid로 변경 
			loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			vo.setUserId(loginVO.getAdminId());
			centerInfoManageService.updateCenterInfoManage(vo);
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));		
		} catch (Exception e){
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		return model;
	}
	
	@RequestMapping (value="centerInfoDelete.do")
	public ModelAndView deleteCenterInfoManage(	@ModelAttribute("loginVO") LoginVO loginVO,
			                                   	@RequestParam("centerList") String centerList,
			                                   	HttpServletRequest request) throws Exception {
		
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    
	    List<String> centerLists =  SmartUtil.dotToList(centerList);
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }	
	    
	    try {
	    	for(String centerCd : centerLists) {
	    		//이미지 삭제 먼저 하기 
		    	int ret = uniService.deleteUniStatement("CENTER_IMG", "TSEB_CENTER_INFO_M", "CENTER_CD = [" + centerCd + "[");		      
		    	
		    	if (ret > 0 ) {
		    		//층 삭제
		    		uniService.deleteUniStatement("FLOOR_MAP1, FLOOR_MAP2", "TSEB_FLOOR_INFO_M", "CENTER_CD = [" + centerCd + "[");
		    		
		    		//구역 삭제 
		    		uniService.deleteUniStatement("PART_MAP1, PART_MAP2", "TSEB_PART_INFO_D", "CENTER_CD = [" + centerCd + "[");
		    		
		    		//사전예약 입장시간 정보 삭제 
		    		uniService.deleteUniStatement("", "TSEB_RESV_ADMSTM_D", "CENTER_CD = [" + centerCd + "[");
		    		
		    		//자동취소 시간 정보 삭제 
		    		uniService.deleteUniStatement("", "TSEB_NOSHOW_INFO_M", "CENTER_CD = [" + centerCd + "[");
		    		
		    		//휴일 정보 삭제 
		    		uniService.deleteUniStatement("", "TSEC_HOLY_INFO_M", "CENTER_ID=[" + centerCd + "[");		    	 
		    	} else {
		    		throw new Exception();		    	  
		    	}	
	    	}
	    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );
		} catch (Exception e) {
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}
	
	//좌석 일괄 등록
	@NoLogging
	@RequestMapping (value="floorSeatUpdate.do")
	public ModelAndView updateFloorSeatUpdateInfoManage(	@ModelAttribute("LoginVO") LoginVO loginVO, 
															@RequestBody Map<String,Object> params, 
															HttpServletRequest request, 
															BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
		} else {
			HttpSession httpSession = request.getSession(true);
			loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
			params.put("frstRegterId", loginVO.getAdminId());
			params.put("lastUpdusrId", loginVO.getAdminId());
	    }
		
		try {
			floorService.insertFloorSeatUpdate(params);
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.insert"));
		} catch (Exception e) {
			log.error("floorSeatUpdate ERROR : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		log.debug("model:" + model.toString());
		return model;
	}
	
	@RequestMapping (value="seatCountInfo.do")
	public ModelAndView selectSeatCountInfo(	@ModelAttribute("LoginVO") LoginVO loginVO, 
												@RequestBody Map<String,Object> params, 
												HttpServletRequest request, 
												BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try{
			String is_condition = params.get("partCd") != "" ? "FLOOR_CD = [" + params.get("floorCd") + "[ AND PART_CD = [" + params.get("partCd") + "[" : "FLOOR_CD = [" + params.get("floorCd")+ "[";
			String is_Field = "SEAT_CD";
			String is_Table = "TSEB_SEAT_INFO_D";

			int ret = uniService.selectIdDoubleCheck(is_Field, is_Table, is_condition);
			
			model.addObject(Globals.STATUS  , Globals.STATUS_SUCCESS);
			model.addObject(Globals.JSON_RETURN_RESULT, ret);
			
		}catch (Exception e){
			log.error("selectSeatCountInfo ERROR : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}	
		log.debug("model : " + model.toString());
		return model;
	}
}