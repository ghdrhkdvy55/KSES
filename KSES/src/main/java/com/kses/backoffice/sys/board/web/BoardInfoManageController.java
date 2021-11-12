package com.kses.backoffice.sys.board.web;

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
import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.sys.board.service.BoardInfoManageService;
import com.kses.backoffice.sys.board.service.BoardSetInfoManageService;
import com.kses.backoffice.sys.board.vo.BoardSetInfo;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;
import com.kses.backoffice.util.service.fileService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/sys")
public class BoardInfoManageController {

	    private static final Logger LOGGER = LoggerFactory.getLogger(BoardInfoManageController.class);
		
		//파일 업로드	
	    @Autowired
	    private fileService uploadFile;
		
		@Autowired
	    protected EgovCcmCmmnDetailCodeManageService egovCodeDetailService;
		
		@Autowired
	    protected BoardInfoManageService boardInfoService;
		
		@Autowired
	    protected BoardSetInfoManageService boardSetService;
		
	
		@Autowired
		private UniSelectInfoManageService uniService;
		
		@Autowired
		protected EgovMessageSource egovMessageSource;
		
		@Autowired
	    protected EgovPropertyService propertiesService;
		
		@Autowired
		private EgovCcmCmmnDetailCodeManageService codeDetailService;
		
		@Autowired
		private AuthInfoService authService;
		
		@RequestMapping(value="boardSetList.do")
		public ModelAndView  selectBoardSetInfoManageList(@ModelAttribute("loginVO") LoginVO loginVO
														  , HttpServletRequest request
														  , BindingResult bindingResult) throws Exception {
			
			ModelAndView model = new ModelAndView("/backoffice/sys/boardSetList");
			
			try{
				  Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			      if(!isAuthenticated) {
		    	    model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
		    	    model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
		    	    model.setViewName("backoffice/login");
		    		return model;
			      }
			      model.addObject("boardNotice", codeDetailService.selectCmmnDetailCombo("BOARD_NOTICE"));
			      model.addObject("boardGubun", codeDetailService.selectCmmnDetailCombo("BOARD_GUBUN"));
			      model.addObject("boardSize", codeDetailService.selectCmmnDetailCombo("BOARD_SIZE"));
			      
			      model.addObject("authorInfo", authService.selectAuthInfoComboList());
			      
			}catch (Exception e){
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject("message", egovMessageSource.getMessage("fail.common.list"));
				LOGGER.info(e.toString());
			}			   
			return model;	
		}
		
