package com.kses.backoffice.sys.board.web;

import java.util.HashMap;
import java.util.Iterator;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.authority.service.AuthInfoService;
import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.sys.board.service.BoardInfoManageService;
import com.kses.backoffice.sys.board.service.BoardSetInfoManageService;
import com.kses.backoffice.sys.board.vo.BoardInfo;
import com.kses.backoffice.sys.board.vo.BoardSetInfo;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;
import com.kses.backoffice.util.service.fileService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.FileVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/backoffice/sys")
public class BoardInfoManageController {
	
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

	@Autowired
	private EgovFileMngUtil fileUtil;
	
	@Autowired
	private EgovFileMngService egocFileService;
		
	/**
	 * 게시판 관리 화면 이동
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="boardSetList.do", method = RequestMethod.GET)
	public ModelAndView viewBoardSetList() throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/sys/boardSetList");
		model.addObject("boardNotice", codeDetailService.selectCmmnDetailCombo("BOARD_NOTICE"));
		model.addObject("boardGubun", codeDetailService.selectCmmnDetailCombo("BOARD_GUBUN"));
		model.addObject("boardSize", codeDetailService.selectCmmnDetailCombo("BOARD_SIZE"));
		model.addObject("authorInfo", authService.selectAuthInfoComboList());
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
			  
			log.debug("searchVO" + searchVO.get("adminYn"));
			
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
			log.info(e.toString());
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
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));			
		}	
		return model;			
	}	
	@RequestMapping(value="boadCdCheck.do")
	public ModelAndView boadCdCheck(@RequestParam("boardCd") String boardCd) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			
			
			int IDCheck = uniService.selectIdDoubleCheck("BOARD_CD", "TSES_BRDSET_INFO_M", " BOARD_CD = ["+ boardCd + "[" );
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
			 log.debug("ret:"  + ret);
			 meesage = (info.getMode().equals(Globals.SAVE_MODE_INSERT)) ? "sucess.common.insert" : "sucess.common.update";
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
			meesage = (info.getMode().equals(Globals.SAVE_MODE_INSERT)) ? "fail.common.insert" : "fail.common.update";
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));			
		}
		return model;
	}
	
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
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}	
		return model;
	}
	
	/**
	 * 게시판 화면
	 * - Not: 공지사항
	 * - Not01: 사용자게시판
	 * @param boardCd
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="boardList.do", method = RequestMethod.GET)
	public ModelAndView viewBoardList(@RequestParam("boardCd") String boardCd) throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/sys/boardList");
		model.addObject(Globals.STATUS_REGINFO, boardSetService.selectBoardSettingInfoDetail(boardCd));
		return model;	
	}
	
	@RequestMapping(value="boardListAjax.do")
	public ModelAndView  selectBoardAjaxInfoManageListByPagination(@ModelAttribute("loginVO") LoginVO loginVO
																	, @RequestBody Map<String,Object>  searchVO
																	, HttpServletRequest request
																	, BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try{
			
			log.info("getContextPath:" + request.getHeader("REFERER")); 
			  
			  
			  if (!request.getHeader("REFERER").contains("/web")) {
				  Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			      if(!isAuthenticated) {
						model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
						model.setViewName("/backoffice/login");
						return model;
			      } 
			  }
			  
			  
			  
			  
		      
		     int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			 
			 searchVO.put("pageSize", propertiesService.getInt("pageSize"));
			 log.info("pageUnit:" + pageUnit);
			 
		             
		   	 PaginationInfo paginationInfo = new PaginationInfo();
			 paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
			 paginationInfo.setRecordCountPerPage(pageUnit);
			 paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
			 searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
			 searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
			 searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
			 
			 //사용자 계정 정리 
			 loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			 searchVO.put("authorCd", loginVO.getAuthorCd());
			 searchVO.put("centerCd", loginVO.getCenterCd());
			  
			  
			  
			  
			 log.debug("searchVO" + searchVO.get("adminYn"));
			  
			  List<Map<String, Object>> list =  boardInfoService.selectBoardManageListByPagination(searchVO) ;
			  int totCnt = list.size() > 0 ?  Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		      
			  model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
			  model.addObject(Globals.PAGE_TOTALCNT, totCnt);
			  paginationInfo.setTotalRecordCount(totCnt);
			  model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
			  model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			 
		}catch (Exception e){
			  model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			  model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.list"));
			  log.info(e.toString());
		}			   
		return model;	
	}
	
	
	@NoLogging
	@RequestMapping (value="boardVisited.do")
	public ModelAndView selectBoardVisited(@ModelAttribute("loginVO") LoginVO loginVO
									 	   , @RequestParam("boardSeq") String boardSeq
							               , HttpServletRequest request
							   			   , BindingResult bindingResult ) throws Exception{	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try{
			
			boardInfoService.updateBoardVisitedManage(boardSeq );
		    model.addObject(Globals.STATUS_REGINFO, boardInfoService.selectBoardManageDetail(boardSeq));
		    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		    
		}catch(Exception e){
			log.info("e:"+ e.toString());	
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
		}
		return model;
	}
	
	@RequestMapping (value="boardView.do")
	public ModelAndView selectBoardViewInfoManageDetail(@ModelAttribute("loginVO") LoginVO loginVO
												 	  , @RequestParam("boardSeq") String boardSeq
										              , HttpServletRequest request
										   			  , BindingResult bindingResult ) throws Exception{	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try{
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		    if(!isAuthenticated) {
					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
					model.setViewName("/backoffice/login");
					return model;
		    }
		    model.addObject(Globals.STATUS_REGINFO, boardInfoService.selectBoardManageDetail(boardSeq));
		    Map<String, Object> search = new HashMap<String, Object>();
		    search.put("fileGubun", "BBS");
		    search.put("fileSeq",boardSeq);
		    model.addObject(Globals.JSON_RETURN_RESULTLISR, egocFileService.selectFileInfs(search));
		    
		    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		    
		}catch(Exception e){
			log.info("e:"+ e.toString());	
		}
		return model;
	}
	
	@RequestMapping (value="boardDelete.do")
	public ModelAndView deleteBoardInfoManage(@ModelAttribute("loginVO") LoginVO loginVO
			                                 , @RequestParam("boardSeq") String boardSeq)throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		String returnMessage = "F";
		try{
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		    if(!isAuthenticated) {
					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
					model.setViewName("/backoffice/login");
					return model;
		    }
		    
			int ret = 	boardInfoService.deleteBoardManage(boardSeq);		      
		    if (ret > 0 ) {		    	  
		   	  model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		    }else {
		    	model.addObject(Globals.STATUS, Globals.STATUS_FAIL);	    	  
		    }
		}catch (Exception e){
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);	
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
			
		}					
		return model;
	}	
	@RequestMapping (value="boardFileDelete.do")
	public ModelAndView deleteBoardFileInfoManage(@ModelAttribute("loginVO") LoginVO loginVO
                                              , @RequestParam("fileSeqs") String fileSeqs)throws Exception{

		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		String returnMessage = "F";
		try{
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
			return model;
			}
			List<String> streFiles = SmartUtil.dotToList(fileSeqs);
			
			for (String strFile : streFiles) {
				uniService.deleteUniStatement("STRE_FILE_NM", "COMTNFILEDETAIL", "STRE_FILE_NM=["+strFile+"[");
			}
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		}catch (Exception e){
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);	
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
		}					
		return model;
	}
	
	
	@RequestMapping (value="boardUpdate.do")
	public ModelAndView updateboardInfoManage(@ModelAttribute("LoginVO") LoginVO loginVO
			                                  , HttpServletRequest request
			                                  , MultipartRequest mRequest
										      , @ModelAttribute("BoardInfo") BoardInfo vo
										      , BindingResult result) throws Exception{
		
		
		//파일 업로드 테스트 
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		    if(!isAuthenticated) {
					model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
					model.setViewName("/backoffice/login");
					return model;
		    }
		    
			
		    loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		    List<FileVO> _result = null;
		    Iterator itr = mRequest.getFileNames();
		   if (itr.hasNext() ) {
	    		List<MultipartFile> file_list = mRequest.getFiles( (String) itr.next());  
	    		log.debug("====================================== 4");
			    if (file_list.size() > 0 ) {
			    	_result = fileUtil.parseFileKSESInf(mRequest.getFileNames(), mRequest, "BBS_", 0,  propertiesService.getString("Globals.filePath"));
			    }
	    	}
			
		    vo.setBoardTopSeq("0");
		 	String meesage = vo.getMode().equals(Globals.SAVE_MODE_INSERT) ?  "sucess.common.insert" :  "sucess.common.update";
			vo.setUserId(loginVO.getAdminId());
			int ret = boardInfoService.updateBoardManage(vo, _result) ;
			if (ret >0){
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			}else {
				throw new Exception();
			}
		}catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			int lineNumber = ste[0].getLineNumber();
			log.info("e:" + e.toString() + ":" + lineNumber);
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);	
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		
		return model;
	}
	
	
	@RequestMapping(value="boardPreview.do")
	public String selectBoardPreview (@ModelAttribute("loginVO") LoginVO loginVO
									  , @RequestParam("boardSeq") String boardSeq
									  , HttpServletRequest request
									  , BindingResult bindingResult	) throws Exception {
		
		return "/backoffice/boardManage/boardPreview";
	}
	/*
	@RequestMapping(value="fileDownload.do")
	public ModelAndView callDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		File downloadFile;
		Map<String, Object> allData = new HashMap<String, Object>();
		String filePath = propertiesService.getString("Globals.fileStorePath");
		String boardSeq = request.getParameter("boardSeq");
		String uploadFileName = boardInfoService.selectBoardUploadFileName(boardSeq);
		String originalFileName = boardInfoService.selectBoardoriginalFileName(boardSeq);
		downloadFile = new File(filePath+uploadFileName);

		try{
		    if(!downloadFile.canRead()){
		    	LOGGER.info("FILE DOWNLOAD IN CHECK ERROR!!!");
		        throw new Exception("File can't read(파일을 찾을 수 없습니다)");
		    }else{
		    	downloadFile = new File(downloadFile.getParent(), uploadFileName);
		    	
		    	allData.put("downloadFile", downloadFile);
		    	allData.put("originalName", originalFileName);
		    }
		}catch(Exception e){
			LOGGER.info(e.toString());
			e.printStackTrace();
		}

	    return new ModelAndView("FileDownloadView", "allData",allData);
	}
	*/
}
