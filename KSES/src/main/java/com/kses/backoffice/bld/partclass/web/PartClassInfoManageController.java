package com.kses.backoffice.bld.partclass.web;
  
import java.util.List; import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute; 
import org.springframework.web.bind.annotation.RequestBody; 
import org.springframework.web.bind.annotation.RequestMapping; 
import org.springframework.web.bind.annotation.RequestMethod; 
import org.springframework.web.bind.annotation.RestController; 
import org.springframework.web.multipart.MultipartRequest; 
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService; 
import com.kses.backoffice.bld.partclass.service.PartClassInfoManageService; 
import com.kses.backoffice.bld.partclass.vo.PartClassInfo; 
import com.kses.backoffice.util.SmartUtil; 
import com.kses.backoffice.util.service.UniSelectInfoManageService;
import com.kses.backoffice.util.service.fileService;

import egovframework.com.cmm.EgovMessageSource; 
import
egovframework.com.cmm.LoginVO; 
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper; 
import egovframework.rte.fdl.cmmn.exception.EgovBizException; 
import egovframework.rte.fdl.property.EgovPropertyService; 
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController

@RequestMapping("/backoffice/bld") public class PartClassInfoManageController {
  
	//파일 업로드
    @Autowired
	private fileService uploadFile;
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
	protected EgovPropertyService propertiesService;
	
	@Autowired
	private PartClassInfoManageService partClassService;
	
	@Autowired
	private CenterInfoManageService centerInfoManageService;
	
	@Autowired
	private EgovCcmCmmnDetailCodeManageService codeDetailService;
	
	@Autowired
	private UniSelectInfoManageService uniService;
  
  
	/**
	 * 구역 관리 화면
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "partClassList.do", method = RequestMethod.GET)
		public ModelAndView viewPartClassList() throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/bld/partClassList");
		
		List<Map<String, Object>> centerInfoComboList =	centerInfoManageService.selectCenterInfoComboList();
		
		model.addObject("centerInfo", centerInfoComboList);
		model.addObject("partClassInfo", codeDetailService.selectCmmnDetailCombo("SEAT_CLASS"));
		model.setViewName("/backoffice/bld/partClassList"); 
		return model; 
	}
  
    /**
	 * 구역 관리 목록 조회
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value="partClassListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectAuthInfoListAjax(@RequestBody Map<String, Object>	searchVO) throws Exception { 
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
	
		int pageUnit = searchVO.get("pageUnit") == null ?
		propertiesService.getInt("pageUnit") : Integer.valueOf((String)
		searchVO.get("pageUnit"));
		
		searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		
		
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(
		Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"),"1")));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		
		List<Map<String, Object>> list = partClassService.selectPartClassList(searchVO);
		
		int totCnt = list.size() > 0 ? Integer.valueOf(list.get(0).get("total_record_count").toString()) : 0;
		
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		
		return model; 
	}
  
	/**
	 * 구역 등급 정보 등록 및 수정
	 * @param mRequest
	 * @param partClassInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="partClassUpdate.do", method = RequestMethod.POST)
	public ModelAndView updatePartClassInfo(MultipartRequest mRequest,
											@ModelAttribute PartClassInfo partClassInfo,
											BindingResult bindingResult) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		partClassInfo.setLastUpdusrId(userId);
		partClassInfo.setFrstRegterId(userId);
		partClassInfo.setPartIcon(uploadFile.uploadFileNm(mRequest.getFiles("partIcon"), propertiesService.getString("Globals.filePath")));
		
		int ret = 0; 

		switch (partClassInfo.getMode()) {
		case Globals.SAVE_MODE_INSERT:
			ret = (uniService.selectIdDoubleCheck("PART_CLASS", "TSEB_CENTER_PART_CLASS_D",	"PART_CLASS = ["+ partClassInfo.getPartClass() + "[ AND CENTER_CD = ["+	partClassInfo.getCenterCd() + "[" ) > 0) ? -1 :	partClassService.insertPartClassInfo(partClassInfo);
			break;
		case Globals.SAVE_MODE_UPDATE:
			ret = partClassService.updatePartClassInfo(partClassInfo);
			break;
		default:
			throw new EgovBizException("잘못된 호출입니다.");
		}
		
		String messageKey = ""; 
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS); 
			messageKey = StringUtils.equals(partClassInfo.getMode(), "Ins") ? "sucess.common.insert" : "sucess.common.update"; 
		} else if (ret == -1) {
			model.addObject(Globals.STATUS,	Globals.STATUS_OVERLAPFAIL);
			messageKey = "fail.common.overlap";
		} else {
			model.addObject(Globals.STATUS,	Globals.STATUS_FAIL);
			messageKey = StringUtils.equals(partClassInfo.getMode(), "Ins") ? "fail.common.insert" : "fail.common.update"; 
		} 
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));
		
		return model; 
	}
  
	/**
	 * 구역 정보 삭제
	 * @param partClassInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "partClassDelete.do", method = RequestMethod.POST)
	public ModelAndView deletePartClassInfo(@RequestBody PartClassInfo partClassInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
	
		partClassService.deletePartClassInfo(partClassInfo.getPartClassSeq());
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE,	egovMessageSource.getMessage("success.common.delete"));
	  
		return model; 
	}
}
		 