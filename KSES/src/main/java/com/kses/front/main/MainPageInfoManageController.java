package com.kses.front.main;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.Globals;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.cus.usr.service.UserInfoManageService;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.sys.board.service.BoardInfoManageService;
import com.kses.backoffice.util.SmartUtil;
import com.kses.front.annotation.LoginUncheck;
import com.kses.front.annotation.ReferrerUncheck;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/front/")
public class MainPageInfoManageController {

    private static final Logger LOGGER = LoggerFactory.getLogger(MainPageInfoManageController.class);
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
    
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private ResvInfoManageService resvService;
	
	@Autowired
    protected BoardInfoManageService boardInfoService;
	
	@Autowired
	private EgovFileMngService egocFileService;
	
	@Autowired
	private UserInfoManageService userService;
	
	@ReferrerUncheck
	@LoginUncheck
	@RequestMapping (value="main.do")
	public ModelAndView viewFrontMainpage(HttpServletRequest request) throws Exception {
		return new ModelAndView("/front/main/mainpage");
	}
	
	@LoginUncheck
	@RequestMapping (value="boardInfo.do")
	public ModelAndView selectFrontMainBoardLst (@RequestBody Map<String,Object>  searchVO) throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			
			if (SmartUtil.NVL(searchVO.get("searchCenterCd") , "").toString().equals("NOT") ) {
				searchVO.remove("searchCenterCd");
			}
			   
		    int pageUnit = searchVO.get("pageUnit") == null ?  propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			int pageSize = searchVO.get("pageSize") == null ?  propertiesService.getInt("pageSize") : Integer.valueOf((String) searchVO.get("pageSize"));
			
	                
	   	    PaginationInfo paginationInfo = new PaginationInfo();
		    paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
		    paginationInfo.setRecordCountPerPage(pageUnit);
		    paginationInfo.setPageSize(pageSize);
		    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		    searchVO.put("boardCd", "Not");
			searchVO.put("adminYn", "user");
			
			List<Map<String, Object>> list =  boardInfoService.selectBoardManageListByPagination(searchVO) ;
			int totCnt = list.size() > 0 ?  Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS); 
			model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
			model.addObject(Globals.PAGE_TOTALCNT, totCnt);
			paginationInfo.setTotalRecordCount(totCnt);
			model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		}catch (Exception e) {
			LOGGER.error("selectUserInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping (value="boardInfoDetail.do")
	public ModelAndView selectFrontDetailBoardLst (@RequestParam("boardSeq") String boardSeq) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			Map<String, Object> search = new HashMap<String, Object>();
		    search.put("fileGubun", "BBS");
		    search.put("fileSeq",boardSeq);
			List<Map<String, Object>> fileList = egocFileService.selectFileInfs(search);
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS); 
			model.addObject(Globals.JSON_RETURN_RESULTLISR, boardInfoService.selectBoardManageDetail(boardSeq));
			if (fileList.size() > 0)
				model.addObject("fileList", fileList);
		} catch (Exception e) {
			LOGGER.error("selectUserInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@LoginUncheck
	@RequestMapping(value="fileDownload.do")
	public ModelAndView callDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		File downloadFile;
		Map<String, Object> allData = new HashMap<String, Object>();
		String filePath = propertiesService.getString("Globals.filePath");
		String atchFileId = request.getParameter("atchFileId");
		String uploadFileName = boardInfoService.selectBoardUploadFileName(atchFileId);
		String originalFileName = boardInfoService.selectBoardoriginalFileName(atchFileId);
		 
		downloadFile = new File(filePath + "/" + uploadFileName);

		try{
		    if(!downloadFile.canRead()){
		    	LOGGER.info("FILE DOWNLOAD IN CHECK ERROR!!!");
		        throw new Exception("File can't read(파일을 찾을 수 없습니다)");
		    } else {
		    	downloadFile = new File(downloadFile.getParent(), uploadFileName);
		    	
		    	allData.put("downloadFile", downloadFile);
		    	allData.put("originalName", originalFileName);
		    }
		} catch(Exception e) {
			LOGGER.info(e.toString());
			e.printStackTrace();
		}
		
	    return new ModelAndView("FileDownloadView", "allData",allData);
	}
	
	@RequestMapping (value="mainResvInfo.do")
	public ModelAndView selectMainResvInfo(	HttpServletRequest request,
											@RequestParam("userId") String userId) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			model.addObject("vacntnInfo", userService.selectUserVacntnInfo(userId));
			model.addObject("reservationInfo", resvService.selectUserLastResvInfo(userId));
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectMainResvInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@RequestMapping (value="userResvInfo.do")
	public ModelAndView selectUserResvInfo(	HttpServletRequest request,
											@RequestBody Map<String, Object> params) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			model.addObject(Globals.JSON_RETURN_RESULTLISR, resvService.selectUserResvInfo(params));
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectUserResvInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@NoLogging
	@ReferrerUncheck
	@LoginUncheck
	@RequestMapping(value="inc/popup_common.do")
	public ModelAndView frontCommonPopup() throws Exception{		
		ModelAndView model = new ModelAndView("/front/inc/popup_common");
		return model;
	}
	
	@NoLogging
	@ReferrerUncheck
	@LoginUncheck
	@RequestMapping(value="inc/footer.do")
	public ModelAndView frontCommonFooter() throws Exception{		
		ModelAndView model = new ModelAndView("/front/inc/footer");
		return model;
	}
}