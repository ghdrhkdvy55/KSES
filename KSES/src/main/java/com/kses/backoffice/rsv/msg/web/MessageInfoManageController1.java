package com.kses.backoffice.rsv.msg.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import com.kses.backoffice.rsv.msg.service.MessageInfoManageService1;
import com.kses.backoffice.rsv.msg.vo.MessageInfo1;
import com.kses.backoffice.rsv.msg.vo.MessageInfoVO1;
import com.kses.backoffice.sym.log.annotation.NoLogging;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/bas")
public class MessageInfoManageController1 {
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;

	@Autowired
    protected MessageInfoManageService1 msgService;
		
	@Autowired
    protected EgovCcmCmmnDetailCodeManageService egovCodeDetailService;
	
	EgovStringUtil util = new EgovStringUtil();
	
	/**
	 * 메시지전송현황 관리
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="msgList.do", method = RequestMethod.GET)
	public ModelAndView  viewMsgList() throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/bas/msgList");
		model.addObject("selectMsgGubun", egovCodeDetailService.selectCmmnDetailCombo("MSG_TYPE"));
		return model;	
	}
	
	@RequestMapping(value="msgListAjax.do")
	public ModelAndView selectMsgInfoManageListAjax (@ModelAttribute("loginVO") LoginVO loginVO
																				, @RequestBody MessageInfoVO1 searchVO
																				, HttpServletRequest request
																				, BindingResult bindingResult) throws Exception {
		
		    ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		    try{
		    	 if(  searchVO.getPageUnit() > 0  ){    	   
			    	   searchVO.setPageUnit(searchVO.getPageUnit());
				  }else {
						   searchVO.setPageUnit(propertiesService.getInt(Globals.PAGE_UNIT));   
				  }
				  searchVO.setPageSize(propertiesService.getInt(Globals.PAGE_SIZE));
			       /** pageing */       
			   	  PaginationInfo paginationInfo = new PaginationInfo();
				  paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
				  paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
				  paginationInfo.setPageSize(searchVO.getPageSize());
		
				  searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
				  searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
				  //수정
				  searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage()); 
			      List<Map<String, Object>> list =  msgService.selectMsgManageListByPagination(searchVO);   	
			      int totCnt = list.size() > 0 ?  Integer.valueOf( list.get(0).get("total_record_count").toString()) :0;
			      paginationInfo.setTotalRecordCount(totCnt);
			      log.debug("page check:" + paginationInfo.getCurrentPageNo() + ":"+ paginationInfo.getTotalPageCount() );
			      model.addObject(Globals.JSON_PAGEINFO,   paginationInfo);
			      model.addObject(Globals.JSON_RETURN_RESULTLISR,   list);
			      model.addObject(Globals.PAGE_TOTALCNT,   totCnt);
			      model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			      
		    }catch(Exception e){
		    	log.error("selectMsgInfoManageListAjax ERROR:"  + e.toString());
		    	model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
		    }
		    return model;
	}
	@RequestMapping (value="msgDetail.do")
	public ModelAndView selecMsgInfoManageDetail(@ModelAttribute("loginVO") LoginVO loginVO
			                                                          ,  @RequestParam("msgSeq") String msgSeq  
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
				model.addObject(Globals.STATUS_REGINFO, msgService.selectMsgManageDetail(msgSeq));	    
			}catch(Exception e){
				log.error("selectMsgInfoManageListAjax ERROR:"  + e.toString());
		    	model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			}
			
			return model;
	}
	@RequestMapping (value="msgDelete.do")
	public ModelAndView deletemsgInfoManage(@ModelAttribute("loginVO") LoginVO loginVO,
			                                                       @RequestParam("msgSeq") String msgSeq   ) throws Exception {
		
			ModelAndView model = new ModelAndView(Globals.JSONVIEW);
			try{
				 Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
				 if(!isAuthenticated) {
						model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
						model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
						return model;	
			     }
				 
			     int ret = 	msgService.deleteMsgManage(msgSeq);		      
			      if (ret > 0 ) {		    	  
			    	     model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
						model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));
			      }else {
			    	  throw new Exception();		    	  
			      }
			}catch (Exception e){
				log.info(e.toString());
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
			}		
			return model;
	}
	@RequestMapping (value="msgUpdate.do")
	public ModelAndView updatemsgInfoManage( @ModelAttribute("loginVO") LoginVO loginVO,
																	 @RequestBody MessageInfo1 vo	                				 
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
			 
			int ret  = msgService.updateMsgManage(vo);
			meesage = (vo.getMode().equals(Globals.SAVE_MODE_INSERT)) ? "sucess.common.insert" : "sucess.common.update";
			if (ret >0){
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
						
			}else {
				throw new Exception();
			}
		}catch (Exception e){
			meesage = (vo.getMode().equals(Globals.SAVE_MODE_INSERT)) ? "fail.common.insert" : "fail.common.update";
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));			
		}
		return model;
	}
	
	
}
