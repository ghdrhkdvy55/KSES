package com.kses.backoffice.mng.admin.web;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
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
import com.kses.backoffice.bas.authority.service.AuthInfoService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.mng.admin.service.AdminInfoService;
import com.kses.backoffice.mng.admin.vo.AdminInfo;
import com.kses.backoffice.mng.employee.service.DeptInfoManageService;
import com.kses.backoffice.mng.employee.service.PositionInfoManageService;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/mng")
public class AdminInfoManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminInfoManageController.class);
	
	@Autowired
	private AdminInfoService adminService;
	
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
	
	
	@RequestMapping(value="adminList.do")
	public ModelAndView selectAdminInfoList(	@ModelAttribute("LoginVO") LoginVO loginVO, 
											@ModelAttribute("AdminInfo") AdminInfo info,
											HttpServletRequest request, 
											BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/mng/adminList");

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
			return model;	
		} 
		try {
			
			model.addObject("authorCd", authoService.selectAuthInfoComboList());
			model.addObject("dept", deptService.selectDeptInfoComboList());
			model.addObject("centerCd", centerInfoManageService.selectCenterInfoComboList());
			
			
		}catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		
		return model;
	}
	/**
	 * 직원 정보 목록 
	 * 
	 * @param loginVO
	 * @param searchVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="adminListAjax.do")
	public ModelAndView selectAdmininfoListAjax(@ModelAttribute("LoginVO") LoginVO loginVO, 
												@RequestBody Map<String,Object> searchVO, 
												HttpServletRequest request) throws Exception {
	
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;
			}
			
			//페이징 처리 할 부분 정리 하기 
			int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			
			PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1")));
			paginationInfo.setRecordCountPerPage(pageUnit);
			paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
			
			searchVO.put("pageSize", propertiesService.getInt("pageSize"));
			searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
			searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
			searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		
			if (SmartUtil.NVL(searchVO.get("mode"), "").equals("")) {
				searchVO.put("mode", "list");
				List<Map<String, Object>> list = adminService.selectAdminUserManageListByPagination(searchVO) ;
				int totCnt = list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
			
				model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
				model.addObject(Globals.PAGE_TOTALCNT, totCnt);
				paginationInfo.setTotalRecordCount(totCnt);
				model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			}
		} catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	/**
	 * 직원 정보 상세 조회
	 * 
	 * @param loginVO
	 * @param empno
	 * @param request
	 * @param bindingResult
	 * @return
	 * @throws Exception
	 */
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
	}	
	@RequestMapping(value="adminIdCheck.do")
	public ModelAndView selectadminIdCheckManger(@RequestParam("adminId") String adminId) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			
			
			int IDCheck = uniService.selectIdDoubleCheck("ADMIN_ID", "TSEH_ADMIN_INFO_M", " ADMIN_ID = ["+ adminId + "[" );
			String result =  (IDCheck> 0) ? Globals.STATUS_FAIL : Globals.STATUS_OK;
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.JSON_RETURN_RESULT, result);
		}catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		
		return model;
	}
    @RequestMapping (value="adminUpdate.do")
	public ModelAndView adminUpdate(@RequestBody AdminInfo info 
						            , HttpServletRequest request
								    , BindingResult result) throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		String meesage = null;
		
		try {
            Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			 if(!isAuthenticated) {
				 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				 model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
				 return model;	
		     }
			 LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			 info.setUserId(loginVO.getAdminId());
			 
			 int ret = adminService.updateAdminUserManage(info);
			 		
			 LOGGER.debug("ret:"  + ret);
			 meesage = (info.getMode().equals("Ins")) ? "sucess.common.insert" : "sucess.common.update";
			 
			 // hgp 2021.12.12 오라클 멀티쿼리 반환값 이슈로 임시 주석처리			
             model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			 
//			 if (ret > 0){
//				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
//			 } else {
//				throw new Exception();
//			 }
		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			meesage = (info.getMode().equals("Ins")) ? "fail.common.insert" : "fail.common.update";
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));			
		}
		return model;
	}
	/**
	 * 직원 정보 삭제
	 * 
	 * @param loginVO
	 * @param empno
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="adminDelete.do", method = {RequestMethod.POST})
	public ModelAndView deleteAdminInfo(@RequestBody Map<String,Object> delId,  
										 HttpServletRequest request) throws Exception {
			
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				 model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
				 return model;	
		    }
			LOGGER.debug("================================== adminNoDel:" + delId.get("adminNoDel"));
			
			try {
				uniService.deleteUniStatement("", "TSEH_ADMIN_INFO_M", "ADMIN_ID IN (SELECT COLUMN_VALUE FROM TABLE (UF_SPLICT(["+  delId.get("adminNoDel")+"[, [,[)))");
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );
			}catch(Exception e) {
				throw new Exception();		
			}
		} catch (Exception e){
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}	
		return model;
	}
	
	
}