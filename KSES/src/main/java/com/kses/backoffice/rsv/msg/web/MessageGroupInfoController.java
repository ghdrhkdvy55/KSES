package com.kses.backoffice.rsv.msg.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
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

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.cus.usr.service.UserInfoManageService;
import com.kses.backoffice.mng.employee.service.EmpInfoManageService;
import com.kses.backoffice.rsv.msg.service.MessageGroupInfoManageService;
import com.kses.backoffice.rsv.msg.service.MessageGroupUserInfoManageService;
import com.kses.backoffice.rsv.msg.service.MessageTemInfoManageService;
import com.kses.backoffice.rsv.msg.vo.MessageGroupInfo;
import com.kses.backoffice.rsv.msg.vo.MessageGroupUserInfo;
import com.kses.backoffice.rsv.msg.vo.MessageTemInfo;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/rsv")
public class MessageGroupInfoController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MessageGroupInfoController.class);
	
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
	private EmpInfoManageService empService;
	
	@Autowired
    protected EgovPropertyService propertiesService;

	@Autowired
    protected MessageGroupInfoManageService  msgGroupService;
	
	@Autowired
    protected MessageGroupUserInfoManageService  msgGroupUserService;
		
	@Autowired
    protected EgovCcmCmmnDetailCodeManageService egovCodeDetailService;
	
	@Autowired
	private UniSelectInfoManageService uniService;
	
	@Resource(name="egovMessageGroupCodeGnrService")
	private EgovIdGnrService egovGroupCodeGnr;
	
	@Autowired
	private CenterInfoManageService centerInfoManageService;
	
	@Autowired
	private MessageTemInfoManageService msgTemplateSerice;
	
	@Autowired
	protected UserInfoManageService userService;
	
	@RequestMapping(value="msgState.do")
	public ModelAndView  selectMsgInfoManageListByPagination(@ModelAttribute("loginVO") LoginVO loginVO
															, HttpServletRequest request
															, BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/rsv/msgState");
		
		try{
			  Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		      if(!isAuthenticated) {
	    	    model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	    model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
	    	    model.setViewName("backoffice/login");
	    		return model;
		      }
		      loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		      //내용 수정 
		      model.addObject("centerCombo", centerInfoManageService.selectCenterInfoComboList());
		      
		      
		      model.addObject("loginVO" , loginVO);
		      if (!loginVO.getAuthorCd().equals("ROLE_ADMIN") && !loginVO.getAuthorCd().equals("ROLE_SYSTEM"))
		    	  model.addObject("centerInfo" , centerInfoManageService.selectCenterInfoDetail(loginVO.getCenterCd()));
		      
		}catch (Exception e){
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject("message", egovMessageSource.getMessage("fail.common.list"));
			LOGGER.info(e.toString());
		}			   
		return model;	
	}
	@RequestMapping(value="msgGroupList.do")
	public ModelAndView  selectMsgGroupListAjaxInfo(@ModelAttribute("loginVO") LoginVO loginVO
			                                        , @RequestBody Map<String, Object> searchVO
													, HttpServletRequest request
													, BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try{
			
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;
			}
			  
		    int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			  
			searchVO.put("pageSize", propertiesService.getInt("pageSize"));
			  
		              
		   	PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
			paginationInfo.setRecordCountPerPage(pageUnit);
			paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
			searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
			searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
			searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
			//여기도 필요 한지 여부 
			  
			
			List<Map<String, Object>> list =  msgGroupService.selectMessageGroupInfoList(searchVO);
			int totCnt = list.size() > 0 ?  Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		    
			model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
			model.addObject(Globals.PAGE_TOTALCNT, totCnt);
			paginationInfo.setTotalRecordCount(totCnt);
			model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			
		}catch (Exception e){
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.list"));
			LOGGER.info(e.toString());
		}			   
		return model;	
	}
	@RequestMapping(value="msgGroupDetail.do")
	public ModelAndView selectMsgGroupDetail (@ModelAttribute("LoginVO") LoginVO loginVO, 
											  @RequestParam("groupCode") String groupCode, 
											  HttpServletRequest request, 
											  BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, msgGroupService.selectMessageGroupDetail(groupCode));		    	 
		} catch (Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));			
		}	
		return model;			
	}	
	@RequestMapping (value="msgGroupUpdate.do")
	public ModelAndView msgGroupUpdate(@RequestBody MessageGroupInfo info 
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
			 
			 if ( info.getMode().equals("Ins"))
				 info.setGroupCode(egovGroupCodeGnr.getNextStringId());
			 
			 int ret = msgGroupService.updateMessageGroupInfo(info); 
			 LOGGER.debug("ret:"  + ret);
			 meesage = (info.getMode().equals("Ins")) ? "sucess.common.insert" : "sucess.common.update";
			 if (ret > 0){
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			 } else {
				throw new Exception();
			 }
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
	@RequestMapping(value="msgGroupDelete.do")
	public ModelAndView deleteMsgGroupInfo(@RequestParam("delCd") String delCd,  
										   HttpServletRequest request) throws Exception {
			
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				 model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
				 return model;	
		    }
			
			try {
				
				boolean delCheck = msgGroupService.deleteMessageGroupInfo(delCd);
				
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
	@RequestMapping(value="msgGroupUserSearchList.do")
	public ModelAndView  selectMsgGroupUserSearchListAjaxInfo(@ModelAttribute("loginVO") LoginVO loginVO
			                                                  , @RequestBody Map<String, Object> searchVO
															  , HttpServletRequest request
															  , BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try{
			
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;
			}
			PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo(1 );
			paginationInfo.setRecordCountPerPage(2000);
			paginationInfo.setPageSize(2000);
			searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
			searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
			searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
			List<Map<String, Object>> list = null;
			String searchCondition = "";
			
			LOGGER.debug("searchUserCondition" + searchVO.get("searchUserCondition").toString());
			
			if (searchVO.get("searchUserGubun").toString().equals("EMP")) {

                switch (searchVO.get("searchUserCondition").toString()) {
				     case "EMP_NO"  : 
				    	  searchCondition = "emp_no";
				    	  break;
				     case "EMP_NM" : 
				    	  searchCondition = "emp_nm";
				    	  break;
				     case "EMP_CLPHN"  : 
				    	  searchCondition = "emp_cell";
				    	  break;
				}
                
				searchVO.put("searchCondition", searchCondition);
				searchVO.put("searchKeyword", searchVO.get("searchUserKeyworkd").toString());
				
				list = 	empService.selectEmpInfoList(searchVO);
		    }else {
		    	 switch (searchVO.get("searchUserCondition").toString()) {
					     case "USERID"  : 
					    	  searchCondition = "user_id";
					    	  break;
					     case "USERNAME" : 
					    	  searchCondition = "user_nm";
					    	  break;
					     case "CELLPHNONE"  : 
					    	  searchCondition = "user_phone";
					    	  break;
				  }
		    	  LOGGER.debug("searchVO:" + searchVO.get("searchCondition") + ":" + searchCondition);
		    	  searchVO.put("searchCondition", searchCondition);
				  searchVO.put("searchKeyword", searchVO.get("searchUserKeyworkd").toString());
				  list = 	userService.selectUserInfoListPage(searchVO);	
		    }
			
			
			int totCnt = list.size() > 0 ?  Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		    
			model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
			model.addObject(Globals.PAGE_TOTALCNT, totCnt);
			paginationInfo.setTotalRecordCount(totCnt);
			model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			
		}catch (Exception e){
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.list"));
			LOGGER.info(e.toString());
		}			   
		return model;	
	}
	
	@RequestMapping(value="msgGroupUserList.do")
	public ModelAndView  selectMsgGroupUserListAjaxInfo(@ModelAttribute("loginVO") LoginVO loginVO
			                                        , @RequestParam("groupCode") String groupCode
													, HttpServletRequest request
													, BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try{
			
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;
			}
			  
		    Map<String, Object> searchVO = new HashMap<String, Object>();
		              
		   	PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo(1 );
			paginationInfo.setRecordCountPerPage(2000);
			paginationInfo.setPageSize(2000);
			searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
			searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
			searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
			searchVO.put("searchGroupCode", groupCode);
			
			
			List<Map<String, Object>> list =  msgGroupUserService.selectMessageGroupUserInfoList(searchVO);
			int totCnt = list.size() > 0 ?  Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		    
			model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
			model.addObject(Globals.PAGE_TOTALCNT, totCnt);
			paginationInfo.setTotalRecordCount(totCnt);
			model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			
		}catch (Exception e){
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.list"));
			LOGGER.info(e.toString());
		}			   
		return model;	
	}
	//리스트 형태 입력
	@RequestMapping (value="msgGroupUserUpdateList.do", method=RequestMethod.POST)
	public ModelAndView msgGroupUserUpdateList(	@RequestBody Map<String, Object> params 
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
			
			 Gson gson = new GsonBuilder().create();
			 List<MessageGroupUserInfo> msgUserInfos = gson.fromJson(params.get("data").toString(), new TypeToken<List<MessageGroupUserInfo>>(){}.getType());
			 LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			 msgUserInfos.forEach(MessageGroupUserInfo -> MessageGroupUserInfo.setLastUpdusrId(loginVO.getAdminId()));
			 
			 
			 int ret = msgGroupUserService.insertMessageGroupUserInfo(msgUserInfos);
			 if (ret > 0){
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.insert"));
			 } else {
				throw new Exception();
			 }
		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));			
		}
		return model;
	}
	//단일 입력
	@RequestMapping (value="msgGroupUserUpdate.do", method=RequestMethod.POST)
	public ModelAndView msgGroupUserUpdate(	@RequestBody  MessageGroupUserInfo  info 
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
			 info.setLastUpdusrId(loginVO.getAdminId());
			 
			 int ck_id =  uniService.selectIdDoubleCheck("GROUP_USER_CELLPHONE", "TSES_MESSAGGROUP_USER", " GROUP_CODE = ["+  info.getGroupCode() + "[ AND GROUP_USER_CELLPHONE = ["+  info.getGroupUserCellphone() + "[ " );
			 if (ck_id > 0) {
				 model.addObject(Globals.STATUS, Globals.STATUS_OVERLAPFAIL);
				 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.overlap"));
			 }
			 
			 boolean ret = msgGroupUserService.insertMessageGroupUser(info);
			 if (ret == true ){
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.insert"));
			 } else {
				throw new Exception();
			 }
		} catch (Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));			
		}
		return model;
	}
	@RequestMapping(value="msgGroupUserDelete.do")
	public ModelAndView deleteMsgUserGroupInfo(@RequestParam("groupUserseq") String groupUserseq,  
										       HttpServletRequest request) throws Exception {
			
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				 model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
				 return model;	
		    }
			try {
				boolean delCheck = msgGroupUserService.deleteMessageGroupUserInfo(groupUserseq);
				
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
	
	@RequestMapping(value="msgTemplateList.do")
	public ModelAndView  selectMsgTemplateListAjaxInfo(@ModelAttribute("loginVO") LoginVO loginVO
			                                        , @RequestBody Map<String, Object> searchVO
													, HttpServletRequest request
													, BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try{
			
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;
			}
			  
		    int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			  
			searchVO.put("pageSize", propertiesService.getInt("pageSize"));
			  
		              
		   	PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
			paginationInfo.setRecordCountPerPage(pageUnit);
			paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
			searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
			searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
			searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
			  
			LOGGER.debug("searchVO" + searchVO.get("adminYn"));
			
			List<Map<String, Object>> list =  msgTemplateSerice.selectMessageTemplateInfoList(searchVO);
			int totCnt = list.size() > 0 ?  Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		    
			model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
			model.addObject(Globals.PAGE_TOTALCNT, totCnt);
			paginationInfo.setTotalRecordCount(totCnt);
			model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			
		}catch (Exception e){
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.list"));
			LOGGER.info(e.toString());
		}			   
		return model;	
	}
	@RequestMapping(value="msgTemplateDetail.do")
	public ModelAndView selectMsgTemplateDetail (@ModelAttribute("LoginVO") LoginVO loginVO, 
											  @RequestParam("tempSeq") String tempSeq, 
											  HttpServletRequest request, 
											  BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, msgTemplateSerice.selectMessageTemplateDetail(tempSeq));		    	 
		} catch (Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));			
		}	
		return model;			
	}	
	@RequestMapping (value="msgTemplateUpdate.do")
	public ModelAndView msgTemplateUpdate(@RequestBody MessageTemInfo info 
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
			 info.setLastUpdusrId(loginVO.getAdminId());
			
			 
			 int ret = msgTemplateSerice.updateMessageTemplateInfo(info); 
			 LOGGER.debug("ret:"  + ret);
			 meesage = (info.getMode().equals("Ins")) ? "sucess.common.insert" : "sucess.common.update";
			 if (ret > 0){
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			 } else {
				throw new Exception();
			 }
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
	@RequestMapping(value="msgTemplatepDelete.do")
	public ModelAndView deleteTemplateInfo(@RequestParam("delCd") String delCd,  
										   HttpServletRequest request) throws Exception {
			
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				 model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				 model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
				 return model;	
		    }
			
			try {
				boolean delCheck = msgTemplateSerice.deleteMessageTemplateInfo(delCd);
				
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
