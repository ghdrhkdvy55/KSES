package com.kses.backoffice.bld.center.web;

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
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

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
	@RequestMapping(value="centerList.do", method = RequestMethod.GET)
	public ModelAndView viewCenterList(@ModelAttribute("searchVO") CenterInfo searchVO) throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/bld/centerList"); 
		List<Map<String, Object>> centerInfoComboList = centerInfoManageService.selectCenterInfoComboList();
		model.addObject("centerInfoComboList", centerInfoComboList);
		model.addObject("floorInfo", codeDetailService.selectCmmnDetailCombo("CENTER_FLOOR"));
		model.addObject(Globals.STATUS_REGINFO , searchVO);
		return model;	
	}

	/**
	 * 지점 상세 팝업 화면
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="centerInfoPopup.do", method = RequestMethod.GET)
	public ModelAndView popupCenterInfo() throws Exception {
		ModelMap model = new ModelMap();
		model.addAttribute("centerResvAbleDay", codeDetailService.selectCmmnDetailCombo("CENTER_RESV_ABLE_DAY"));
		model.addAttribute("floorInfo", codeDetailService.selectCmmnDetailCombo("CENTER_FLOOR"));
		return new ModelAndView("/backoffice/bld/sub/centerInfo", model);
	}

	/**
	 * 지점 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="centerListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectCenterAjaxInfo(@RequestBody Map<String,Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		int pageUnit = searchVO.get("pageUnit") == null
				? propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));
		
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
		int totCnt = list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		paginationInfo.setTotalRecordCount(totCnt);
		
		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		
		return model;
	}

	/**
	 * 지점 정보 상세
 	 * @param centerCd
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "centerInfoDetail.do", method = RequestMethod.GET)
	public ModelAndView selectCenterInfoDetail(@RequestParam("centerCd") String centerCd) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		model.addObject(Globals.JSON_RETURN_RESULT, centerInfoManageService.selectCenterInfoDetail(centerCd));
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

		return model;
	}

	/**
	 * 지점 정보 저장
	 * @param centerInfo
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping (value = "centerInfoUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateCenterInfo(@ModelAttribute CenterInfo centerInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		centerInfo.setFrstRegterId(userId);
		centerInfo.setLastUpdusrId(userId);
		centerInfo.setCenterImg(uploadFile.uploadFileNm(centerInfo.getCenterImgFile(), propertiesService.getString("Globals.filePath")));
		centerInfo.setCenterMap(uploadFile.uploadFileNm(centerInfo.getCenterMapFile(), propertiesService.getString("Globals.filePath")));

		int ret = 0;
		switch (centerInfo.getMode()) {
			case Globals.SAVE_MODE_INSERT:
				ret = centerInfoManageService.insertCenterInfoManage(centerInfo);
				break;
			case Globals.SAVE_MODE_UPDATE:
				ret = centerInfoManageService.updateCenterInfoManage(centerInfo);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
		}
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(StringUtils.equals(centerInfo.getMode(), Globals.SAVE_MODE_INSERT)
			? "sucess.common.insert" : "sucess.common.update"));

		return model;
	}

	/**
	 * 지점 정보 삭제
	 * @param centerInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "centerInfoDelete.do", method = RequestMethod.POST)
	public ModelAndView deleteCenterInfo(@RequestBody CenterInfo centerInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		int ret = 0;
		try {
			ret = uniService.selectIdDoubleCheck("*", "TSER_RESV_INFO_I", "CENTER_CD=[" + centerInfo.getCenterCd() + "[");
			if (ret > 0) {
				throw new Exception("해당 지점의 예약 정보가 있어 삭제할 수 없습니다.");
			}

			ret = uniService.selectIdDoubleCheck("*", "TSEH_ADMIN_INFO_M", "CENTER_CD=[" + centerInfo.getCenterCd() + "[");
			if (ret > 0) {
				throw new Exception("해당 지점의 관리자 정보가 있어 삭제할 수 없습니다.");
			}

			ret = uniService.selectIdDoubleCheck("*", "TSEB_CENTER_PART_CLASS_D", "CENTER_CD=[" + centerInfo.getCenterCd() + "[");
			if (ret > 0) {
				throw new Exception("해당 지점의 구역좌석등급 정보가 있어 삭제할 수 없습니다.");
			}

			ret = uniService.selectIdDoubleCheck("*", "TSEB_PART_INFO_D", "CENTER_CD=[" + centerInfo.getCenterCd() + "[");
			if (ret > 0) {
				throw new Exception("해당 지점의 층구역 정보가 있어 삭제할 수 없습니다.");
			}

			ret = uniService.selectIdDoubleCheck("*", "TSEB_SEAT_INFO_D", "CENTER_CD=[" + centerInfo.getCenterCd() + "[");
			if (ret > 0) {
				throw new Exception("해당 지점의 좌석 정보가 있어 삭제할 수 없습니다.");
			}

			// 휴일 정보 삭제
			uniService.deleteUniStatement("", "TSEB_CENTERHOLY_INFO_I", "CENTER_CD=[" + centerInfo.getCenterCd() + "[");

			// 사전예약 입장시간 정보 삭제
			uniService.deleteUniStatement("", "TSEB_RESV_ADMSTM_D", "CENTER_CD=[" + centerInfo.getCenterCd() + "[");

			// 자동취소 시간 정보 삭제
			uniService.deleteUniStatement("", "TSEB_NOSHOW_INFO_M", "CENTER_CD=[" + centerInfo.getCenterCd() + "[");

			// 지점별 현금영수증(요일) 삭제
			uniService.deleteUniStatement("", "TESR_BILLDAY_INFO_I", "CENTER_CD=[" + centerInfo.getCenterCd() + "[");

			// 무인발권기 정보 삭제
			uniService.deleteUniStatement("", "TSEC_TICKET_MCHN_M", "CENTER_CD=[" + centerInfo.getCenterCd() + "[");

			// 층 정보 삭제
			uniService.deleteUniStatement("FLOOR_MAP1, FLOOR_MAP2", "TSEB_FLOOR_INFO_M", "CENTER_CD=[" + centerInfo.getCenterCd() + "[");
			
			// 지점 정보 삭제
			uniService.deleteUniStatement("CENTER_IMG", "TSEB_CENTER_INFO_M", "CENTER_CD=[" + centerInfo.getCenterCd() + "[");
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));
		} catch (Exception ex) {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, ex.getMessage());
		}

		return model;
	}
	
//	@RequestMapping (value="centerInfoDelete.do")
//	public ModelAndView deleteCenterInfoManage(	@ModelAttribute("loginVO") LoginVO loginVO,
//			                                   	@RequestParam("centerList") String centerList,
//			                                   	HttpServletRequest request) throws Exception {
//		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
//	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
//	    List<String> centerLists =  SmartUtil.dotToList(centerList);
//	    if(!isAuthenticated) {
//	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
//	    	model.setViewName("/backoffice/login");
//	    	return model;
//	    }
//	    try {
//	    	for(String centerCd : centerLists) {
//	    		//이미지 삭제 먼저 하기
//		    	int ret = uniService.deleteUniStatement("CENTER_IMG", "TSEB_CENTER_INFO_M", "CENTER_CD = [" + centerCd + "[");
//
//		    	if (ret > 0 ) {
//		    		//층 삭제
//		    		uniService.deleteUniStatement("FLOOR_MAP1, FLOOR_MAP2", "TSEB_FLOOR_INFO_M", "CENTER_CD = [" + centerCd + "[");
//
//		    		//구역 삭제
//		    		uniService.deleteUniStatement("PART_MAP1, PART_MAP2", "TSEB_PART_INFO_D", "CENTER_CD = [" + centerCd + "[");
//
//		    		//사전예약 입장시간 정보 삭제
//		    		uniService.deleteUniStatement("", "TSEB_RESV_ADMSTM_D", "CENTER_CD = [" + centerCd + "[");
//
//		    		//자동취소 시간 정보 삭제
//		    		uniService.deleteUniStatement("", "TSEB_NOSHOW_INFO_M", "CENTER_CD = [" + centerCd + "[");
//
//		    		//휴일 정보 삭제
//		    		uniService.deleteUniStatement("", "TSEC_HOLY_INFO_M", "CENTER_ID=[" + centerCd + "[");
//		    	} else {
//		    		throw new Exception();
//		    	}
//	    	}
//	    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );
//		} catch (Exception e) {
//			log.info(e.toString());
//			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
//			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
//		}
//		return model;
//	}
	
	//좌석 일괄 등록
	@NoLogging
	@RequestMapping (value="floorSeatUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateFloorSeatUpdateInfoManage(@RequestBody Map<String,Object> params) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		params.put("frstRegterId",userId);
		params.put("lastUpdusrId",userId);
		
		floorService.insertFloorSeatUpdate(params);
	
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.insert"));

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
	
	//combo box 신규 추가 
	@RequestMapping(value="centerCombo.do")
	public ModelAndView selectCenterComboInfoList() throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		
		List<Map<String, Object>> centerInfoComboList = centerInfoManageService.selectCenterInfoComboList();

		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, centerInfoComboList);
		
		return model;	
	}
}