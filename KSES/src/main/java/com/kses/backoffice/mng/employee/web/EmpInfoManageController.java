package com.kses.backoffice.mng.employee.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
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
import com.kses.backoffice.mng.employee.service.DeptInfoManageService;
import com.kses.backoffice.mng.employee.service.EmpInfoManageService;
import com.kses.backoffice.mng.employee.service.GradInfoManageService;
import com.kses.backoffice.mng.employee.service.PositionInfoManageService;
import com.kses.backoffice.mng.employee.vo.DeptInfo;
import com.kses.backoffice.mng.employee.vo.EmpInfo;
import com.kses.backoffice.mng.employee.vo.GradInfo;
import com.kses.backoffice.mng.employee.vo.PositionInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;
import com.kses.backoffice.util.service.fileService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/mng")
public class EmpInfoManageController {
		
	@Autowired
	private EmpInfoManageService empService;
		
	@Autowired
	protected EgovMessageSource egovMessageSource;
		
	@Autowired
	protected EgovPropertyService propertiesService;
		
	@Autowired
	protected PositionInfoManageService positionService;
	
	@Autowired
	protected DeptInfoManageService deptService;
	
	@Autowired
	protected GradInfoManageService gradService;
	
	@Autowired
    private EgovCcmCmmnDetailCodeManageService cmmnDetailService;
		
	@Autowired
	private UniSelectInfoManageService uniService;
	
    @Autowired
	private fileService uploadFile;
    
	/**
	 * 조직도관리 화면
	 * @return
	 * @throws Exception
	 */
    @NoLogging
	@RequestMapping(value="orgList.do", method = RequestMethod.GET)
	public ModelAndView viewOrgList() throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/mng/orgList");
		
		String orgGubun = "Dept";
		Map<String, Object> regInfo = new HashMap<String, Object>();
		regInfo.put("orgGubun", orgGubun);
		switch (orgGubun) {
		     case "Dept" :
		    	 regInfo.put("orgTitle", "부서관리");
		    	 regInfo.put("orgCode", "부서코드");
		    	 regInfo.put("orgCodeNm", "부서명");
		    	 break;
		     case "Grad" :
		    	 regInfo.put("orgTitle", "직급관리");
		    	 regInfo.put("orgCode", "직급코드");
		    	 regInfo.put("orgCodeNm", "직급명");
		    	 break;
		     case "Post" : 
		    	 regInfo.put("orgTitle", "직책관리");
		    	 regInfo.put("orgCode", "직책코드");
		    	 regInfo.put("orgCodeNm", "직책명");
		    	 break;
		     default :
		    	 regInfo.put("orgTitle", "부서관리");
			     regInfo.put("orgCode", "부서코드");
		    	 regInfo.put("orgCodeNm", "부서명");
		         break;
	    }  
		model.addObject(Globals.STATUS_REGINFO, regInfo);
		
