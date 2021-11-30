package com.kses.backoffice.sys.msg.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.mng.admin.service.AdminInfoService;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;

import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
/*import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
*/
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
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

import com.kses.backoffice.sys.msg.service.MessageGroupUserInfoManageService;
import com.kses.backoffice.sys.msg.service.MessageInfoManageService;
import com.kses.backoffice.sys.msg.vo.MessageInfo;
import com.kses.backoffice.util.SmartUtil;


@RestController
@RequestMapping("/backoffice/sys")
public class MessageInfoManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MessageInfoManageController.class);
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;

	@Autowired
    protected MessageInfoManageService msgService;
		
	@Autowired
    protected EgovCcmCmmnDetailCodeManageService egovCodeDetailService;
	
	@Autowired
    protected MessageGroupUserInfoManageService  msgGroupUserService;
	
	@Autowired
	private AdminInfoService  adminService;
	
	@Autowired
	private ResvInfoManageService  resService;
	
	@RequestMapping(value="msgList.do")
	public ModelAndView  selectMsgInfoManageListByPagination(@ModelAttribute("loginVO") LoginVO loginVO
															, HttpServletRequest request
															, BindingResult bindingResult) throws Exception {
		
		   ModelAndView model = new ModelAndView();
		   model.setViewName("/backoffice/sys/msgList");
		   return model;	
	}
	@RequestMapping(value="msgListAjax.do")
	public ModelAndView selectMsgInfoManageListAjax (@ModelAttribute("loginVO") LoginVO loginVO
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
				
			    List<Map<String, Object>> list =  msgService.selectMsgManageListByPagination(searchVO);   	
			    int totCnt = list.size() > 0 ?  Integer.valueOf( list.get(0).get("total_record_count").toString()) :0;
			    paginationInfo.setTotalRecordCount(totCnt);
			    LOGGER.debug("page check:" + paginationInfo.getCurrentPageNo() + ":"+ paginationInfo.getTotalPageCount() );
			    model.addObject(Globals.JSON_PAGEINFO,   paginationInfo);
			    model.addObject(Globals.JSON_RETURN_RESULTLISR,   list);
			    model.addObject(Globals.PAGE_TOTALCNT,   totCnt);
			    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			      
		    }catch(Exception e){
		    	LOGGER.error("selectMsgInfoManageListAjax ERROR:"  + e.toString());
		    	model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
		    }
		    return model;
	}
	@RequestMapping (value="msgDetail.do")
	public ModelAndView selecMsgInfoManageDetail(@ModelAttribute("loginVO") LoginVO loginVO
                                                  ,  @RequestParam("seqno") String seqno  
                                                  , HttpServletRequest request
                                    			  , BindingResult bindingResult ) throws Exception{	
		
			ModelAndView model = new ModelAndView(Globals.JSONVIEW);
			try{
				Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
				 if(!isAuthenticated) {
						model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
						model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
						return model;	
			    }
				model.addObject(Globals.STATUS,  Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_REGINFO, msgService.selectMsgManageDetail(seqno));	    
			}catch(Exception e){
				LOGGER.error("selectMsgInfoManageListAjax ERROR:"  + e.toString());
		    	model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			}
			
			return model;
	}
	@RequestMapping (value="msgDelete.do")
	public ModelAndView deletemsgInfoManage(@ModelAttribute("loginVO") LoginVO loginVO,
			                                @RequestParam("seqno") String seqno   ) throws Exception {
		
			ModelAndView model = new ModelAndView(Globals.JSONVIEW);
			try{
				 Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
				 if(!isAuthenticated) {
						model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
						model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
						return model;	
			     }
				 
			     int ret = 	msgService.deleteMsgManage(seqno);		      
			      if (ret > 0 ) {		    	  
			    	     model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
						model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));
			      }else {
			    	  throw new Exception();		    	  
			      }
			}catch (Exception e){
				LOGGER.info(e.toString());
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
			}		
			return model;
	}
	@RequestMapping (value="msgTestUpdate.do")
	public ModelAndView testMsgInsert(@RequestBody Map<String, Object> vo) throws Exception{
		
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		
		String step = "{step=U, sendCnt=, from=20211117, to=20211118}";
		String sendArray = "[{\"groupGubun\":\"S\",\"groupCode\":\"사용자_1<010>\"},{\"groupGubun\":\"S\",\"groupCode\":\"사용자4<3>\"},{\"groupGubun\":\"S\",\"groupCode\":\"test<010-0000-0000>\"},{\"groupGubun\":\"S\",\"groupCode\":\"01058743877\"},{\"groupGubun\":\"G\",\"groupCode\":\"MSG_00000001\"},{\"groupGubun\":\"G\",\"groupCode\":\"MSG_00000000\"}]";
		
				
		List<MessageInfo> info =  new ArrayList<MessageInfo>() ;
		
	    LOGGER.debug("sendArray:" + sendArray.replace("=",":"));		 

	    
	   
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
					model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
					return model;	
		    }
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    	String userNm = loginVO.getEmpNm();
			
			if (!SmartUtil.NVL(vo.get("msgArray"), "").toString().equals("")) {
				//지점 담당자 메세지 보내기
				Map<String, String> hMapData = new HashMap<String, String>();
		        
				HashMap<String, String> map = (HashMap<String, String>) Arrays.asList(step.split(","))
						                .stream()
						                .map(s -> s.split(":"))
						                .collect(Collectors.toMap(e -> e[0], e -> e[1]));
				
				
				
				
				
				/*
				String[] pairs = step.split(",");
				for (int i=0;i<pairs.length;i++) {
				    String pair = pairs[i];
				    String[] keyValue = pair.split(":");
				    hMapData.put(keyValue[0], keyValue[1]);
				}
				*/
				MessageInfo msgInfo = new MessageInfo();
				if (hMapData.get("step").equals("U")) {
					Map<String, Object>  searchVO_U = new HashMap<String, Object>();
					searchVO_U.put("firstIndex", 0);
					searchVO_U.put("recordCountPerPage", 1000);
					searchVO_U.put("searchCenter", SmartUtil.NVL(vo.get("searchCenter"), "").toString());
					searchVO_U.put("searchFrom",  SmartUtil.NVL(vo.get("from"), "").toString());
					searchVO_U.put("searchTo",  SmartUtil.NVL(vo.get("to"), "").toString());
					
					List<Map<String, Object>>  userInfo = resService.selectResInfoManageListByPagination(searchVO_U);
					
					userInfo.forEach(x->{
				   		 msgInfo.setCallname(x.get("user_nm").toString());
					   	 msgInfo.setCallphone(x.get("user_phone").toString());
					   	 info.add(msgInfo);
				   	 });
					
					searchVO_U =  null;
				}else {
					Map<String, Object>  searchVO_A = new HashMap<String, Object>();
					searchVO_A.put("firstIndex", 0);
					searchVO_A.put("recordCountPerPage", 1000);
					searchVO_A.put("searchCenter", SmartUtil.NVL(vo.get("searchCenter"), "").toString());
					
					List<Map<String, Object>> adminInfos = adminService.selectAdminUserManageListByPagination(searchVO_A);
					
					adminInfos.forEach(x->{
				   		 msgInfo.setCallname(x.get("emp_nm").toString());
					   	 msgInfo.setCallphone(x.get("emp_clphn").toString());
					   	 info.add(msgInfo);
				   	 });
					
					searchVO_A =  null;
					adminInfos = null;
				}
				
				
			}
			if (!SmartUtil.NVL(vo.get("sendArray"), "").toString().equals("")) {
				
				JSONParser parser = new JSONParser();
				JSONArray arrays = (JSONArray)parser.parse(sendArray);
				
				Map<String, Object>  searchVO = new HashMap<String, Object>();
				
				searchVO.put("firstIndex", 0);
				searchVO.put("recordCountPerPage", 1000);
				
				
			    for (int i = 0; i < arrays.size(); i ++) {
			    	MessageInfo msgInfo = new MessageInfo();
				    JSONObject jsonObject =  (JSONObject)arrays.get(i);
				    LOGGER.debug("groupGubun:" + jsonObject.get("groupGubun"));
				    if (jsonObject.get("groupGubun").equals("S")) {
				   	 //사용자 이면
				    	 if (jsonObject.get("groupCode").toString().contains("<")) {
				    		 String [] callInfo  = jsonObject.get("groupCode").toString().split("<");
						   	 msgInfo.setCallname(callInfo[0]);
						   	 msgInfo.setCallphone(callInfo[1].replace(">", ""));
				    	 }else {
				    		 msgInfo.setCallname(jsonObject.get("groupCode").toString());
				    	 }
				    	 info.add(msgInfo);
				    }else {
				    	 searchVO.put("searchGroupCode", jsonObject.get("groupCode"));
					   	 LOGGER.debug("groupCode:" + searchVO);
					   	 List<Map<String, Object>> groupInfo = msgGroupUserService.selectMessageGroupUserInfoList(searchVO);
					   	 
					   	 groupInfo.forEach(x->{
					   		 msgInfo.setCallname(x.get("group_username").toString());
						   	 msgInfo.setCallphone(x.get("group_user_cellphone").toString());
						   	 info.add(msgInfo);
					   	 });
				     }
			    }                
			}
			//insert 하기 
			
			
			String reqtime = vo.get("result").toString().equals("O") ? "00000000000000" : vo.get("sendDate").toString()+vo.get("send_hour").toString()+vo.get("send_minute").toString()+"00";
					
			String kind =   vo.get("sendDate").toString().equals("mms Send") ? "M" : "S";
			
			info.forEach(MessageInfo -> {
				        MessageInfo.setReqname(loginVO.getDeptNm());
				        MessageInfo.setReqphone(vo.get("sendTel").toString());
				        MessageInfo.setResult(vo.get("result").toString());
				        MessageInfo.setReqtime(reqtime);
				        MessageInfo.setKind(kind);
				        MessageInfo.setMsg(vo.get("Message").toString());
			});
			
			msgService.insertMsgManage(info);
   	        model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.insert"));
			
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return model;
	}
	
	
	
	@RequestMapping (value="msgUpdate.do")
	public ModelAndView updatemsgInfoManage( @ModelAttribute("loginVO") LoginVO loginVO
											 , @RequestBody Map<String, Object> vo	                				 
											 , BindingResult result) throws Exception{
		
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		String meesage = null;
		try{
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
					model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
					return model;	
		    }
			List<MessageInfo> info =  new ArrayList<MessageInfo>() ;
			loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    	String userNm = loginVO.getEmpNm();
			
			if (!SmartUtil.NVL(vo.get("msgArray"), "").toString().equals("\"\"")) {
				//지점 담당자 메세지 보내기
				LOGGER.debug("step:" + SmartUtil.NVL(vo.get("msgArray"), "").toString());
				Map<String, String> hMapData = new HashMap<String, String>();
		        
				HashMap<String, String> map = (HashMap<String, String>) Arrays.asList(SmartUtil.NVL(vo.get("msgArray"), "").toString().split(","))
						                .stream()
						                .map(s -> s.split(":"))
						                .collect(Collectors.toMap(e -> e[0], e -> e[1]));
				MessageInfo msgInfo = new MessageInfo();
				if (map.size() > 0) {
					if (hMapData.get("step").equals("U")) {
						Map<String, Object>  searchVO_U = new HashMap<String, Object>();
						searchVO_U.put("firstIndex", 0);
						searchVO_U.put("recordCountPerPage", 1000);
						searchVO_U.put("searchCenter", SmartUtil.NVL(vo.get("searchCenter"), "").toString());
						searchVO_U.put("searchFrom",  SmartUtil.NVL(vo.get("from"), "").toString());
						searchVO_U.put("searchTo",  SmartUtil.NVL(vo.get("to"), "").toString());
						
						List<Map<String, Object>>  userInfo = resService.selectResInfoManageListByPagination(searchVO_U);
						
						userInfo.forEach(x->{
					   		 msgInfo.setCallname(x.get("user_nm").toString());
						   	 msgInfo.setCallphone(x.get("user_phone").toString());
						   	 info.add(msgInfo);
					   	 });
						
						searchVO_U =  null;
					}else {
						Map<String, Object>  searchVO_A = new HashMap<String, Object>();
						searchVO_A.put("firstIndex", 0);
						searchVO_A.put("recordCountPerPage", 1000);
						searchVO_A.put("searchCenter", SmartUtil.NVL(vo.get("searchCenter"), "").toString());
						
						List<Map<String, Object>> adminInfos = adminService.selectAdminUserManageListByPagination(searchVO_A);
						
						adminInfos.forEach(x->{
					   		 msgInfo.setCallname(x.get("emp_nm").toString());
						   	 msgInfo.setCallphone(x.get("emp_clphn").toString());
						   	 info.add(msgInfo);
					   	 });
						
						searchVO_A =  null;
						adminInfos = null;
					}
						
				}
			}
			if (!SmartUtil.NVL(vo.get("sendArray"), "").toString().equals("")) {
				
				JSONParser parser = new JSONParser();
				JSONArray arrays = (JSONArray)parser.parse(vo.get("sendArray").toString());
				
				Map<String, Object>  searchVO = new HashMap<String, Object>();
				
				searchVO.put("firstIndex", 0);
				searchVO.put("recordCountPerPage", 1000);
				
				
			    for (int i = 0; i < arrays.size(); i ++) {
			    	MessageInfo msgInfo = new MessageInfo();
				    JSONObject jsonObject =  (JSONObject)arrays.get(i);
				    LOGGER.debug("groupGubun:" + jsonObject.get("groupGubun"));
				    if (jsonObject.get("groupGubun").equals("S")) {
				   	 //사용자 이면
				    	 if (jsonObject.get("groupCode").toString().contains("<")) {
				    		 String [] callInfo  = jsonObject.get("groupCode").toString().split("<");
						   	 msgInfo.setCallname(callInfo[0]);
						   	 msgInfo.setCallphone(callInfo[1].replace(">", ""));
				    	 }else {
				    		 msgInfo.setCallname(jsonObject.get("groupCode").toString());
				    	 }
				    	 info.add(msgInfo);
				    }else {
				    	 searchVO.put("searchGroupCode", jsonObject.get("groupCode"));
					   	 LOGGER.debug("groupCode:" + searchVO);
					   	 List<Map<String, Object>> groupInfo = msgGroupUserService.selectMessageGroupUserInfoList(searchVO);
					   	 
					   	 groupInfo.forEach(x->{
					   		 msgInfo.setCallname(x.get("group_username").toString());
						   	 msgInfo.setCallphone(x.get("group_user_cellphone").toString());
						   	 info.add(msgInfo);
					   	 });
				     }
			    }                
			}
			//insert 하기 
			
			
			String reqtime = vo.get("result").toString().equals("O") ? "00000000000000" : vo.get("sendDate").toString()+vo.get("send_hour").toString()+vo.get("send_minute").toString()+"00";
					
			String kind =   vo.get("sendDate").toString().equals("mms Send") ? "M" : "S";
			
			info.forEach(MessageInfo -> {
				        MessageInfo.setReqname(userNm);
				        MessageInfo.setReqphone(vo.get("sendTel").toString());
				        MessageInfo.setResult(vo.get("result").toString());
				        MessageInfo.setReqtime(reqtime);
				        MessageInfo.setKind(kind);
				        MessageInfo.setMsg(vo.get("Message").toString());
			});
			
			msgService.insertMsgManage(info);
   	        model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.insert"));
				
			
		}catch (Exception e){
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			LOGGER.info("e:" + e.toString() + ":" + lineNumber);
			meesage = "fail.common.insert";
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));			
		}
		return model;
	}
	
	
	
}
