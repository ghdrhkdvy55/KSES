package com.kses.backoffice.sys.board.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.FileVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/sys")
public class BoardInfoManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BoardInfoManageController.class);

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
	 * 게시판 등록 관리 화면
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="boardSetList.do", method = RequestMethod.GET)
	public ModelAndView  selectBoardSetInfoManageList() throws Exception {

		ModelAndView model = new ModelAndView("/backoffice/sys/boardSetList");
			
		model.addObject("boardNotice", codeDetailService.selectCmmnDetailCombo("BOARD_NOTICE"));
		model.addObject("boardGubun", codeDetailService.selectCmmnDetailCombo("BOARD_GUBUN"));
		model.addObject("boardSize", codeDetailService.selectCmmnDetailCombo("BOARD_SIZE"));
		model.addObject("authorInfo", authService.selectAuthInfoComboList());

		return model;	

	}

	/**
	 * 게시판 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="boardSetListAjax.do", method = RequestMethod.POST)
	public ModelAndView  selectBoardSetAjaxListByPagination(@RequestBody Map<String,Object>  searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") 
				: Integer.valueOf((String) searchVO.get("pageUnit"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

		searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
  
		List<Map<String, Object>> list =  boardSetService.selectBoardSettingInfoList(searchVO);
		int totCnt = list.size() > 0 ?  Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;

		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				
		return model;	
	}

//	@RequestMapping(value="boardSetListDetail.do")
//	public ModelAndView selectBoardSetDetail (@ModelAttribute("LoginVO") LoginVO loginVO, 
//											  @RequestParam("boardCd") String boardCd, 
//											  HttpServletRequest request, 
//											  BindingResult bindingResult) throws Exception {
//	
//		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
//		try {
//			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
//			model.addObject(Globals.STATUS_REGINFO, boardSetService.selectBoardSettingInfoDetail(boardCd));		    	 
//		} catch (Exception e) {
//			LOGGER.info(e.toString());
//			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
//			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));			
//		}	
//		return model;			
//	}
	/**
	 * 게시판관리 정보 저장
	 * @param info
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="boardSetUpdate.do", method = RequestMethod.POST)
	public ModelAndView boardSetUpdate(@RequestBody BoardSetInfo info) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		info.setFrstRegterId(userId);

		switch (info.getMode()) {
			case Globals.SAVE_MODE_INSERT:
				boardSetService.insertBoardInfo(info);
				break;
			case Globals.SAVE_MODE_UPDATE:
				boardSetService.updateBoardInfo(info);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
		}

		String messageKey = "";
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			messageKey = StringUtils.equals(info.getMode(), Globals.SAVE_MODE_INSERT) 
					? "sucess.common.insert" : "sucess.common.update";
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));

		return model;
	}

	/**
	 * 게시판코드 중복 코드 체크
	 * @param boardCd
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="boadCdCheck.do", method = RequestMethod.GET)
	public ModelAndView selectadminIdCheckManger(@RequestParam("boardCd") String boardCd) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		int IDCheck = uniService.selectIdDoubleCheck("BOARD_CD", "TSES_BRDSET_INFO_M", " BOARD_CD = ["+ boardCd + "[" );

		if (IDCheck == 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("common.codeOk.msg"));
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("common.codeFail.msg"));
		}

		return model;
	}

	@RequestMapping(value="boardSetDelete.do", method = RequestMethod.GET)
	public ModelAndView deleteBoardSetInfo(@RequestParam("delCd") String delCd) throws Exception {
			
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
				
		boardSetService.deleteBoardSetInfo(delCd);
		
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );

		return model;
	}
		
	@RequestMapping(value="boardList.do")
	public ModelAndView  selectBoardInfoManageListByPagination(@ModelAttribute("loginVO") LoginVO loginVO
																, @RequestParam("boardCd") String boardCd
																, HttpServletRequest request
																, BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/sys/boardList");
		
		try{
			
			  Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		      if(!isAuthenticated) {
	    	    model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	    model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
	    	    model.setViewName("backoffice/login");
	    		return model;
		      }
		      
			  //공지사항의 경우, 공지기한이 지난 게시물은 board_notice_useyn을 N으로 변경
			  //boardInfoService.updateBoardNoticeUseYn();
		      loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		      
		      //페이징 처리 
			  model.addObject(Globals.STATUS_REGINFO, boardSetService.selectBoardSettingInfoDetail(boardCd));
			  model.addObject("loginVO", loginVO);
		}catch (Exception e){
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject("message", egovMessageSource.getMessage("fail.common.list"));
			LOGGER.info(e.toString());
		}			   
		return model;	
	}
	/**
	 * 게시판 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="boardListAjax.do", method = RequestMethod.POST)
	public ModelAndView  selectBoardAjaxInfoManageListByPagination(@RequestBody Map<String,Object>  searchVO) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		      
		int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
		
		searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		
		//사용자 계정 정리 
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		searchVO.put("authorCd", loginVO.getAuthorCd());
		searchVO.put("centerCd", loginVO.getCenterCd());
		 
		 List<Map<String, Object>> list =  boardInfoService.selectBoardManageListByPagination(searchVO) ;
		 int totCnt = list.size() > 0 ?  Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		 paginationInfo.setTotalRecordCount(totCnt);
		 
		 model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		 model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		 model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		 model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			 
	
		return model;	
	}
	
	
	@NoLogging
	@RequestMapping (value="boardVisited.do")
	public ModelAndView selectBoardVisited(@RequestParam("boardSeq") String boardSeq) throws Exception{	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
	
		boardInfoService.updateBoardVisitedManage(boardSeq );
		model.addObject(Globals.STATUS_REGINFO, boardInfoService.selectBoardManageDetail(boardSeq));
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		    
		return model;
	}
	
	/**
	 * 게시물 상세
	 * @param boardSeq
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="boardView.do", method = RequestMethod.GET)
	public ModelAndView selectBoardViewInfoManageDetail(@RequestParam("boardSeq") String boardSeq) throws Exception{	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
			
		Map<String, Object> search = new HashMap<String, Object>();
		search.put("fileGubun", "BBS");
		search.put("fileSeq",boardSeq);
		
		model.addObject(Globals.JSON_RETURN_RESULT, boardInfoService.selectBoardManageDetail(boardSeq));
		model.addObject(Globals.JSON_RETURN_RESULTLISR, egocFileService.selectFileInfs(search));
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		    
		return model;
	}
	/**
	 * 게시물 삭제
	 * @param boardInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="boardDelete.do", method = RequestMethod.POST)
	public ModelAndView deleteBoardInfoManage( @RequestBody BoardInfo boardInfo)throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		    
		int ret = 	boardInfoService.deleteBoardManage(boardInfo.getBoardSeq());
		if (ret > 0 ) {		    	  
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );	
		}else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);	 
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
		}				
		return model;
	}	
	/**
	 * 게시물 파일 삭제
	 * @param fileSeqs
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="boardFileDelete.do", method = RequestMethod.GET)
	public ModelAndView deleteBoardFileInfoManage(@RequestParam("fileSeqs") String fileSeqs)throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		List<String> streFiles = SmartUtil.dotToList(fileSeqs);
		
		for (String strFile : streFiles) {
			uniService.deleteUniStatement("STRE_FILE_NM", "COMTNFILEDETAIL", "STRE_FILE_NM=["+strFile+"[");
		}
		
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));
			
		return model;
	}
	
	/**
	 * 게시물 수정
	 * @param mRequest
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="boardUpdate.do")
	public ModelAndView updateboardInfoManage(MultipartRequest mRequest, @ModelAttribute("BoardInfo") BoardInfo vo) throws Exception{			
		//파일 업로드 테스트 
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
			
		    List<FileVO> _result = null;
		    Iterator itr = mRequest.getFileNames();
		    if (itr.hasNext() ) {
	    		List<MultipartFile> file_list = mRequest.getFiles( (String) itr.next());  
			    if (file_list.size() > 0 ) {
			    	_result = fileUtil.parseFileKSESInf(mRequest.getFileNames(), mRequest, "BBS_", 0,  propertiesService.getString("Globals.filePath"));
			    }
	    	}
			
		    vo.setBoardTopSeq("0");
		 	String meesage = vo.getMode().equals("Ins") ?  "sucess.common.insert" :  "sucess.common.update";
		 	String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		 	vo.setFrstRegterId(userId);
			vo.setLastUpdusrId(userId);
			
			int ret = 0; 
			
			switch (vo.getMode()) {
			case Globals.SAVE_MODE_INSERT:
				ret = boardInfoService.insertBoardManage(vo, _result);
				break;
			case Globals.SAVE_MODE_UPDATE:
				ret = boardInfoService.updateBoardManage(vo, _result);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
			}
			if (ret >0){
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			}else {
				throw new Exception();
			}
		
		return model;
	}
		
	/**
	 * 파일 다운로드
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="fileDownload.do")
	public ModelAndView callDownload(HttpServletRequest request) throws Exception {
		ModelAndView model = new ModelAndView();
				
		File downloadFile;
		Map<String, Object> allData = new HashMap<String, Object>();
		String filePath = propertiesService.getString("Globals.filePath");
		String atchFileId = request.getParameter("atchFileId");
		String uploadFileName = boardInfoService.selectBoardUploadFileName(atchFileId);
		String originalFileName = boardInfoService.selectBoardoriginalFileName(atchFileId);
		 
		downloadFile = new File(filePath + "/" + uploadFileName);
	

		if(!downloadFile.canRead()){
			LOGGER.info("FILE DOWNLOAD IN CHECK ERROR!!!");
		    throw new Exception("File can't read(파일을 찾을 수 없습니다)");
		} else {
			downloadFile = new File(downloadFile.getParent(), uploadFileName);
			
			allData.put("downloadFile", downloadFile);
			allData.put("originalName", originalFileName);
		}

		
	    return new ModelAndView("FileDownloadView", "allData",allData);
	}
		
    @RequestMapping(value="boardEditorFileUpload.do")
    public void boardEditorFileUpload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String sFileInfo = "";
		String filename = request.getHeader("file-name");
		String filename_ext = filename.substring(filename.lastIndexOf(".")+1);
		filename_ext = filename_ext.toLowerCase();
		String[] allow_file = {"jpg","png","bmp","gif"};
		
		int cnt = 0;
		for(int i=0; i<allow_file.length; i++) {
			if(filename_ext.equals(allow_file[i])){
				cnt++;
			}
		}
		
		if(cnt == 0) {
			PrintWriter print = response.getWriter();
			print.print("NOTALLOW_"+filename);
			print.flush();
			print.close();
		} else {
			String dftFilePath = propertiesService.getString("Globals.filePath") + "/";
			String filePath = dftFilePath + "editor" + File.separator;
			File file = new File(filePath);
			if(!file.exists()) {
				file.mkdirs();
			}
			String realFileNm = "";
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			String today= formatter.format(new java.util.Date());
			realFileNm = today+UUID.randomUUID().toString() + filename.substring(filename.lastIndexOf("."));
			String rlFileNm = filePath + realFileNm;
			
			InputStream is = request.getInputStream();
			OutputStream os=new FileOutputStream(rlFileNm);
			int numRead;
			byte b[] = new byte[Integer.parseInt(request.getHeader("file-size"))];
			
			while((numRead = is.read(b,0,b.length)) != -1){
				os.write(b,0,numRead);
			}
			
			if(is != null) {
				is.close();
			}
		
			os.flush();
			os.close();
		
			sFileInfo += "&bNewLine=true";
			sFileInfo += "&sFileName="+ filename;;
			sFileInfo += "&sFileURL="+"/upload/editor/"+realFileNm;
			
			PrintWriter print = response.getWriter();
			print.print(sFileInfo);
			print.flush();
			print.close();
		}
    }
}