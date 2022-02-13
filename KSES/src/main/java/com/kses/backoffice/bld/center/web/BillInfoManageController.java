package com.kses.backoffice.bld.center.web;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bld.center.service.BillInfoManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.center.vo.BillDayInfo;
import com.kses.backoffice.bld.center.vo.BillInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/backoffice/bld")
public class BillInfoManageController {
    
    @Autowired
    EgovMessageSource egovMessageSource;
    
    @Autowired
    BillInfoManageService billService;
    
    @Autowired
    CenterInfoManageService centerInfoService;

	@Autowired
	protected EgovPropertyService propertiesService;

	@Autowired
	private EgovCcmCmmnDetailCodeManageService codeDetailService;

	/**
	 * 현금영수증 설정 팝업 화면 호출
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "billInfoPopup.do", method = RequestMethod.GET)
	public ModelAndView popupBillInfo() throws Exception {
		ModelMap model = new ModelMap();
		model.addAttribute("billDvsnInfoComboList", codeDetailService.selectCmmnDetailCombo("BILL_DVSN"));
		return new ModelAndView("/backoffice/bld/sub/billInfo", model);
	}

	/**
	 * 지점별 영수증 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "billInfoListAjax.do", method = RequestMethod.POST)
    public ModelAndView selectBillInfoList(@RequestBody Map<String,Object> searchVO) throws Exception {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String centerCd = (String) searchVO.get("centerCd");

		List<Map<String, Object>> billInfoList = billService.selectBillInfoList(centerCd);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, billInfoList);
		model.addObject(Globals.PAGE_TOTALCNT, billInfoList.size());
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

    	return model;
    }

	/**
	 * 지점별 현금영수증(요일) 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "billDayInfoListAjax.do", method = RequestMethod.POST)
    public ModelAndView selectBillDayInfoList(@RequestBody Map<String,Object> searchVO) throws Exception {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String centerCd = (String) searchVO.get("centerCd");

		//Paging
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(1);
		paginationInfo.setRecordCountPerPage(10);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		searchVO.put("pageSize", paginationInfo.getPageSize());

		List<Map<String, Object>> billInfoList = billService.selectBillInfoList(centerCd);
		List<Map<String, Object>> billDayInfoList = billService.selectBillDayInfoList(centerCd);
		paginationInfo.setTotalRecordCount(7);
		billDayInfoList.stream().forEach(x ->
			x.put("bill_info_list", billInfoList)
		);

		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, billDayInfoList);
		model.addObject(Globals.PAGE_TOTALCNT, paginationInfo.getTotalRecordCount());
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
    	
    	return model;
    }

	/**
	 * 지점별 현금영수증(요일) 저장
	 * @param billInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "billInfoUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateBillInfo(@RequestBody BillInfo billInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		billInfo.setFrstRegterId(userId);
		billInfo.setLastUpdusrId(userId);
		int ret = 0;
		switch (billInfo.getMode()) {
			case Globals.SAVE_MODE_INSERT:
				ret = billService.insertBillInfo(billInfo);
				break;
			case Globals.SAVE_MODE_UPDATE:
				ret = billService.updateBillInfo(billInfo);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
		}
		String messageKey = "";
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			messageKey = StringUtils.equals(billInfo.getMode(), Globals.SAVE_MODE_INSERT)
					? "sucess.common.insert" : "sucess.common.update";
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			messageKey = StringUtils.equals(billInfo.getMode(), Globals.SAVE_MODE_INSERT)
					? "fail.common.insert" : "fail.common.update";
		}
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));

		return model;
	}

	/**
	 * 현금영수증 정보 삭제
	 * @param billSeq
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "billInfoDelete.do", method = RequestMethod.POST)
	public ModelAndView deleteBillInfoManage(@RequestBody BillInfo billInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		billService.deleteBillInfo(billInfo);

		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );

		return model;
	}

	/**
	 * 지점별 현금영수증(요일) 수정
	 * @param billDayInfoList
	 * @return
	 * @throws Exception
	 */
	@NoLogging
    @RequestMapping(value = "billDayInfoUpdate.do", method = RequestMethod.POST)
    public ModelAndView updateBillDayInfo(@RequestBody List<BillDayInfo> billDayInfoList) throws Exception {
    	ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		billDayInfoList.stream().forEach(x -> x.setLastUpdusrId(userId));
		billService.updateBillDayInfo(billDayInfoList);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.update"));

    	return model;
    }
	


//	@RequestMapping (value="billInfoDetail.do")
//	public ModelAndView selectCenterInfoDetail( @RequestParam("billSeq") String billSeq ,
//												HttpServletRequest request) throws Exception {
//
//		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
//		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
//		if(!isAuthenticated) {
//			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
//			model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
//			return model;
//		}
//
//		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//		model.addObject(Globals.STATUS_REGINFO, billService.selectBillInfoDetail(billSeq));
//		return model;
//	}
}