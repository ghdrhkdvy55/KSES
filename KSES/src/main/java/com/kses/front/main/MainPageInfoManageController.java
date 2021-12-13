package com.kses.front.main;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.Globals;

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

import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.sys.board.service.BoardInfoManageService;
import com.kses.backoffice.util.SmartUtil;
import com.kses.front.login.vo.UserLoginInfo;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
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
	
		
	@RequestMapping (value="main.do")
	public ModelAndView selectFrontMainPage(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestParam Map<String, String> param,
												HttpServletRequest request,
												BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView("/front/main/mainpage");
		try {
			
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if(!isAuthenticated) {
				
			} else {
				HttpSession httpSession = request.getSession(true);
				loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
			}
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			
			//게시판 요청 
			/*
			Map<String,Object>  searchVO = new HashMap<String,Object>();
			   
		    int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			  
		    searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		    LOGGER.info("pageUnit:" + pageUnit);
		    
	                
	   	    PaginationInfo paginationInfo = new PaginationInfo();
		    paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
		    paginationInfo.setRecordCountPerPage(pageUnit);
		    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		    searchVO.put("boardCd", "NOT");
			
			List<Map<String, Object>> list =  boardInfoService.selectBoardManageListByPagination(searchVO) ;
			int totCnt = list.size() > 0 ?  Integer.valueOf( list.get(0).get("total_record_count").toString()) : 0;
		      
			model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
			model.addObject(Globals.PAGE_TOTALCNT, totCnt);
			paginationInfo.setTotalRecordCount(totCnt);
			model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
			*/
			
		} catch(Exception e) {
			LOGGER.error("selectFrontMainPage : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg")); 
		}
		return model;
	}
	
	
	@RequestMapping (value="boardInfo.do")
	public ModelAndView selectFrontMainBoardLst (@RequestBody Map<String,Object>  searchVO) throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			
			if ( SmartUtil.NVL(searchVO.get("searchCenterCd") , "").toString().equals("NOT") ) {
				searchVO.remove("searchCenterCd");
			}
			   
		    int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			int pageSize = searchVO.get("pageSize") == null ?   propertiesService.getInt("pageSize") : Integer.valueOf((String) searchVO.get("pageSize"));
			
	                
	   	    PaginationInfo paginationInfo = new PaginationInfo();
		    paginationInfo.setCurrentPageNo( Integer.parseInt( SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
		    paginationInfo.setRecordCountPerPage(pageUnit);
		    paginationInfo.setPageSize(pageSize);
		    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		    searchVO.put("boardCd", "Not");
		    
			
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
	@RequestMapping (value="boardInfoDetail.do")
	public ModelAndView selectFrontDetailBoardLst (@RequestParam("boardSeq") String boardSeq) throws Exception{
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			
			Map<String, Object> search = new HashMap<String, Object>();
		    search.put("fileGubun", "BBS");
		    search.put("fileSeq",boardSeq);
			List<Map<String, Object>> fileList = egocFileService.selectFileInfs(search);
			
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS); 
			model.addObject(Globals.JSON_RETURN_RESULT, boardInfoService.selectBoardManageDetail(boardSeq));
			if (fileList.size() > 0)
				model.addObject(Globals.JSON_RETURN_RESULTLISR, fileList);
		}catch (Exception e) {
			LOGGER.error("selectUserInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	@RequestMapping (value="userInfo.do")
	public ModelAndView selectUserInfo(	@RequestParam("userId") String userId,
										HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession(true);
			UserLoginInfo userLoginInfo = new UserLoginInfo();
			
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			if(userLoginInfo ==  null) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;	
			}
			
			model.addObject("reservationInfo", resvService.selectUserLastResvInfo(userId));
			model.addObject("userLoginInfo", userLoginInfo);
			
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.error("selectUserInfo : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@RequestMapping (value="userResvInfo.do")
	public ModelAndView selectUserResvInfo(	@RequestBody Map<String, Object> params,
											HttpServletRequest request) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		try {
			HttpSession httpSession = request.getSession(true);
			UserLoginInfo userLoginInfo = new UserLoginInfo();
			
			userLoginInfo = (UserLoginInfo)httpSession.getAttribute("userLoginInfo");
			if(userLoginInfo ==  null) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS, Globals.STATUS_LOGINFAIL);
				return model;	
			}
			
			model.addObject("userLoginInfo", userLoginInfo);
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
	@RequestMapping(value="inc/popup_common.do")
	public ModelAndView smartworkPopup() throws Exception{		
		ModelAndView model = new ModelAndView("/front/inc/popup_common");
		return model;
	}
}