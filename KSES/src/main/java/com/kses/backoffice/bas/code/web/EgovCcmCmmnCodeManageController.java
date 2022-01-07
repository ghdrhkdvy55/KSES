package com.kses.backoffice.bas.code.web;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnCodeManageService;
import com.kses.backoffice.bas.code.vo.CmmnCode;
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
@Controller
@RequestMapping("/backoffice/bas")
public class EgovCcmCmmnCodeManageController {

	@Autowired
	private EgovCcmCmmnCodeManageService cmmnCodeManageService;

	@Autowired
	protected EgovMessageSource egovMessageSource;

	@Autowired
	protected EgovPropertyService propertiesService;

	@Autowired
	private UniSelectInfoManageService uniService;

	/**
	 * 공통코드 관리 화면
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "codeList.do", method = RequestMethod.GET)
	public ModelAndView selectCmmnCodeList() throws Exception {
		return new ModelAndView("/backoffice/bas/codeList");
	}

	/**
	 * 공통분류코드 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "codeListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectCmmnCodeListAjax(@RequestBody Map<String, Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

		searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		searchVO.put("searchKeyword", SmartUtil.NVL(searchVO.get("searchKeyword"), ""));
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());

		model.addObject(Globals.STATUS_REGINFO, searchVO);
		log.info("searchVO:" + searchVO);

		List<Map<String, Object>> list = cmmnCodeManageService.selectCmmnCodeListByPagination(searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);

		int totCnt = list.size() > 0 ? Integer.valueOf(list.get(0).get("total_record_count").toString()) : 0;

		model.addObject(Globals.PAGE_TOTALCNT, totCnt);

		paginationInfo.setTotalRecordCount(totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

		return model;
	}

	/**
	 * 공통분류코드 저장
	 * @param cmmnCode
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "codeUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateCmmCodeManage(@RequestBody CmmnCode cmmnCode) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		cmmnCode.setFrstRegisterId(userId);
		cmmnCode.setLastUpdusrId(userId);
		
		int ret = 0;
		switch (cmmnCode.getMode()) {
			case "Ins":
				ret = cmmnCodeManageService.insertCmmnCode(cmmnCode);
				break;
			case "Edt":
				ret = cmmnCodeManageService.updateCmmnCode(cmmnCode);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
		}
		
		String messageKey = "";
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			messageKey = StringUtils.equals(cmmnCode.getMode(), "Ins") ? "sucess.common.insert" : "sucess.common.update";
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			messageKey = StringUtils.equals(cmmnCode.getMode(), "Ins") ? "fail.common.insert" : "fail.common.update";
		}
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));
		
		return model;
	}

	/**
	 * 공통코드를 삭제한다
	 * @param cmmnCode
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "codeDelete.do", method = RequestMethod.POST)
	public ModelAndView deleteCmmnCodeManage(@RequestBody CmmnCode cmmnCode) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		cmmnCodeManageService.deleteCmmnCode(cmmnCode.getCodeId());
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));

		return model;
	}

	/**
	 * 공통분류코드 코드값 중복 체크
	 * @param codeId
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value = "codeIDCheck.do", method = RequestMethod.GET)
	public ModelAndView selectIdCheck(@RequestParam("codeId") String codeId) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		String result = uniService.selectIdDoubleCheck("CODE_ID", "COMTCCMMNCODE", "CODE_ID = [" + codeId + "[") > 0
				? Globals.STATUS_FAIL
				: Globals.STATUS_OK;
		if (StringUtils.equals(result, "OK")) {
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
	 * 공통 분류 코드 상세정보 조회
	 * - 사용하지 않음
	 * @param codeId
	 * @return
	 * @throws Exception
	 *//**
	@RequestMapping(value = "codeDetail.do")
	public ModelAndView selectGroupDetail(@RequestParam("codeId") String codeId) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		Map<String, Object> cmmCode = cmmnCodeManageService.selectCmmnCodeDetail(codeId);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_REGINFO, cmmCode);

		return model;
	}
	*/
	
}