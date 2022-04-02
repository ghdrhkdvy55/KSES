package com.kses.backoffice.bld.seat.web;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.seat.service.SeatInfoManageService;
import com.kses.backoffice.bld.seat.vo.SeatInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;
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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import java.util.ArrayList;
import java.util.Arrays;
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
	
	/**
	 * 좌석 정보 상세 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="seatInfoDetail.do", method = RequestMethod.POST)
	public ModelAndView selectSeatInfoDetail(@RequestBody SeatInfo vo) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
	    model.addObject(Globals.STATUS_REGINFO, seatService.selectSeatInfoDetail(vo.getSeatCd()));
	    return model;
	}
	
	/**
	 * 좌석 정보 저장
	 * @param seatInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="seatInfoUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateSeatInfo(@RequestBody SeatInfo seatInfo) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		seatInfo.setFrstRegterId(userId);
		seatInfo.setLastUpdusrId(userId);
		
		int ret = 0;
		switch (seatInfo.getMode()) {
			case Globals.SAVE_MODE_INSERT:
				seatService.insertSeatInfo(seatInfo);
				ret = 1;
				break;
			case Globals.SAVE_MODE_UPDATE:
				ret = seatService.updateSeatInfo(seatInfo);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
		}
		
		String messageKey = "";
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			messageKey = StringUtils.equals(seatInfo.getMode(), Globals.SAVE_MODE_INSERT) 
					? "sucess.common.insert" : "sucess.common.update";
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			messageKey = StringUtils.equals(seatInfo.getMode(), Globals.SAVE_MODE_INSERT) 
					? "fail.common.insert" : "fail.common.update";
		}
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));
		
		return model;
	}
	
	/**
	 * 좌석 정보 삭제
	 * @param seatInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="seatInfoDelete.do", method = RequestMethod.POST)
	public ModelAndView deleteSeatInfo(@RequestBody SeatInfo seatInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		List<String> seatList = new ArrayList<>(Arrays.asList(new String[]{ seatInfo.getSeatCd() }));
		seatService.deleteSeatInfo(seatList);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));
		
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