		@RequestMapping(value="boardSetListAjax.do")
		public ModelAndView  selectBoardSetAjaxListByPagination(@ModelAttribute("loginVO") LoginVO loginVO
																, @RequestBody Map<String,Object>  searchVO
																, HttpServletRequest request
																, BindingResult bindingResult) throws Exception {
			
			ModelAndView model = new ModelAndView(Globals.JSONVIEW);
			
			try{
				
				/*
				 * if (!request.getHeader("REFERER").contains("/web")) { Boolean isAuthenticated
				 * = EgovUserDetailsHelper.isAuthenticated(); if(!isAuthenticated) {
				 * model.addObject(Globals.STATUS_MESSAGE,
				 * egovMessageSource.getMessage("fail.common.login"));
				 * model.setViewName("/backoffice/login"); return model; } }
				 */
				 
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
				
				List<Map<String, Object>> list =  boardSetService.selectBoardSettingInfoList(searchVO);
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
		@RequestMapping(value="boardSetListDetail.do")
		public ModelAndView selectBoardSetDetail (@ModelAttribute("LoginVO") LoginVO loginVO, 
												  @RequestParam("boardCd") String boardCd, 
												  HttpServletRequest request, 
												  BindingResult bindingResult) throws Exception {
			
			ModelAndView model = new ModelAndView(Globals.JSONVIEW);
			try {
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_REGINFO, boardSetService.selectBoardSettingInfoDetail(boardCd));		    	 
			} catch (Exception e) {
				LOGGER.info(e.toString());
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));			
			}	
			return model;			
		}	
		@RequestMapping(value="boadCdCheck.do")
		public ModelAndView selectadminIdCheckManger(@RequestParam("boardCd") String boardCd) throws Exception {
			ModelAndView model = new ModelAndView(Globals.JSONVIEW);
			try {
				
				
				int IDCheck = uniService.selectIdDoubleCheck("BOARD_CD", "TSES_BRDSET_INFO_M", " BOARD_CD = ["+ boardCd + "[" );
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
		@RequestMapping (value="boardSetUpdate.do")
		public ModelAndView boardSetUpdate(@RequestBody BoardSetInfo info 
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
				 
				 int ret = boardSetService.updateBoardSetInfo(info); 
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
		/**
		 * 직원 정보 삭제
		 * 
		 * @param loginVO
		 * @param empno
		 * @param request
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value="boardSetDelete.do")
		public ModelAndView deleteBoardSetInfo(@RequestParam("delCd") String delCd,  
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
					
					boolean delCheck = boardSetService.deleteBoardSetInfo(delCd);
					
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
		
		
//		@NoLogging
//		@RequestMapping (value="boardVisited.do")
//		public ModelAndView selectBoardVisited(@ModelAttribute("loginVO") LoginVO loginVO
//													 	  , @RequestBody Map<String,Object>  boardInfo
//											              , HttpServletRequest request
//											   			  , BindingResult bindingResult ) throws Exception{	
//			
//			ModelAndView model = new ModelAndView(Globals.JSONVIEW);
//			
//			try{
//				LOGGER.debug("boardInfo:" + boardInfo.get("boardSeq"));
//				
//				boardInfoService.updateBoardVisitedManage(boardInfo.get("boardSeq").toString() );
//			    model.addObject(Globals.STATUS_REGINFO, boardInfoService.selectBoardManageView(boardInfo.get("boardSeq").toString()));
//			    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//			    
//			}catch(Exception e){
//				LOGGER.info("e:"+ e.toString());	
//				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
//			}
//			return model;
//		}
//		@NoLogging
//		@RequestMapping (value="boardView.do")
//		public ModelAndView selectBoardViewInfoManageDetail(@ModelAttribute("loginVO") LoginVO loginVO
//													 	  , @RequestBody Map<String,Object>  boardInfo
//											              , HttpServletRequest request
//											   			  , BindingResult bindingResult ) throws Exception{	
//			
//			ModelAndView model = new ModelAndView(Globals.JSONVIEW);
//			
//			try{
//				Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
//			    if(!isAuthenticated) {
//						model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
//						model.setViewName("/backoffice/login");
//						return model;
//			    }
//			    model.addObject(Globals.STATUS_REGINFO, boardInfoService.selectBoardManageView(boardInfo.get("boardSeq").toString()));
//			    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//			    
//			}catch(Exception e){
//				LOGGER.info("e:"+ e.toString());	
//			}
//			return model;
//		}
//		@NoLogging
//		@RequestMapping (value="boardDelete.do")
//		public ModelAndView deleteBoardInfoManage(@ModelAttribute("loginVO") LoginVO loginVO
//				                                 , @RequestParam("boardSeq") String boardSeq)throws Exception{
//			
//			ModelAndView model = new ModelAndView(Globals.JSONVIEW);
//			String returnMessage = "F";
//			try{
//				Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
//			    if(!isAuthenticated) {
//						model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
//						model.setViewName("/backoffice/login");
//						return model;
//			    }
//			    
//				int ret = 	boardInfoService.deleteBoardManage(boardSeq);		      
//			    if (ret > 0 ) {		    	  
//			   	  model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//			    }else {
//			    	model.addObject(Globals.STATUS, Globals.STATUS_FAIL);	    	  
//			    }
//			}catch (Exception e){
//				LOGGER.info(e.toString());
//				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);	
//				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
//				
//			}					
//			return model;
//		}		
//		@NoLogging
//		@RequestMapping (value="boardUpdate.do")
//		public ModelAndView updateboardInfoManage(HttpServletRequest request, MultipartRequest mRequest
//											      , @ModelAttribute("LoginVO") LoginVO loginVO
//											      , @ModelAttribute("BoardInfo") BoardInfo vo
//											      , BindingResult result) throws Exception{
//			
//			ModelAndView model = new ModelAndView(Globals.JSONVIEW);
//			try {
//				Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
//			    if(!isAuthenticated) {
//						model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
//						model.setViewName("/backoffice/login");
//						return model;
//			    }
//				
//				if(vo.getBoardGubun().equals("NOT") ||  vo.getBoardNoticeUseyn() != null ||  vo.getBoardNoticeUseyn().equals("Y")){
//						int top = boardInfoService.updateBoardTopSeq();
//				}
//				
//				
//				vo.setBoardFile01( uploadFile.uploadFileNm(mRequest.getFiles("boardFile01"), propertiesService.getString("Globals.filePath")));
//				vo.setBoardTopSeq("0");
//			 	String meesage = vo.getMode().equals("Ins") ?  "sucess.common.insert" :  "sucess.common.update";
//				vo.setUserId(EgovUserDetailsHelper.getAuthenticatedUser().toString());
//				int ret = boardInfoService.updateBoardManage(vo);
//				LOGGER.debug("--------------------------------------------------------2");
//				if (ret >0){
//					model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
//				}else {
//					throw new Exception();
//				}
//			}catch(Exception e) {
//				LOGGER.info(e.toString());
//				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);	
//				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
//			}
//			LOGGER.debug("--------------------------------------------------------3");
//			return model;
//		}
//		
//		
//		@RequestMapping(value="boardPreview.do")
//		public String selectBoardPreview (@ModelAttribute("loginVO") EmpInfo loginVO
//										  , @ModelAttribute("searchVO") ReservationInfo searchVO
//										  , HttpServletRequest request
//										  , BindingResult bindingResult						
//										  , ModelMap model) throws Exception {
//			
//			return "/backoffice/boardManage/boardPreview";
//		}
//		
//		@RequestMapping(value="fileDownload.do")
//		public ModelAndView callDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
//			
//			File downloadFile;
//			Map<String, Object> allData = new HashMap<String, Object>();
//			String filePath = propertiesService.getString("Globals.fileStorePath");
//			String boardSeq = request.getParameter("boardSeq");
//			String uploadFileName = boardInfoService.selectBoardUploadFileName(boardSeq);
//			String originalFileName = boardInfoService.selectBoardoriginalFileName(boardSeq);
//			downloadFile = new File(filePath+uploadFileName);
//
//			try{
//			    if(!downloadFile.canRead()){
//			    	LOGGER.info("FILE DOWNLOAD IN CHECK ERROR!!!");
//			        throw new Exception("File can't read(파일을 찾을 수 없습니다)");
//			    }else{
//			    	downloadFile = new File(downloadFile.getParent(), uploadFileName);
//			    	
//			    	allData.put("downloadFile", downloadFile);
//			    	allData.put("originalName", originalFileName);
//			    }
//			}catch(Exception e){
//				LOGGER.info(e.toString());
//				e.printStackTrace();
//			}
//
//		    return new ModelAndView("FileDownloadView", "allData",allData);
//		}
}
