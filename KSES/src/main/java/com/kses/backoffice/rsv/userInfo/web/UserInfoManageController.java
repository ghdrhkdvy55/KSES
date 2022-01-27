package com.kses.backoffice.rsv.userInfo.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.rsv.userInfo.service.UserInfoService;
import com.kses.backoffice.rsv.userInfo.vo.User;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.rte.fdl.property.EgovPropertyService;


@RestController
@RequestMapping("/backoffice/rsv")
public class UserInfoManageController {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserInfoManageController.class);
    
    @Autowired
    EgovMessageSource egovMessageSource;
    
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
    private UserInfoService userService;
	
	@Autowired
	private EgovCcmCmmnDetailCodeManageService cmmnDetailService;

	@RequestMapping(value="userList.do")
	public ModelAndView selectBlackUserInfoList(	@ModelAttribute("loginVO") LoginVO loginVO,
													HttpServletRequest request, 
													BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/rsv/userList"); 
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.setViewName("/backoffice/login");
				return model;	
			} else {
		       HttpSession httpSession = request.getSession(true);
		       loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
			}			
			model.addObject("vacntnRound", cmmnDetailService.selectCmmnDetailCombo("VACNTN_ROUND"));
			model.addObject("vacntnDvsn", cmmnDetailService.selectCmmnDetailCombo("VACNTN_DVSN"));
		    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectVaccineInfoList : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;	
	}
	
	@RequestMapping(value="userListAjax.do")
	public ModelAndView selectHolyInfoListAjax(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestBody Map<String, Object> searchVO, 
												HttpServletRequest request, 
												BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
			
		try {
			int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			  
		    searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		  
		    LOGGER.info("pageUnit:" + pageUnit);
		                
	   	    PaginationInfo paginationInfo = new PaginationInfo();
		    paginationInfo.setCurrentPageNo( Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
		    paginationInfo.setRecordCountPerPage(pageUnit);
		    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

		    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		    			  
			List<Map<String, Object>> list = userService.selectUserInfoListByPagination(searchVO);
	        int totCnt =  list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) :0;
	   
			model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		    model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		    paginationInfo.setTotalRecordCount(totCnt);
		    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);	    
		  
		}catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
		return model;
	}
	
	@RequestMapping (value="userInfoDetail.do")
	public ModelAndView selectHolyInfoDetail(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestParam("userId") String userId, 
												HttpServletRequest request, 
												BindingResult bindingResult) throws Exception{	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }
	    
	    try {
	    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, userService.selectUserDetail(userId));
	    } catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
	    }
	    return model;
	}
	
	@RequestMapping (value="userUpdate.do")
	public ModelAndView updateHolyInfo(	@ModelAttribute("loginVO") LoginVO loginVO, 
										@RequestBody User vo, 
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
			 //사용자 등록
			 loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			/* vo.setUserId(loginVO.getAdminId()); */
			 
			 int ret  = userService.updateUser(vo);
			 meesage = "sucess.common.update";
			 if (ret > 0){
				 model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			 } else {
				 throw new Exception();
			 }
		} catch (Exception e) {
			meesage = "fail.common.update";
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));			
		}
		return model;
	}
}