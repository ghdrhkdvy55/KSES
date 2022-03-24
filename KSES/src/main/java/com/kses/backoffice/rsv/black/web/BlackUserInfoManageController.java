package com.kses.backoffice.rsv.black.web;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.rsv.black.service.BlackUserInfoManageService;
import com.kses.backoffice.rsv.black.vo.BlackUserInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/rsv")
public class BlackUserInfoManageController {

    @Autowired
    EgovMessageSource egovMessageSource;
	
    @Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private EgovCcmCmmnDetailCodeManageService codeDetailService;
	
	@Autowired
	BlackUserInfoManageService blackUserService;
	
	/**
	 * 출입통제 고객정보 화면
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="blackList.do", method = RequestMethod.GET)
	public ModelAndView viewBlackList() throws Exception {
		ModelMap modelMap = new ModelMap();
		modelMap.addAttribute("blklstDvsn", codeDetailService.selectCmmnDetailCombo("BLKLST_DVSN"));
		return new ModelAndView("/backoffice/rsv/blackList", modelMap);
	}
	
	/**
	 * 출입통제 고객 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="blackListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectAuthInfoListAjax(@RequestBody Map<String, Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);

		int pageUnit = searchVO.get("pageUnit") == null ?  propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));

   	    PaginationInfo paginationInfo = new PaginationInfo();
	    paginationInfo.setCurrentPageNo( Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"),"1")));
	    paginationInfo.setRecordCountPerPage(pageUnit);
	    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

	    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
	    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
	    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());

	    List<Map<String, Object>> list = blackUserService.selectBlackUserInfoList(searchVO);
        int totCnt =  list.size() > 0 ? Integer.valueOf(list.get(0).get("total_record_count").toString()) : 0;
		paginationInfo.setTotalRecordCount(totCnt);

		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
	    model.addObject(Globals.PAGE_TOTALCNT, totCnt);
	    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
	    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
	    
		return model;
	}
	
	/**
	 * 출입통제 고객정보 등록/수정
	 * @param blackUserInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="blackUserUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateAuthInfoManage(@RequestBody BlackUserInfo blackUserInfo) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		int ret = 0;
		switch (blackUserInfo.getMode()) {
			case Globals.SAVE_MODE_INSERT:
				ret = blackUserService.insertBlackUserInfo(blackUserInfo);
				break;
			case Globals.SAVE_MODE_UPDATE:
				ret = blackUserService.updateBlackUserInfo(blackUserInfo);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
		}
		
		String messageKey = "";
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			messageKey = StringUtils.equals(blackUserInfo.getMode(), Globals.SAVE_MODE_INSERT) 
					? "sucess.common.insert" : "sucess.common.update";
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			messageKey = StringUtils.equals(blackUserInfo.getMode(), Globals.SAVE_MODE_INSERT) 
					? "fail.common.insert" : "fail.common.update";
		}
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));
		
		return model;
	}
}