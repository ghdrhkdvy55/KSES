package com.kses.backoffice.bas.menu.web;

import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;
import com.kses.backoffice.bas.menu.service.MenuCreateManageService;
import com.kses.backoffice.bas.menu.service.MenuInfoService;
import com.kses.backoffice.bas.menu.vo.MenuCreatInfo;
import com.kses.backoffice.bas.menu.vo.MenuInfo;
import com.kses.backoffice.bas.progrm.service.ProgrmInfoService;
import com.kses.backoffice.util.SmartUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/bas")
public class MenuInfoManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MenuInfoManageController.class);
	
	@Autowired
	private DefaultBeanValidator beanValidator;
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	@Autowired
	private MenuInfoService menuService;
	
	@Autowired
	private MenuCreateManageService menuCreateService;

	@Autowired
	private ProgrmInfoService progrmService;

	/** EgovMessageSource */
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@RequestMapping(value = "menuList.do")
	public ModelAndView selectMenuManageList( ModelMap model) throws Exception {
		// 0. Spring Security 사용자권한 처리
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		ModelAndView mav = new  ModelAndView("/backoffice/bas/menuList");
		if (isAuthenticated == null || !isAuthenticated) {
			mav.addObject("message", egovMessageSource.getMessage("fail.common.login"));
			mav.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
			mav.setViewName("/backoffice/login");
			return mav;
		}
		// 내역 조회
		return mav ;
	}
	/**
	 * 메뉴목록 리스트조회한다.
	 * @param searchVO ComDefaultVO
	 * @return 출력페이지정보 "sym/mnu/mpm/EgovMenuManage"
	 * @exception Exception
	 */
	@RequestMapping(value = "menuListAjax.do")
	public ModelAndView selectMenuManageListAjax(@RequestBody Map<String, Object> searchVO, 
											     HttpServletRequest request, 
											     BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
		// 0. Spring Security 사용자권한 처리
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (isAuthenticated == null || !isAuthenticated) {
			model.addObject("message", egovMessageSource.getMessage("fail.common.login"));
			model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
			return model;
		}
		
		//int pageUnit = searchVO.get("pageUnit") == null ?  propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
		int pageUnit = 1000;
	    searchVO.put("pageSize", "1000");
	  
	    
	  
   	    PaginationInfo paginationInfo = new PaginationInfo();
	    paginationInfo.setCurrentPageNo( Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"),"1")));
	    paginationInfo.setRecordCountPerPage(pageUnit);
	    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

	    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
	    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
	    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
	    
	    LOGGER.info("searchVO:" + searchVO);
	    
	    List<Map<String, Object>> menuList = menuService.selectMenuManageList(searchVO);
	    
	    int totCnt =  menuList.size() > 0 ? Integer.valueOf(menuList.get(0).get("total_record_count").toString()) : 0;
		   
		model.addObject(Globals.JSON_RETURN_RESULTLISR, menuList);
	    model.addObject(Globals.PAGE_TOTALCNT, totCnt);
	    paginationInfo.setTotalRecordCount(totCnt);
	    model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
	    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);	
		return model;
	}
	
	/**
	 * 메뉴정보목록을 상세화면 호출 및 상세조회한다.
	 * @param req_menuNo  String
	 * @return 출력페이지정보 "sym/mnu/mpm/EgovMenuDetailSelectUpdt"
	 * @exception Exception
	 */
	@RequestMapping(value = "menuDetailInfo.do")
	public ModelAndView selectMenuManage(@RequestParam("menuNo") String menuNo) throws Exception {
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
		// 0. Spring Security 사용자권한 처리
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (isAuthenticated == null || !isAuthenticated) {
			model.addObject("message", egovMessageSource.getMessage("fail.common.login"));
			model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
			return model;
		}
		
		try {
		    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_REGINFO, menuService.selectMenuManage(menuNo));
		} catch(Exception e) {
				LOGGER.info(e.toString());
				model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}

	

	/**
	 * 메뉴목록 멀티 삭제한다.
	 * @param checkedMenuNoForDel  String
	 * @return 출력페이지정보 "forward:/sym/mnu/mpm/EgovMenuManageSelect.do"
	 * @exception Exception
	 */
	@RequestMapping("menuManageListDelete.do")
	public ModelAndView deleteMenuManageList(@RequestParam("checkedMenuNoForDel") String checkedMenuNoForDel, 
			                                 @ModelAttribute("MenuInfo") MenuInfo menu,
			                                 BindingResult bindingResult)throws Exception {
		
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
		// 0. Spring Security 사용자권한 처리
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (isAuthenticated == null || !isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
			return model;
		}
		
		try {
			
			
			 int ret = menuService.deleteMenuManageList(checkedMenuNoForDel);
			
			 if (ret == -1) {
				model.addObject(Globals.STATUS_MESSAGE, "참조되는 메뉴가 있어 삭제가 실패하였습니다.");
				model.addObject(Globals.STATUS,  Globals.STATUS_FAIL);
			 } else if (ret == 0 ) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
				model.addObject(Globals.STATUS,  Globals.STATUS_FAIL);
				
			 } else {
				menuService.deleteMenuManageList(checkedMenuNoForDel);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));
				model.addObject(Globals.STATUS,  Globals.STATUS_SUCCESS);
			 }
		}catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));	
		}
		return model;
	}

	/**
	 * 메뉴정보를 등록화면으로 이동 및 등록 한다.
	 * @param menuManageVO    MenuManageVO
	 * @param commandMap      Map
	 * @return 출력페이지정보 등록화면 호출시 "sym/mnu/mpm/EgovMenuRegist",
	 *         출력페이지정보 등록처리시 "forward:/sym/mnu/mpm/EgovMenuManageSelect.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "menuRegistUpdate.do")
	public ModelAndView insertMenuManage(@RequestParam Map<String, Object> commandMap, 
			                             @RequestBody MenuInfo menuIno, 
			                             BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
		
		// 0. Spring Security 사용자권한 처리
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (isAuthenticated == null || !isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
			return model;
		}
			
		if (menuService.selectMenuNoByPk(menuIno) != 0 && menuIno.getMode().equals("Ins")) {
			model.addObject(Globals.STATUS,  Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("common.isExist.msg"));
			return model;
		}
	    int ret = menuService.updateMenuManage(menuIno);
	    String message = "";
	    String states = "";
	    
	    if (ret > 0) {
	    	message = menuIno.getMode().equals("Ins") ? egovMessageSource.getMessage("success.common.insert") : egovMessageSource.getMessage("success.common.update");
	    	states =  Globals.STATUS_SUCCESS;
	    }else {
	    	message = menuIno.getMode().equals("Ins") ? egovMessageSource.getMessage("fail.common.insert") : egovMessageSource.getMessage("fail.common.update");
	    	states =  Globals.STATUS_FAIL;
	    }
	    model.addObject(Globals.STATUS, states);
		model.addObject(Globals.STATUS_MESSAGE, message);
	    
		return model;
	}

	
	/**
	 * 메뉴정보를 삭제 한다.
	 * @param menuManageVO MenuManageVO
	 * @return 출력페이지정보 "forward:/sym/mnu/mpm/EgovMenuManageSelect.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "menuManageDelete.do")
	public ModelAndView deleteMenuManage(@RequestParam("menuNo") String menuNo, 
			                       ModelMap mmp) throws Exception {
		
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
		
		// 0. Spring Security 사용자권한 처리
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (isAuthenticated == null || !isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
			return model;
		}
		
		
		
		if (menuService.selectUpperMenuNoByPk(menuNo) != 0) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete.upperMenuExist"));
			model.addObject(Globals.STATUS,  Globals.STATUS_FAIL);
			
			return model;
		}
		int ret = menuService.deleteMenuManage(menuNo);
		if (ret > 0) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));
			model.addObject(Globals.STATUS,  Globals.STATUS_SUCCESS);
		}else {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
			model.addObject(Globals.STATUS,  Globals.STATUS_FAIL);
		}

		return model;
	}

	/*### 일괄처리 프로세스 ###*/

	/**
	 * 메뉴생성 일괄삭제프로세스
	 * @param menuManageVO MenuManageVO
	 * @return 출력페이지정보 "sym/mnu/mpm/EgovMenuBndeRegist"
	 * @exception Exception
	 */
	@RequestMapping(value = "menuBndeAllDelete.do")
	public ModelAndView menuBndeAllDelete(@ModelAttribute("MenuInfo") MenuInfo menuInfo, 
			                        ModelMap mmp) throws Exception {
		
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
		// 0. Spring Security 사용자권한 처리
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if (isAuthenticated == null || !isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
				return model;
			}
			
			menuService.menuBndeAllDelete();
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));
			model.addObject(Globals.STATUS,  Globals.STATUS_SUCCESS);
		}catch(Exception e) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
			model.addObject(Globals.STATUS,  Globals.STATUS_FAIL);
		}
		return model;
	}

	/**
	 * 메뉴일괄등록화면 호출 및  메뉴일괄등록처리 프로세스
	 * @param commandMap    Map
	 * @param menuManageVO  MenuManageVO
	 * @param request       HttpServletRequest
	 * @return 출력페이지정보 "sym/mnu/mpm/EgovMenuBndeRegist"
	 * @exception Exception
	 */
	@RequestMapping(value = "menuBndeRegist.do")
	public ModelAndView menuBndeRegist(@RequestParam Map<String, Object> commandMap, 
			                     final HttpServletRequest request, 
			                     @ModelAttribute("MenuInfo") MenuInfo menuInfo,
			                     ModelMap mmp) throws Exception {
		
		
		
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
		
		String sLocationUrl = null;
		String resultMsg = "";
		String sMessage = "";
		String status = "";
		
		// 0. Spring Security 사용자권한 처리
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (isAuthenticated == null || !isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
			return model;
		}
		
		
		final MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
		final Map<String, MultipartFile> files = multiRequest.getFileMap();
		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		MultipartFile file = null;
		InputStream fis = null;
		while (itr.hasNext()) {
			Entry<String, MultipartFile> entry = itr.next();
			try {
				file = entry.getValue();
				fis = file.getInputStream();
				if (!"".equals(file.getOriginalFilename())) {
					// 2011.10.07 업로드 파일에 대한 확장자를 체크
					if (file.getOriginalFilename().toLowerCase().endsWith(".xls") || file.getOriginalFilename().toLowerCase().endsWith(".xlsx")) {
						if (menuService.menuBndeAllDelete()) {
							sMessage = menuService.menuBndeRegist(menuInfo, fis);
							resultMsg = sMessage;
						} else {
							
							sMessage = "EgovMenuBndeRegist Error!!";
							status = Globals.STATUS_FAIL;
							
						}
					} else {
						
						sMessage = "xls, xlsx 파일 타입만 등록이 가능합니다.";
						status = Globals.STATUS_FAIL;
						
					}
					// *********** 끝 ***********

				} else {
					sMessage = egovMessageSource.getMessage("fail.common.msg");
				}

			} finally {
				try {
					if (fis != null) {
						fis.close();
					}
				} catch (IOException ee) {
					LOGGER.debug("{}", ee);
				}
			}

		}
		model.addObject(Globals.STATUS_MESSAGE, sMessage);
		model.addObject(Globals.STATUS,  status);
		return model;
	}
	//메뉴 생성 관리
	@RequestMapping(value="menuCreateList.do")
	public ModelAndView menuCreateList(	@ModelAttribute("loginVO") LoginVO loginVO, 
									    HttpServletRequest request, 
										BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/bas/menuCreateList");

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
			return model;	
		} else {
			HttpSession httpSession = request.getSession(true);
			loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
		}
		
		return model;
	}
	
	@RequestMapping(value="menuCreateListAjax.do")
	public ModelAndView selectAuthInfoListAjax(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestBody Map<String, Object> searchVO, 
												HttpServletRequest request, 
												BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
		
		try {
			int pageUnit = searchVO.get("pageUnit") == null ?  propertiesService.getInt("pageUnit") : Integer.valueOf((String) searchVO.get("pageUnit"));
			  
		    searchVO.put("pageSize", propertiesService.getInt("pageSize"));
		  
		    LOGGER.info("pageUnit:" + pageUnit);
		  
	   	    PaginationInfo paginationInfo = new PaginationInfo();
		    paginationInfo.setCurrentPageNo( Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"),"1")));
		    paginationInfo.setRecordCountPerPage(pageUnit);
		    paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

		    searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		    searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		    searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
		    			  
			List<Map<String, Object>> list = menuCreateService.selectMenuCreatManagList(searchVO);
	        int totCnt =  list.size() > 0 ? Integer.valueOf(list.get(0).get("total_record_count").toString()) : 0;
	   
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
	@RequestMapping(value="menuCreateUpdateAjax.do")
	public ModelAndView updateMenuCreateAjax(	@RequestBody Map<String, Object> createInfo,
									            @ModelAttribute("MenuCreatInfo") MenuCreatInfo info,
									            BindingResult bindingResult)throws Exception {
		
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if (isAuthenticated == null || !isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
				return model;
			}
			LOGGER.debug("mode:" + createInfo.get("mode"));
			menuCreateService.insertMenuCreatList(createInfo.get("authorCode").toString(), createInfo.get("checkedMenuNo").toString());
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.update"));	
			
		}catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
		return model;
	}
	@RequestMapping(value="menuCreateMenuListAjax.do")
	public ModelAndView selectMenuCreateMenuListAjax(@RequestParam("authorCode") String authorCode)throws Exception {
		
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
		try {
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if (isAuthenticated == null || !isAuthenticated) {
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
				model.addObject(Globals.STATUS,  Globals.STATUS_LOGINFAIL);
				return model;
			}
			List<Map<String, Object>> list = menuCreateService.selectMenuCreatList_Author(authorCode);
			model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		}catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));	
		}
		return model;
	}
	
}