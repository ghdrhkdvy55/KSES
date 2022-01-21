package com.kses.backoffice.bld.floor.web;

import java.util.HashMap;
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
import com.kses.backoffice.bld.floor.service.FloorInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorPartInfoManageService;
import com.kses.backoffice.bld.floor.vo.FloorInfo;
import com.kses.backoffice.bld.partclass.service.PartClassInfoManageService;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;
import com.kses.backoffice.util.service.fileService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/bld")
public class FloorInfoManageController {
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
    
	//파일 업로드
    @Autowired
	private fileService uploadFile;
    
	@Autowired
	private CenterInfoManageService centerInfoManageService;

	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private EgovCcmCmmnDetailCodeManageService codeDetailService;
	
	@Autowired
	private CenterInfoManageService centerInfoService;
	
	@Autowired
	private FloorInfoManageService floorService;
	
	@Autowired
	private UniSelectInfoManageService uniService;
	
	@Autowired
	private FloorPartInfoManageService partService;
	
	@Autowired
	private PartClassInfoManageService partClassService;
	
	/**
	 * 층관리 화면
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping (value="floorList.do", method = RequestMethod.GET)
	public ModelAndView viewFloorList(@RequestParam Map<String, String> param) throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/bld/floorList");
		Map<String, Object> centerInfo = centerInfoManageService.selectCenterInfoDetail(param.get("searchCenterCd"));
		model.addObject(Globals.STATUS_REGINFO, centerInfo);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("code", "CENTER_FLOOR");
		params.put("startCode", centerInfo.get("start_floor"));
		params.put("endCode", centerInfo.get("end_floor"));
		model.addObject("floorlistInfo", codeDetailService.selectCmmnDetailComboEtc(params));
		
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		
		List<Map<String, Object>> centerInfoComboList = centerInfoService.selectCenterInfoComboList();
		model.addObject("centerInfoComboList", centerInfoComboList);
		model.addObject("floorlistInfo", codeDetailService.selectCmmnDetailComboEtc(params));
		model.addObject("floorListSeq", floorService.selectFloorInfoComboList(param.get("searchCenterCd")));
		model.addObject("floorPart", codeDetailService.selectCmmnDetailCombo("FLOOR_PART"));
			model.addObject("seatClass", partClassService.selectPartClassComboList(param.get("searchCenterCd")));
		model.addObject("seatDvsn", codeDetailService.selectCmmnDetailCombo("SEAT_DVSN"));
		model.addObject("payDvsn", codeDetailService.selectCmmnDetailCombo("PAY_DVSN"));
		
		return model;
	}

	/**
	 * 층관리 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "floorListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectFloorInfoListAjax(@RequestBody Map<String,Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String centerCd = (String) searchVO.get("centerCd");
		int pageUnit = searchVO.get("pageUnit") == null ?  propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));

		// 센터 값이 안들어 오면 에러 보내기
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

		searchVO.put("centerCd",  centerCd);
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());

		List<Map<String, Object>> floorList = floorService.selectFloorInfoList(searchVO);
		int totCnt = floorList.size() > 0 ?  Integer.valueOf( floorList.get(0).get("total_record_count").toString()) : 0;
		paginationInfo.setTotalRecordCount(totCnt);

		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, floorList);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

		return model;
	}
	
	@RequestMapping (value="floorInfoDetail.do")
	public ModelAndView selectFloorInfoManage(	@ModelAttribute("LoginVO") LoginVO loginVO, 
												@RequestBody FloorInfo floorInfo) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
			return model;	
	    }
	    
	    try {
	    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, floorService.selectFloorInfoDetail(floorInfo.getFloorCd()));
	    } catch(Exception e) {
	    	log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
	    }
	    return model;
	}
	// 층 신규 GUI 작업 
	@RequestMapping (value="floorInfoGui.do")
	public ModelAndView selectFloorInfoGuiManage(@ModelAttribute("LoginVO") LoginVO loginVO, 
												 @RequestParam("floorCd") String floorCd) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
			return model;	
	    }
	    
	    try {
	    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, floorService.selectFloorInfoDetail(floorCd));
			
			Map<String, Object> searchVO = new HashMap<String, Object>();
			searchVO.put("firstIndex", "0");
			searchVO.put("recordCountPerPage", "100");
			searchVO.put("floorCd", floorCd);
			List<Map<String, Object>> partList = partService.selectFloorPartInfoList(searchVO);
			int totCnt = partList.size() > 0 ?  Integer.valueOf( partList.get(0).get("total_record_count").toString()) :0;
			model.addObject(Globals.JSON_RETURN_RESULTLISR, partList);
		    model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		    
		    log.debug("에러 확인 ");
		    
	    } catch(Exception e) {
	    	StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			log.error("selectQrCheckInfo error:" + e + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
	    }
	    return model;
	}
	//combo box 구역 떄문에 수정 
	@RequestMapping (value="floorComboInfo.do")
	public ModelAndView selectFloorComboInfo(	@ModelAttribute("LoginVO") LoginVO loginVO, 
												@RequestParam("centerCd") String centerCd, 
												HttpServletRequest request, 
												BindingResult result) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try{
			model.addObject(Globals.STATUS  , Globals.STATUS_SUCCESS);
			List<Map<String, Object>> floorCombo =  floorService.selectFloorInfoComboList(centerCd);
			model.addObject(Globals.JSON_RETURN_RESULTLISR, floorService.selectFloorInfoComboList(centerCd));
			
		}catch (Exception e){
			log.error("floorComboInfo ERROR : " + e);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}	
		log.debug("model:" + model);
		return model;
	}
	
	@NoLogging
	@RequestMapping (value="floorInfoUpdate.do")
	public ModelAndView updateFloorInfo(HttpServletRequest request
			                                   , MultipartRequest mRequest
											   , @ModelAttribute("LoginVO") LoginVO loginVO
											   , @ModelAttribute("FloorInfo") FloorInfo vo
											   , BindingResult result) throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
		} else {
			HttpSession httpSession = request.getSession(true);
	    	loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
	    	vo.setLastUpdusrId(loginVO.getAdminId());
	    }
		
		try {
			
			model.addObject(Globals.STATUS_REGINFO , vo);
			String meesage = "";
			
	    	vo.setFloorMap1(uploadFile.uploadFileNm(mRequest.getFiles("floorMap1"), propertiesService.getString("Globals.filePath")));
			
			meesage = vo.getMode().equals(Globals.SAVE_MODE_INSERT) ? "sucess.common.insert" : "sucess.common.update" ;
				  		
			floorService.updateFloorInfo(vo);
			model.addObject(Globals.STATUS  , Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
		} catch (Exception e){
			log.error("floorInfoUpdate ERROR:" + e);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		log.debug("MODEL : " + model);
		return model;
	}
	
	@RequestMapping (value="floorInfoDelete.do")
	public ModelAndView deleteFloorInfo(	@ModelAttribute("loginVO") LoginVO loginVO, 
											@RequestParam("floorCd") String floorCd)throws Exception{
		
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }	
		
	    try {
			// 층수 먼저 정리 하기  
			Map<String, Object> vo = floorService.selectFloorInfoDetail(floorCd);
			centerInfoManageService.updateCenterFloorInfoManage(SmartUtil.checkItemList(SmartUtil.dotToList(vo.get("floor_info_cnt").toString()), vo.get("code_dc").toString() , "")  , vo.get("center_id").toString());
			
			// 이미지 삭제
			uniService.deleteUniStatement("FLOOR_MAP, FLOOR_MAP1", "TSEB_FLOOR_INFO_M", "FLOOR_CD=["+floorCd+"[");		      

			// 구역 삭제 
			uniService.deleteUniStatement("PART_MAP1, PART_MAP2", "TSEB_FLOOR_INFO_M", "FLOOR_CD=["+floorCd+"[");
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );		    	 
		}catch (Exception e){
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}

	
	/**
	//센터 정보 상세
	@RequestMapping (value="centerDetail.do")
	public ModelAndView selectCenterInfoDetail(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestBody CenterInfo vo, 
												HttpServletRequest request, 
												BindingResult bindingResult) throws Exception{	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;	
	    }	
		
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_REGINFO, centerInfoManageService.selectCenterInfoDetail(vo.getCenterCode()));	     	
		return model;
	}
	
	@RequestMapping (value="centerView.do")
	public ModelAndView selectCenterViewInfo (	@ModelAttribute("loginVO") LoginVO loginVO, 
												@ModelAttribute("searchVO") CenterInfo searchVO, 
												BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/bas/centerView");
		
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
					model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
					return model;	
		    }	
			
			Map<String, Object> centerInfo = centerInfoManageService.selectCenterInfoDetail(searchVO.getCenterCode());
			model.addObject(Globals.STATUS_REGINFO, centerInfo);
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("code", "CENTER_FLOOR");
			params.put("startCode", centerInfo.get("start_floor"));
			params.put("endCode", centerInfo.get("end_floor"));
			model.addObject("floorlistInfo", egovCodeDetailService.selectCmmnDetailComboEtc(params));
			//층수 리스트 
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			
			model.addObject("floorListSeq", floorService.selectFloorInfoComboList(searchVO.getCenterCode()));
			model.addObject("floorPart", egovCodeDetailService.selectCmmnDetailCombo("FLOOR_PART"));
			model.addObject("payGubun", egovCodeDetailService.selectCmmnDetailCombo("PAY_CLASSIFICATION"));
			model.addObject("seatGubun", egovCodeDetailService.selectCmmnDetailCombo("SEAT_GUBUN"));
			model.addObject("selectSwcGubun", egovCodeDetailService.selectCmmnDetailCombo("SWC_GUBUN"));
			
			
		}catch(Exception e) {
			LOGGER.error("selectCenterViewInfo:" + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	@RequestMapping (value="centerViewAjax.do")
	public ModelAndView selectCenterViewInfoAjax  (@ModelAttribute("loginVO") LoginVO loginVO
									               , @RequestBody Map<String,Object>  searchVO
									               , BindingResult result) throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
					model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
					return model;	
		    }	
			
			// 센터 값이 안들어 오면 에러 보내기 
			PaginationInfo paginationInfo = new PaginationInfo();
		    paginationInfo.setCurrentPageNo(Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
		    paginationInfo.setRecordCountPerPage(100);
		    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
			
			Map<String, Object> search = new HashMap<String,Object>();
			search.put("centerCode",  searchVO.get("centerCode"));
			search.put("firstIndex", "0");
			search.put("recordCountPerPage", "100");
			List<Map<String, Object>> floorList = floorService.selectFloorInfoList(search);
			int totCnt = floorList.size() > 0 ?  Integer.valueOf( floorList.get(0).get("total_record_count").toString()) :0;
			model.addObject(Globals.JSON_RETURN_RESULTLISR, floorList);
			model.addObject(Globals.PAGE_TOTALCNT, totCnt);
			paginationInfo.setTotalRecordCount(totCnt);
		    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			
		}catch(Exception e) {
			LOGGER.error("selectCenterViewInfo:" + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	@NoLogging
	@RequestMapping (value="centerUpdate.do")
	public ModelAndView updateCenterInfoManage(HttpServletRequest request
			                                   , MultipartRequest mRequest
											   , @ModelAttribute("LoginVO") LoginVO loginVO
											   , @ModelAttribute("CenterInfo") CenterInfo vo
											   , BindingResult result) throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
		}else {
	    	 HttpSession httpSession = request.getSession(true);
	    	 loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
	    	 //vo.setCenterUserId(EgovUserDetailsHelper.getAuthenticatedUser().toString());
	    }
		
		try{
			
			model.addObject(Globals.STATUS_REGINFO , vo);
			String meesage = "";
			vo.setCenterZipcode("");     	  
			
	    	vo.setCenterImg( uploadFile.uploadFileNm(mRequest.getFiles("centerImg"), propertiesService.getString("Globals.filePath")));
			
			meesage = vo.getMode().equals(Globals.SAVE_MODE_INSERT) ? "sucess.common.insert" : "sucess.common.update" ;
			int ret = centerInfoManageService.updateCenterInfoManage(vo);
			if (ret >0){
				model.addObject(Globals.STATUS  , Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
						
			}else {
				throw new Exception();
			}
			
		}catch (Exception e){
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		LOGGER.debug("model:" + model.toString());
		return model;
	}
	@RequestMapping (value="centerDelete.do")
	public ModelAndView deleteCenterInfoManage(@ModelAttribute("loginVO") LoginVO loginVO,
			                                   @RequestParam("centerCode") String centerCode)throws Exception{
		
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
				return model;	
	    }	
		try{
			  // 이미지 삭제 먼저 하기 
			
		      int ret = 	uniService.deleteUniStatement("CENTER_IMG,CENTER_SEAT_IMG", "tb_centerinfo", "CENTER_CODE=["+centerCode+"[");		      
		      if (ret > 0 ) {		
		    	  //층 삭제
		    	  uniService.deleteUniStatement("FLOOR_MAP, FLOOR_MAP1", "tb_floorinfo", "CENTER_CODE=["+centerCode+"[");
		    	  //구역 삭제 
		    	  uniService.deleteUniStatement("PART_MAP1, PART_MAP2", "tb_floorpart", "CENTER_CODE=["+centerCode+"[");
		    	  model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		    	  model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );		    	 
		      }else {
		    	  throw new Exception();		    	  
		      }
		}catch (Exception e){
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}
	
	
	 *  지점 층수 리스트 
	 * 
	 
	@RequestMapping (value="floorListAjax.do")
	public ModelAndView selectFloorListAjaxInfoManage(@ModelAttribute("LoginVO") LoginVO loginVO
			                                          , @RequestBody Map<String,Object>  searchVO
			                                          , HttpServletRequest request
			                                          , BindingResult result) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
					model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
					return model;	
		    }	
			// 센터 값이 안들오 오면 에러 보내기
			searchVO.put("firstIndex", "0");
			searchVO.put("recordCountPerPage", "100");
			List<Map<String, Object>> floorList = floorService.selectFloorInfoList(searchVO);
			int totCnt = floorList.size() > 0 ?  Integer.valueOf( floorList.get(0).get("total_record_count").toString()) :0;
			model.addObject(Globals.JSON_RETURN_RESULTLISR, floorList);
			model.addObject(Globals.PAGE_TOTALCNT, totCnt);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			LOGGER.debug("---------------------------------------------------" + totCnt);
		}catch(Exception e) {
			LOGGER.error("selectCenterViewInfo:" + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}

		   
	@RequestMapping (value="floorDetail.do")
	public ModelAndView selectFloorInfoManage(@ModelAttribute("LoginVO") LoginVO loginVO
									           , @RequestParam("floorSeq") String floorSeq	) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
				return model;	
	    }
	    try {
	    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, floorService.selectFloorInfoDetail(floorSeq));
	    }catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
	    }
	    return model;
	}
	@NoLogging
	@RequestMapping (value="floorUpdate.do")
	public ModelAndView updateFloorInfo(HttpServletRequest request
			                                   , MultipartRequest mRequest
											   , @ModelAttribute("LoginVO") LoginVO loginVO
											   , @ModelAttribute("FloorInfo") FloorInfo vo
											   , BindingResult result) throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
		}else {
	    	 HttpSession httpSession = request.getSession(true);
	    	 loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
	    	 vo.setUserId(EgovUserDetailsHelper.getAuthenticatedUser().toString());
	    }
		
		try{
			
			model.addObject(Globals.STATUS_REGINFO , vo);
			String meesage = "";
			
	    	vo.setFloorMap( uploadFile.uploadFileNm(mRequest.getFiles("floorMap"), propertiesService.getString("Globals.filePath")));
			vo.setFloorMap1( uploadFile.uploadFileNm(mRequest.getFiles("floorMap1"), propertiesService.getString("Globals.filePath")));
			meesage = vo.getMode().equals(Globals.SAVE_MODE_INSERT) ? "sucess.common.insert" : "sucess.common.update" ;
			
			int ckCnt =  uniService.selectIdDoubleCheck("FLOOR_INFO", "tb_floorinfo", "CENTER_CODE = ["+vo.getCenterCode() +"[ and FLOOR_INFO = ["+vo.getFloorInfo() +"[");
			//중복 층수 체크 
			if (ckCnt>0  && !vo.getNowVal().equals(vo.getNewVal()) ) {
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.floor.unicheck"));
				return model;
			}
				  
					
			int ret = floorService.updateFloorInfo(vo);
			if (ret >0){
				model.addObject(Globals.STATUS  , Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			}else {
				throw new Exception();
			}
			
		}catch (Exception e){
			LOGGER.error("floorUpdate error:" + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		LOGGER.debug("model:" + model.toString());
		return model;
	}
	@RequestMapping (value="floorDelete.do")
	public ModelAndView deleteFloorInfoManage(@ModelAttribute("loginVO") LoginVO loginVO
			                                  , @RequestParam("floorSeq") String floorSeq)throws Exception{
		
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
				return model;	
	    }	
		try{
			// 층수 먼저 정리 하기  
			Map<String, Object> vo = floorService.selectFloorInfoDetail(floorSeq);
			centerInfoManageService.updateCenterFloorInfoManage(SmartUtil.checkItemList(SmartUtil.dotToList(vo.get("floor_info_cnt").toString()), vo.get("code_dc").toString() , "")  , vo.get("center_id").toString());
			// 이미지 삭제
			int ret = 	uniService.deleteUniStatement("FLOOR_MAP, FLOOR_MAP1", "tb_floorinfo", "FLOOR_SEQ="+floorSeq+"");		      
		    if (ret > 0 ) {		
		    	  //구역 삭제 
		    	  uniService.deleteUniStatement("PART_MAP1, PART_MAP2", "tb_floorpart", "FLOOR_SEQ="+floorSeq+"");
		    	  model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		    	  model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );		    	 
		    }else {
		      throw new Exception();		    	  
		    }
		}catch (Exception e){
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}
	@RequestMapping (value="partDetail.do")
	public ModelAndView selectPartDetailInfoManage(@ModelAttribute("LoginVO") LoginVO loginVO
	                                               , @RequestParam("partSeq") String partSeq) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
			return model;	
		}
		try {
			model.addObject(Globals.STATUS_REGINFO, partService.selectFloorPartInfoDetail(partSeq));
			//Detail 값 가지고 오기 
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		}catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}

	@NoLogging
	@RequestMapping (value="partUpdate.do")
	public ModelAndView updatePartInfoManage(HttpServletRequest request
			                                   , MultipartRequest mRequest
											   , @ModelAttribute("LoginVO") LoginVO loginVO
											   , @ModelAttribute("FloorPartInfo") FloorPartInfo vo
											   , BindingResult result) throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
		}else {
	    	 HttpSession httpSession = request.getSession(true);
	    	 loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
	    	 vo.setUserId(EgovUserDetailsHelper.getAuthenticatedUser().toString());
	    }
		
		try{
			
			model.addObject(Globals.STATUS_REGINFO , vo);
			String meesage = "";
			
	    	vo.setPartMap1(uploadFile.uploadFileNm(mRequest.getFiles("partMap1"), propertiesService.getString("Globals.filePath")));
			vo.setPartMap2( uploadFile.uploadFileNm(mRequest.getFiles("partMap2"), propertiesService.getString("Globals.filePath")));
			meesage = vo.getMode().equals(Globals.SAVE_MODE_INSERT) ? "sucess.common.insert" : "sucess.common.update" ;
					
			int ret = partService.updateFloorPartInfoManage(vo);
			if (ret >0){
				model.addObject(Globals.STATUS  , Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			}else {
				throw new Exception();
			}
			
		}catch (Exception e){
			LOGGER.error("floorUpdate error:" + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		LOGGER.debug("model:" + model.toString());
		return model;
	}
	
	@RequestMapping (value="partDelete.do")
	public ModelAndView deletePartInfoManage(@ModelAttribute("loginVO") LoginVO loginVO,
			                                   @RequestParam("partSeq") String partSeq)throws Exception{
		
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
				return model;	
	    }	
		try{
			// 이미지 삭제
			int ret = 	uniService.deleteUniStatement("PART_MAP1, PART_MAP2", "tb_floorpart", "PART_SEQ="+partSeq+"");		      
		    if (ret > 0 ) {		
		    	  //구역 삭제 
		    	  model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		    	  model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );		    	 
		    }else {
		      throw new Exception();		    	  
		    }
		}catch (Exception e){
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}
	//좌석 일괄 등록
	@NoLogging
	@RequestMapping (value="floorSeatUpdate.do")
	public ModelAndView updateFloorSeatUpdateInfoManage(@ModelAttribute("LoginVO") LoginVO loginVO
													   , @RequestBody Map<String,Object>  params
													   , HttpServletRequest request
													   , BindingResult result) throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
		}else {
	    	 HttpSession httpSession = request.getSession(true);
	    	 loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
	    	 params.put("userId", EgovUserDetailsHelper.getAuthenticatedUser().toString());
	    }
		try{
			LOGGER.debug("params:" + params.toString());
			int ret = floorService.insertFloorSeatUpdate(params);
			if (ret >0){
				model.addObject(Globals.STATUS  , Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.insert"));
			}else {
				throw new Exception();
			}
			
		}catch (Exception e){
			LOGGER.error("floorUpdate error:" + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		LOGGER.debug("model:" + model.toString());
		return model;
	}
	@RequestMapping (value="seatCount.do")
	public ModelAndView selectSeatCountInfoManage(@ModelAttribute("LoginVO") LoginVO loginVO
													   , @RequestBody Map<String,Object>  params
													   , HttpServletRequest request
													   , BindingResult result) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try{
			String is_condition = params.get("partSeq") != "" ? "FLOOR_SEQ = " + params.get("floorSeq") + " AND PART_SEQ = " + params.get("partSeq") + "" : "FLOOR_SEQ = " + params.get("floorSeq")+ "";
			String is_Field = "";
			String is_Table = "";
			LOGGER.debug("type:" + params.get("type").toString());
			switch (params.get("type").toString()) {
				case "S":
					is_Field = "SEAT_ID";
					is_Table = "tb_seatinfo";
					break;
				case "M" :
					is_Field = "MEETING_ID";
					is_Table = "tb_meeting_room"; 
					break;
				case "D":
					is_Field = "MEETING_ID";
					is_Table = "tb_meeting_room"; 
					break;
				default :
					is_Field = "SEAT_ID";
					is_Table = "tb_seatinfo";
			}
			LOGGER.debug("type:" + is_Field + ":" + is_Table);
			
			
			int ret = uniService.selectIdDoubleCheck(is_Field, is_Table, is_condition);
			
			model.addObject(Globals.STATUS  , Globals.STATUS_SUCCESS);
			model.addObject(Globals.JSON_RETURN_RESULT, ret);
			
		}catch (Exception e){
			LOGGER.error("floorUpdate error:" + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}	
		LOGGER.debug("model:" + model.toString());
		return model;
		
	}
	
	 *  지점 층 조회
	 *  
	 
	@RequestMapping (value="floorComboInfo.do")
	public ModelAndView selectFloorComboInfoManage(@ModelAttribute("LoginVO") LoginVO loginVO
												   , @RequestParam("centerCode") String centerCode
												   , HttpServletRequest request
												   , BindingResult result) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try{
			model.addObject(Globals.STATUS  , Globals.STATUS_SUCCESS);
			model.addObject(Globals.JSON_RETURN_RESULTLISR, floorService.selectFloorInfoComboList(centerCode));
		}catch (Exception e){
			LOGGER.error("floorUpdate error:" + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}	
		LOGGER.debug("model:" + model.toString());
		return model;
		
	}
	*/
}
