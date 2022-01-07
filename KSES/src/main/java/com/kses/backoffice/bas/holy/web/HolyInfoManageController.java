package com.kses.backoffice.bas.holy.web;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.kses.backoffice.bas.holy.service.HolyInfoService;
import com.kses.backoffice.bas.holy.vo.HolyInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/bas")
public class HolyInfoManageController {
	
    @Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private HolyInfoService holyService;
	
	@Autowired
	private UniSelectInfoManageService uniService;
	
	@Autowired
    ServletContext servletContext;
	
	/**
	 * 휴일관리 화면
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="holyList.do", method = RequestMethod.GET)
	public ModelAndView selectHolyInfoList() throws Exception {
		return new ModelAndView("/backoffice/bas/holyList");
	}
	
	/**
	 * 휴일관리 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="holyListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectHolyInfoListAjax(@RequestBody Map<String, Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
			
		int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
		  
	    searchVO.put("pageSize", propertiesService.getInt("pageSize"));
	  
	    log.info("pageUnit:" + pageUnit);
	                
   	    PaginationInfo paginationInfo = new PaginationInfo();
	    paginationInfo.setCurrentPageNo( Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
	    paginationInfo.setRecordCountPerPage(pageUnit);
	    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

	    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
	    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
	    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
	    			  
		List<Map<String, Object>> list = holyService.selectHolyInfoList(searchVO);
        int totCnt =  list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) :0;
   
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
	    model.addObject(Globals.PAGE_TOTALCNT, totCnt);
	    paginationInfo.setTotalRecordCount(totCnt);
	    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
	    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
	    
		return model;
	}
	
	/**
	 * 휴일 적용 센터 목록 조회
	 * @param holyDt
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="holyCenterListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectHolyCenterListAjax(@RequestBody Map<String, Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
		
		int pageIndex = Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1"));
		int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
		
		PaginationInfo paginationInfo = new PaginationInfo();
	    paginationInfo.setCurrentPageNo(pageIndex);
	    paginationInfo.setRecordCountPerPage(pageUnit);
	    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
	    
	    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
	    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
	    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
	    
	    List<Map<String, Object>> list = holyService.selectHolyCenterList(searchVO);
	    int totCnt =  list.size() > 0 
	    		? Integer.valueOf(list.get(0).get("total_record_count").toString()) 
	    		: 0;
	    paginationInfo.setTotalRecordCount(totCnt);
	    
	    model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
	    model.addObject(Globals.PAGE_TOTALCNT, totCnt);
	    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
	    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
	    
		return model;
	}
	
	/**
	 * 휴일일자 중복 체크
	 * @param authorCode
	 * @return
	 * @throws Exception
	 */
	@NoLogging
    @RequestMapping (value="holyDtCheck.do", method = RequestMethod.GET)
    public ModelAndView selectIdCheck(@RequestParam("holyDt") String holyDt) throws Exception {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
    	
    	int ret = uniService.selectIdDoubleCheck("HOLY_DT", "TSEC_HOLY_INFO_M", "HOLY_DT = ["+ holyDt + "[");
    	if (ret == 0) {
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("common.codeOk.msg"));
    	}
    	else {
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("common.codeFail.msg"));
    	}
    	
    	return model;
    }
	
	/**
	 * 휴일정보 저장
	 * @param holyInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="holyUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateHolyInfoManage(@RequestBody HolyInfo holyInfo) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		holyInfo.setFrstRegisterId(userId);
		holyInfo.setLastUpdusrId(userId);
		
		int ret = 0;
		switch (holyInfo.getMode()) {
			case "Ins":
				ret = holyService.insertHolyInfo(holyInfo);
				break;
			case "Edt":
				ret = holyService.updateHolyInfo(holyInfo);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
		}
		
		String messageKey = "";
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			messageKey = StringUtils.equals(holyInfo.getMode(), "Ins") ? "sucess.common.insert" : "sucess.common.update";
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			messageKey = StringUtils.equals(holyInfo.getMode(), "Ins") ? "fail.common.insert" : "fail.common.update";
		}
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));
		
		return model;
	}
	
	/**
	 * 휴일정보 삭제
	 * @param holyInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="holyDelete.do", method = RequestMethod.POST)
	public ModelAndView deleteHolyInfoManage(@RequestBody HolyInfo holyInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    
		int ret =  holyService.deleteHolyInfo(SmartUtil.dotToList(holyInfo.getHolySeq()));
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
		}
		
		return model;
	}
	
	/**
	 * 휴일정보 엑셀 업로드
	 * @param params
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="holyInfoExcelUpload.do", method = RequestMethod.POST)
	public ModelAndView selectHolyInfoExcelUpload(@RequestBody Map<String, Object> params) throws Exception{	
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    
		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		Gson gson = new GsonBuilder().create();
		List<HolyInfo> holyInfos = gson.fromJson(params.get("data").toString(), new TypeToken<List<HolyInfo>>(){}.getType());
		holyInfos.forEach(holyInfo -> {
			holyInfo.setFrstRegisterId(userId);
			holyInfo.setLastUpdusrId(userId);
		});
		
		boolean holyInsert = holyService.insertExcelHoly(holyInfos);
		log.info("holyInsert: "+ holyInsert);
		if (holyInsert) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.insert"));
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));
		}
		
	    return model;
	}
	
	/**
	 * 휴일정보 전체 지점 등록
	 * @param holyInfoList
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="holyInfoCenterApply.do", method = RequestMethod.POST)
	public ModelAndView updateHolyInfoCenterApply(@RequestBody List<HolyInfo> holyInfoList) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		
		holyService.holyInfoCenterApply(holyInfoList);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update") );
		
		return model;
	}
	
	/**
	 * 샘플 엑셀 파일 다운로드
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping (value="holyInfoUploadSampleDownload.do", method = RequestMethod.GET)
	public void holyInfoUploadSampleDownload(HttpServletResponse response) throws Exception {
		String fileName = "holyinfo_upload.xlsx";
		String sampleFolder = servletContext.getRealPath("/WEB-INF/sample/");
		Path file = Paths.get(sampleFolder, fileName);
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		response.addHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename="+ fileName);
		Files.copy(file, response.getOutputStream());
		response.getOutputStream().flush();
	}
	
	/** 사용하지 않음
	@RequestMapping (value="holyInfoDetail.do")
	public ModelAndView selectHolyInfoDetail(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestParam("holySeq") String holySeq, 
												HttpServletRequest request, 
												BindingResult bindingResult) throws Exception{	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }
	    
	    try {
	    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, holyService.selectHolyInfoDetail(holySeq));
	    } catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
	    }
	    return model;
	}
	*/
}