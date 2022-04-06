package com.kses.backoffice.bld.center.web;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.kses.backoffice.bas.holy.vo.HolyInfo;
import com.kses.backoffice.bld.center.service.CenterHolyInfoManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.center.vo.CenterHolyInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/backoffice/bld")
public class CenterHolyInfoManageController {
    
    @Autowired
    EgovMessageSource egovMessageSource;
    
    @Autowired
    CenterHolyInfoManageService centerHolyInfoService;
    
    @Autowired
    CenterInfoManageService centerInfoService;
	
	@Autowired
	private CenterInfoManageService centerInfoManageService;
	
	@Autowired
	private UniSelectInfoManageService uniService;

	@Autowired
	protected EgovPropertyService propertiesService;

	/**
	 * 지점 휴일 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "centerHolyInfoListAjax.do", method = RequestMethod.POST)
    public ModelAndView selectCenterHolyInfo(@RequestBody Map<String,Object> searchVO) throws Exception {
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

		List<Map<String, Object>> centerHolyInfoList = centerHolyInfoService.selectCenterHolyInfoList(searchVO);
		int totCnt = centerHolyInfoList.size() > 0 ?  Integer.valueOf(centerHolyInfoList.get(0).get("total_record_count").toString()) : 0;
		paginationInfo.setTotalRecordCount(totCnt);

		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, centerHolyInfoList);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

    	return model;
    }

	/**
	 * 지점 복수 휴일 수정
	 * @param centerHolyInfoList
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping (value = "centerHolyInfoListUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateCenterHolyInfoList(@RequestBody List<CenterHolyInfo> centerHolyInfoList) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		centerHolyInfoList.stream().forEach(x -> x.setLastUpdusrId(userId));
		centerHolyInfoService.updateCenterHolyInfoList(centerHolyInfoList);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update"));

		return model;
	}

	/**
	 * 지점 단건 휴일 업데이트
	 * @param centerHolyInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="centerHolyInfoUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateCenterHolyInfo(@RequestBody CenterHolyInfo centerHolyInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		String meesage = "";
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		try {
			Map<String, Object> centerUpdateSelect = centerHolyInfoService.centerUpdateSelect(centerHolyInfo.getCenterHolySeq());

			int ret;
			if (centerUpdateSelect.get("holy_dt").equals(centerHolyInfo.getHolyDt()) && centerUpdateSelect.get("center_holy_seq").toString().equals(centerHolyInfo.getCenterHolySeq())) {
				ret = centerHolyInfoService.updateCenterHolyInfo(centerHolyInfo);
			} else {
				ret = (uniService.selectIdDoubleCheck("HOLY_DT", "TSEB_CENTERHOLY_INFO_I", "HOLY_DT = ["+ centerHolyInfo.getHolyDt() + "[ AND CENTER_CD = ["+ centerHolyInfo.getCenterCd() + "[" ) > 0) ? -1 : centerHolyInfoService.updateCenterHolyInfo(centerHolyInfo);
			}

			meesage = (centerHolyInfo.getMode().equals("Edt")) ? "sucess.common.update" : "sucess.common.insert";

			if (ret > 0) {
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			} else if (ret == -1) {
				meesage = "fail.common.overlap";
				model.addObject(Globals.STATUS, Globals.STATUS_OVERLAPFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			} else {
				throw new Exception();
			}
		} catch (Exception e){
			meesage = (centerHolyInfo.getMode().equals(Globals.SAVE_MODE_INSERT)) ? "fail.common.insert" : "fail.common.update";
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
		}
		return model;
	}
	
	@RequestMapping (value="centerHolyInfoDelete.do")
	public ModelAndView deleteCenterHolyInfoManage(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestParam("centerHolySeq") int centerHolySeq, 
												HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }	
	    try {
	    	centerHolyInfoService.deleteCenterHolyInfo(centerHolySeq);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );		    	 
		} catch (Exception e) {
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}
	
	@RequestMapping("centerHolyUpdateSelect.do")
    public ModelAndView centerHolyUpdateSelect(	@ModelAttribute("loginVO") LoginVO loginVO,
    											@RequestParam("centerHolySeq") String centerHolySeq,
    											HttpServletRequest request) {
    	
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
			return model;	
		} else {
			HttpSession httpSession = request.getSession(true);
			loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
		}
    	
    	try {
    		
    		Map<String, Object> centerUpdateSelect = centerHolyInfoService.centerUpdateSelect(centerHolySeq);
    		
    		model.addObject(Globals.STATUS_REGINFO, centerUpdateSelect);
    		//신규 추가 
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.select"));
    	} catch (Exception e) {
    		log.info("selectCenterHolyInfo ERROR : " + e);
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
    		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
    	
    	return model;
    }
	
	/**
	 * 지점 휴일 정보 복사
	 * @param params
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "centerHolyInfoCopy.do", method = RequestMethod.POST)
	public ModelAndView updateCopyCenterHolyInfo(@RequestBody CenterHolyInfo centerHolyInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
    	String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
    	centerHolyInfo.setLastUpdusrId(userId);
		centerHolyInfoService.copyCenterHolyInfo(centerHolyInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update"));

		return model;
	}
	
	@RequestMapping (value="centerHolyInfoExcelUpload.do")
	public ModelAndView selectHolyInfoExcelUpload(@ModelAttribute("loginVO") LoginVO loginVO, 
			                                      @RequestBody Map<String, Object> params) throws Exception{	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

	    	
		loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		String lastUpdusrId = loginVO.getAdminId();
		
		Gson gson = new GsonBuilder().create();
		List<CenterHolyInfo> centerHolyInfos = gson.fromJson(params.get("data").toString(), new TypeToken<List<CenterHolyInfo>>(){}.getType());
		//좌석/ 회의실 정리 하기 
		centerHolyInfos.forEach(CenterHolyInfo -> CenterHolyInfo.setLastUpdusrId(lastUpdusrId));
		centerHolyInfos.forEach(CenterHolyInfo -> CenterHolyInfo.setCenterCd(params.get("centerCd").toString()));
		
		boolean centerHolyInsert = centerHolyInfoService.insertExcelCenterHoly(centerHolyInfos);
		if (centerHolyInsert == true) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.insert"));
		}else {
			throw new Exception();
		}
	    	
	    return model;
	}
	/**
	 * 휴일정보 엑셀 업로드
	 * @param params
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="centerHolyInfoExcelUpload.do", method = RequestMethod.POST)
	public ModelAndView selectHolyInfoExcelUpload(@RequestBody Map<String, Object> params) throws Exception{	
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    
		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		Gson gson = new GsonBuilder().create();
		List<CenterHolyInfo> centerHolyInfos = gson.fromJson(params.get("data").toString(), new TypeToken<List<CenterHolyInfo>>(){}.getType());
		centerHolyInfos.forEach(CenterHolyInfo -> {
			CenterHolyInfo.setFrstRegterId(userId);
			CenterHolyInfo.setLastUpdusrId(userId);
			CenterHolyInfo.setCenterCd(params.get("centerCd").toString());
		});
		
		boolean centerHolyInsert = centerHolyInfoService.insertExcelCenterHoly(centerHolyInfos);
		log.info("centerHolyInsert: "+ centerHolyInsert);
		if (centerHolyInsert) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.insert"));
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));
		}
		
	    return model;
	}
	
}