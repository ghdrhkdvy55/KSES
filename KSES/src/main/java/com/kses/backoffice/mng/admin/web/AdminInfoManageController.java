package com.kses.backoffice.mng.admin.web;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.authority.service.AuthInfoService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.mng.admin.service.AdminInfoService;
import com.kses.backoffice.mng.admin.vo.AdminInfo;
import com.kses.backoffice.mng.employee.service.DeptInfoManageService;
import com.kses.backoffice.mng.employee.service.PositionInfoManageService;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/mng")
public class AdminInfoManageController {
	
	@Autowired
	private AdminInfoService adminInfoService;
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
	protected PositionInfoManageService positionService;
	
	@Autowired
	protected DeptInfoManageService deptService;
		
	@Autowired
	private UniSelectInfoManageService uniService;
	
	@Autowired
	private AuthInfoService authoService;
	
	@Autowired
	protected EgovPropertyService propertiesService;
	
	@Autowired
	private CenterInfoManageService centerInfoManageService;
	
	/**
	 * 관리자 관리 화면
	 * @param adminInfo
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="adminList.do", method = RequestMethod.GET)
	public ModelAndView viewAdminList(@ModelAttribute("AdminInfo") AdminInfo adminInfo) throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/mng/adminList");
		model.addObject("authorCd", authoService.selectAuthInfoComboList());
		model.addObject("dept", deptService.selectDeptInfoComboList());
		model.addObject("centerCd", centerInfoManageService.selectCenterInfoComboList());
		return model;
	}
	
	/**
	 * 관리자 관리 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="adminListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectAdminInfoListAjax(@RequestBody Map<String,Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		//페이징 처리 할 부분 정리 하기 
		int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));
		
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
	
		List<Map<String, Object>> list = adminInfoService.selectAdminUserManageListByPagination(searchVO) ;
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
	 * 중복 체크
	 * @param adminId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="adminIdCheck.do", method = RequestMethod.GET)
	public ModelAndView selectAdminIdCheckManger(@RequestParam("adminId") String adminId) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		int ret = uniService.selectIdDoubleCheck("ADMIN_ID", "TSEH_ADMIN_INFO_M", " ADMIN_ID = ["+ adminId + "[" );
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
	 * 관리자 정보 저장
	 * @param adminInfo
	 * @return
	 * @throws Exception
	 */
    @RequestMapping (value="adminUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateAdminInfo(@RequestBody AdminInfo adminInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		adminInfo.setFrstRegterId(userId);
		adminInfo.setLastUpdusrId(userId);
		
		int ret = 0;
		switch (adminInfo.getMode()) {
			case Globals.SAVE_MODE_INSERT:
				ret = adminInfoService.insertAdminUserManage(adminInfo);
				break;
			case Globals.SAVE_MODE_UPDATE:
				ret = adminInfoService.updateAdminUserManage(adminInfo);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
		}
		
		String messageKey = "";
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			messageKey = StringUtils.equals(adminInfo.getMode(), Globals.SAVE_MODE_INSERT) 
					? "sucess.common.insert" : "sucess.common.update";
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			messageKey = StringUtils.equals(adminInfo.getMode(), Globals.SAVE_MODE_INSERT) 
					? "fail.common.insert" : "fail.common.update";
		}
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));
		
		return model;
	}
    
	/**
	 * 관리자 정보 삭제
	 * @param params
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="adminDelete.do", method = RequestMethod.POST)
	public ModelAndView deleteAdminInfo(@RequestBody Map<String,Object> params) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		uniService.deleteUniStatement("", "TSEH_ADMIN_INFO_M", "ADMIN_ID IN (SELECT COLUMN_VALUE FROM TABLE (UF_SPLICT(["+  params.get("adminNoDel")+"[, [,[)))");
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );
		
		return model;
	}
	
	/**
	 * 사용하지 않음
	 * @param loginVO
	 * @param empno
	 * @param request
	 * @param bindingResult
	 * @return
	 * @throws Exception
	 *//**
	@RequestMapping(value="adminDetail.do")
	public ModelAndView selectAdmininfoDetail(@ModelAttribute("LoginVO") LoginVO loginVO, 
											@RequestParam("adminId") String adminId, 
											HttpServletRequest request, 
											BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, adminService.selectAdminUserManageDetail(adminId));			    	 
		} catch (Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));			
		}	
		return model;			
	}*/
}