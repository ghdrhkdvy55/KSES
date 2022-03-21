package com.kses.backoffice.cus.usr.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.cus.usr.service.UserInfoManageService;
import com.kses.backoffice.cus.usr.vo.UserInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/cus")
public class UserInfoController {

	
	private static final Logger LOGGER = LoggerFactory.getLogger(UserInfoController.class);
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
	protected EgovPropertyService propertiesService;
	
	@Autowired
	private EgovCcmCmmnDetailCodeManageService cmmnDetailService;
	
	@Autowired
	protected UserInfoManageService userService;

	/**
	 * 고객정보 관리 화면
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="userList.do", method = RequestMethod.GET)
	public ModelAndView viewUserInfoList() throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/cus/userList");

		model.addObject("vacntnRound", cmmnDetailService.selectCmmnDetailCombo("VACNTN_ROUND")); // 백신 차수 combo box 용
		model.addObject("vacntnDvsn", cmmnDetailService.selectCmmnDetailCombo("VACNTN_DVSN")); // 백신 종류 combo box 용

		return model;	
	}

	/**
	 * 고객정보 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="userListInfoAjax.do", method = RequestMethod.POST)
	public ModelAndView selectUserinfoListAjax(@RequestBody Map<String,Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
			
		searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		
		List<Map<String, Object>> list = userService.selectUserInfoListPage(searchVO) ;
		int totCnt = list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
			
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

		return model;
	}
	
	@RequestMapping (value="userListInfoUpdate.do", method = RequestMethod.POST)
	public ModelAndView userListInfoUpdate(@RequestBody UserInfo userInfo) throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		int ret = 0;
		ret = userService.updateUserInfo(userInfo);
		
		String messageKey = "";

		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			messageKey = "sucess.common.update";
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			messageKey = "fail.common.update";
		}

		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));

		return model;
	}
}