		return model;
	}
	@RequestMapping(value="orgListAjax.do")
	public ModelAndView selectOrginfoListAjax(	@ModelAttribute("LoginVO") LoginVO loginVO, 
												@RequestBody Map<String,Object> searchVO, 
												HttpServletRequest request) throws Exception {
	
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;
			} else {
				HttpSession httpSession = request.getSession(true);
				loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
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
			
			
			List<Map<String, Object>> list = null;
			switch (SmartUtil.NVL(searchVO.get("orgGubun"), "Dept" )) {
			     case "Dept" :
			    	 list = deptService.selectDeptInfoList(searchVO);
			    	 break;
			     case "Grad" :
			    	 list = gradService.selectGradInfoList(searchVO);
			    	 break;
			     case "Post" : 
			    	 list = positionService.selectPositionInfoList(searchVO) ;
			    	 break;
			}
			
			int totCnt = list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		
			model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
			model.addObject(Globals.PAGE_TOTALCNT, totCnt);
			paginationInfo.setTotalRecordCount(totCnt);
			model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			
		} catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			log.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	@RequestMapping (value="orgUpdate.do")
	public ModelAndView updateOrgInfo(	@ModelAttribute("loginVO") LoginVO loginVO, 
			                            @RequestBody Map<String,Object> searchVO, 
										HttpServletRequest request, 
										BindingResult result) throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		String meesage = null;
		
		try {
			 Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			 if(!isAuthenticated) {
				 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				 model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
				 return model;	
		     }
			 
			int ret = 0; 
			log.debug("orgGubun:" + searchVO.get("orgGubun"));
			switch (SmartUtil.NVL(searchVO.get("orgGubun"), "Dept" )) {
			    case "Dept":
					DeptInfo info = new DeptInfo();
			    	info.setDeptCd(searchVO.get("code").toString());
			    	info.setDeptNm(searchVO.get("codeNm").toString());
			    	info.setDeptDc(searchVO.get("codeDc").toString());
			    	info.setUseYn(searchVO.get("useYn").toString());
			    	info.setMode(searchVO.get("mode").toString());
			    	ret = deptService.updateDeptInfo(info);
			    	info = null;
			    break;
			    case "Grad":
			    	GradInfo gradInfo = new GradInfo();
			    	gradInfo.setGradCd(searchVO.get("code").toString());
			    	gradInfo.setGradNm(searchVO.get("codeNm").toString());
			    	gradInfo.setGradDc(searchVO.get("codeDc").toString());
			    	gradInfo.setUseYn(searchVO.get("useYn").toString());
			    	gradInfo.setMode(searchVO.get("mode").toString());
			    	ret = gradService.updateGradInfo(gradInfo);
			    	gradInfo = null;
			    break;
			    case "Post":
			    	PositionInfo positionInfo = new PositionInfo();
			    	positionInfo.setPsitCd(searchVO.get("code").toString());
			    	positionInfo.setPsitNm(searchVO.get("codeNm").toString());
			    	positionInfo.setPsitDc(searchVO.get("codeDc").toString());
			    	positionInfo.setUseYn(searchVO.get("useYn").toString());
			    	positionInfo.setMode(searchVO.get("mode").toString());
			    	ret = positionService.updateJikwInfo(positionInfo);
			    	positionInfo = null;
			    break;
			
			}
			
			
			
			meesage = (searchVO.get("mode").toString().equals(Globals.SAVE_MODE_INSERT)) ? "sucess.common.insert" : "sucess.common.update";
			if (ret > 0){
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			} else {
				throw new Exception();
			}
		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			log.info("e:" + e.toString() + ":" + lineNumber);
			meesage = (searchVO.get("mode").toString().equals(Globals.SAVE_MODE_INSERT)) ? "fail.common.insert" : "fail.common.update";
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));			
		}
		return model;
	}
	@RequestMapping (value="orgDelete.do")
	public ModelAndView deleteOrgInfoManage(@ModelAttribute("loginVO") LoginVO loginVO, 
			                                @RequestBody Map<String,Object> orgInfo, 
											HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }	
		
	    try {
	    	int ret = 0;
	    	switch (SmartUtil.NVL(orgInfo.get("orgGubun"), "Dept" )) {
		     case "Dept" :
		    	 ret = uniService.deleteUniStatement("", "TSEH_DEPT_INFO_M", "DEPT_CD=["+ orgInfo.get("code").toString() +"[");
		    	 break;
		     case "Grad" :
		    	 ret = uniService.deleteUniStatement("", "TSEH_GRAD_INFO_M", "GRAD_CD=["+ orgInfo.get("code").toString() +"[");
		    	 break;
		     case "Post" : 
		    	 ret = uniService.deleteUniStatement("", "TSEH_PSIT_INFO_M", "PSIT_CD=["+ orgInfo.get("code").toString() +"[");
		    	 break;
		    }
	    	ret = 1;
	    	if (ret > 0 ) {	
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );		    	 
			} else {
				throw new Exception();		    	  
			}    	 
		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			log.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}
	@RequestMapping(value="orgDetail.do")
	public ModelAndView selecDetailInfo(@ModelAttribute("LoginVO") LoginVO loginVO, 
										@RequestParam("code") String code, 
							            @RequestParam("orgGubun") String orgGubun,  
										HttpServletRequest request, 
										BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;
			} else {
				HttpSession httpSession = request.getSession(true);
				loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
			}
			
			Map<String, Object> orgInfo = new HashMap<String, Object>();
			switch (orgGubun) {
			     case "Dept" :
			    	 orgInfo = deptService.selectDeptDetailInfo(code);
			    	 break;
			     case "Grad" :
			    	 orgInfo = gradService.selectGradDetailInfo(code);
			    	 break;
			     case "Post" : 
			    	 orgInfo = positionService.selectPositionDetailInfo(code) ;
			    	 break;
			}
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, orgInfo);
			
		} catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			log.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	@RequestMapping(value="orgIdCheck.do")
	public ModelAndView orgIdCheck(@RequestParam("code") String code, 
			                                   @RequestParam("orgGubun") String orgGubun) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			
			String tbNm = "";
			String tbColumn = "";
			
			switch (orgGubun) {
			     case "Dept" :
			    	 tbNm = "TSEH_DEPT_INFO_M";
			    	 tbColumn = "DEPT_CD";
			    	 break;
			     case "Grad" :
			    	 tbNm = "TSEH_GRAD_INFO_M";
			    	 tbColumn = "GRAD_CD";
			    	 break;
			     case "Post" : 
			    	 tbNm = "TSEH_PSIT_INFO_M";
			    	 tbColumn = "PSIT_CD";
			    	 break;
			}
			int IDCheck = uniService.selectIdDoubleCheck(tbColumn, tbNm, ""+ tbColumn +" = ["+ code + "[" );
			log.debug("IDCheck:" + IDCheck);
			String result =  (IDCheck> 0) ? Globals.STATUS_FAIL : Globals.STATUS_OK;
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.JSON_RETURN_RESULT, result);
		}catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			log.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		
		return model;
	}
	
	/**
	 * 직원관리 화면
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="empList.do", method = RequestMethod.GET)
	public ModelAndView viwEmpList() throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/mng/empList");
		List<Map<String, Object>> orgList = deptService.selectOrgInfoComboList();
		List<Map<String, Object>> deptList = orgList.stream()
                .filter(x -> x.get("list_gubun").equals("DEPT"))
                .sorted((o1, o2) -> o1.get("code_cd").toString().compareTo(o2.get("code_cd").toString()))
                .collect(Collectors.toList());
		List<Map<String, Object>> gradList = orgList.stream()
                .filter(x -> x.get("list_gubun").equals("GRAD"))
                .sorted((o1, o2) -> o1.get("code_cd").toString().compareTo(o2.get("code_cd").toString()))
                .collect(Collectors.toList());
		List<Map<String, Object>> postList = orgList.stream()
                .filter(x -> x.get("list_gubun").equals("POST"))
                .sorted((o1, o2) -> o1.get("code_cd").toString().compareTo(o2.get("code_cd").toString()))
                .collect(Collectors.toList());
		model.addObject("userState", cmmnDetailService.selectCmmnDetailCombo("USER_STATE"));
		model.addObject("DEPT", deptList);
		model.addObject("GRAD", gradList);
		model.addObject("POST", postList);
		
		return model;
	}
	
	/**
	 * 직원 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="empListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectEmpinfoListAjax(@RequestBody Map<String,Object> searchVO) throws Exception {
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
		
		List<Map<String, Object>> list = empService.selectEmpInfoList(searchVO) ;
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
	 * 직원 정보 상세 조회
	 * 
	 * @param loginVO
	 * @param empno
	 * @param request
	 * @param bindingResult
	 * @return
	 * @throws Exception
	 *//** 사용하지 않음
	@RequestMapping(value="empDetail.do")
	public ModelAndView selectEmpinfoDetail(@ModelAttribute("LoginVO") LoginVO loginVO, 
											@RequestParam("empNo") String empNo, 
											HttpServletRequest request, 
											BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, empService.selectEmpInfoDetail(empNo));			    	 
		} catch (Exception e) {
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}	
		return model;			
	}*/

	/**
	 * 직원 정보 수정
	 * @param empInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="empUpdate.do", method = RequestMethod.POST)
	public ModelAndView empUpdate(@RequestBody EmpInfo empInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		int ret = 0;
		switch (empInfo.getMode()) {
			case Globals.SAVE_MODE_INSERT:
				ret = empService.insertEmpInfo(empInfo);
				break;
			case Globals.SAVE_MODE_UPDATE:
				ret = empService.updateEmpInfo(empInfo);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
		}
		
		String messageKey = "";
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			messageKey = StringUtils.equals(empInfo.getMode(), Globals.SAVE_MODE_INSERT) 
					? "sucess.common.insert" : "sucess.common.update";
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			messageKey = StringUtils.equals(empInfo.getMode(), Globals.SAVE_MODE_INSERT) 
					? "fail.common.insert" : "fail.common.update";
		}
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));
		
		return model;
	}

	/**
	 * 직원 정보 삭제
	 * @param empInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="empDelete.do", method = RequestMethod.POST)
	public ModelAndView deleteEmployInfo(@RequestBody EmpInfo empInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		int ret =  empService.deleteEmpInfo(SmartUtil.dotToList(empInfo.getEmpNo()));
		if (ret > 0) {
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );	
    	} else {
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
    	}
		
		return model;
	}
	
	/**
	 * 사번 중복 체크
	 * @param empno
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="empNoCheck.do", method = RequestMethod.GET)
	public ModelAndView empNoCheck(@RequestParam("empNo") String empNo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		int ret = uniService.selectIdDoubleCheck("EMP_NO", "TSEH_EMP_INFO_M", "EMP_NO = ["+ empNo + "[" );
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
	
	
}