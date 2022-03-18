package com.kses.backoffice.bld.season.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import egovframework.com.cmm.util.EgovUserDetailsHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
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
import com.google.gson.reflect.TypeToken;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorInfoManageService;
import com.kses.backoffice.bld.floor.service.FloorPartInfoManageService;
import com.kses.backoffice.bld.season.service.SeasonInfoManageService;
import com.kses.backoffice.bld.season.service.SeasonSeatInfoManageService;
import com.kses.backoffice.bld.season.vo.SeasonInfo;
import com.kses.backoffice.bld.season.vo.SeasonSeatInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/bld")
public class SeasonInfoManageController {
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;
    
	@Autowired
	private CenterInfoManageService centerInfoManageService;
	
	@Autowired
	private SeasonInfoManageService seasonService; 
	
	@Autowired
	private FloorInfoManageService floorService;
	
	@Autowired
	private FloorPartInfoManageService partService;
	
	@Autowired
	private SeasonSeatInfoManageService seasonSeatService;
	
	/**
	 * 시즌관리 화면
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="seasonList.do", method = RequestMethod.GET)
	public ModelAndView viewSeasonList() throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/bld/seasonList");
		List<Map<String, Object>> centerInfoComboList = centerInfoManageService.selectCenterInfoComboList();
		model.addObject("centerCombo", centerInfoComboList);
		return model;
	}

	/**
	 * 시즌 상세 팝업 화면
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="seasonInfoPopup.do", method = RequestMethod.GET)
	public ModelAndView popupSeasonInfo() throws Exception {
		ModelMap model = new ModelMap();
		return new ModelAndView("/backoffice/bld/sub/seasonInfo", model);
	}

	/**
	 * 시즌관리 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="seasonListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectSeasonAjaxInfo(@RequestBody Map<String,Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1").toString()));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		searchVO.put("authorCd", loginVO.getAuthorCd());
		searchVO.put("centerCd", loginVO.getCenterCd());

		List<Map<String, Object>> list = seasonService.selectSeasonInfoList(searchVO);
		int totCnt = list.size() > 0 ? Integer.valueOf(list.get(0).get("total_record_count").toString()) : 0;
		paginationInfo.setTotalRecordCount(totCnt);

		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

		return model;
	}

	@RequestMapping (value="seasonInfoDetail.do")
	public ModelAndView selectSeasonInfoDetail(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestParam("seasonCd") String seasonCd , 
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
		model.addObject(Globals.STATUS_REGINFO, seasonService.selectSeasonInfoDetail(seasonCd));	     	
		return model;
	}
	
	@RequestMapping (value="seasonCenterLst.do")
	public ModelAndView selectSeasonCenterListInfo(@ModelAttribute("loginVO") LoginVO loginVO, 
												   @RequestParam("seasonCd") String seasonCd , 
												   HttpServletRequest request, 
												   BindingResult bindingResult) throws Exception {	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		try {
			
			
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;	
		    }	
			List<Map<String, Object>> list = seasonService.selectSeasonCenterInfoList(seasonCd);
			if (list.size() > 0) {
				String centerCd = list.get(0).get("center_cd").toString();
				//�� 
				Map<String, Object> search = new HashMap<String,Object>();
				search.put("centerCd", centerCd);
				search.put("firstIndex", "0");
				search.put("recordCountPerPage", "100");
				List<Map<String, Object>> floorList = floorService.selectFloorInfoList(search);
				
				
				model.addObject("floorlist", floorList);
				if(floorList.get(0).get("floor_part_dvsn").toString().equals("FLOOR_PART_1"))
					model.addObject("partlist", partService.selectFloorPartInfoManageCombo(floorList.get(0).get("floor_cd").toString()));
				
			}
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, list);	
		}catch(Exception e) {
			log.debug("error:---------------------------------------");
			StackTraceElement[] ste = e.getStackTrace();
			log.error(e.toString() + ":" + ste[0].getLineNumber());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
	         	
		return model;
	}
	
	@RequestMapping (value="seasonSeatListAjax.do")
	public ModelAndView seasonSeatListAjax(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestBody Map<String, Object> searchVO,
												HttpServletRequest request, 
												BindingResult bindingResult) throws Exception {	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;	
		    }	
			searchVO.put("firstIndex", 0);
			searchVO.put("recordCountPerPage", 3000);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			List<Map<String, Object>> seasonList = seasonSeatService.selectSeasonSeatInfoList(searchVO);
			int totCnt = seasonList.size() > 0 ?  Integer.valueOf( seasonList.get(0).get("total_record_count").toString()) : 0;
			model.addObject(Globals.JSON_RETURN_RESULTLISR, seasonList);
			model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		    
		    if (searchVO.get("searchFloorCd") != null ) {
		    	log.info(searchVO.get("searchPartCd").toString());
		    	System.out.println((String)searchVO.get("searchPartCd") == "0");
		    	System.out.println("0".equals((String)searchVO.get("searchPartCd")));
		    	Map<String, Object> mapInfo = "0".equals((String)searchVO.get("searchPartCd")) ? floorService.selectFloorInfoDetail(searchVO.get("searchFloorCd").toString()) : partService.selectFloorPartInfoDetail(searchVO.get("searchPartCd").toString());
		    	model.addObject("seatMapInfo", mapInfo);
		    }
		    
		}catch(Exception e) {
			log.debug("error:---------------------------------------");
			StackTraceElement[] ste = e.getStackTrace();
			log.error(e.toString() + ":" + ste[0].getLineNumber());
			
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
	       	
		return model;
	}	
	
	
	@RequestMapping(value="seasonGuiUpdate.do", method=RequestMethod.POST)
	public ModelAndView updateSeatGuiPosition (	@RequestBody Map<String, Object> params, 
												HttpServletRequest request, 
												BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try {
			
			Gson gson = new GsonBuilder().create();
			List<SeasonSeatInfo> seatInfos = gson.fromJson(params.get("data").toString(), new TypeToken<List<SeasonSeatInfo>>(){}.getType());
			int result = seasonSeatService.updateSeasonSeatPositionInfo(seatInfos);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
            model.addObject("resutlCnt", result);
		}catch(Exception e) {
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.update"));
		}
		return model;
		
	}
	@RequestMapping (value="seasonInfoUpdate.do")
	public ModelAndView updateSeasonInfo(@ModelAttribute("LoginVO") LoginVO loginVO, 
			                             @RequestBody SeasonInfo vo, 
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
			
	    	
			meesage = vo.getMode().equals(Globals.SAVE_MODE_INSERT) ? "sucess.common.insert" : "sucess.common.update";
			
			loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			vo.setUserId(loginVO.getAdminId());
			int ret = seasonService.updateSeasonInfo(vo);
			log.debug("============================================================:");
			log.debug("ret:" +ret);
			if (ret > 0) {
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));		
			}else if (ret == -1) {
				meesage = "fail.common.overlap";
				model.addObject(Globals.STATUS, Globals.STATUS_OVERLAPFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));	
			}else {
				throw new Exception();
			}
		} catch (Exception e){
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		return model;
	}
	
	@RequestMapping (value="seasonInfoDelete.do")
	public ModelAndView deleteSeasonInfoManage(	@ModelAttribute("loginVO") LoginVO loginVO,
												@RequestBody Map<String, Object> info  ) throws Exception {
		
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }	
	    
	    try {
	    	seasonService.deleteSeasonInfo(info.get("seasonCd").toString());
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );
		} catch (Exception e) {
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}
	
}