package com.kses.backoffice.bld.floor.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
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
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bld.floor.service.FloorPartInfoManageService;
import com.kses.backoffice.bld.floor.vo.FloorPartInfo;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.service.UniSelectInfoManageService;
import com.kses.backoffice.util.service.fileService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

@RestController
@RequestMapping("/backoffice/bld")
public class FloorPartInfoManageController {

    private static final Logger LOGGER = LoggerFactory.getLogger(FloorPartInfoManageController.class);
	
	@Autowired
	protected EgovMessageSource egovMessageSource;
    
    @Autowired
	private fileService uploadFile;

	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private FloorPartInfoManageService partService;
	
	@Autowired
	private UniSelectInfoManageService uniService;
	
	//구역 리스트 보여 주기 
	@RequestMapping(value="partListAjax.do")
	public ModelAndView selectPartInfoListAjax(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestBody Map<String,Object> searchVO, 
												HttpServletRequest request, 
												BindingResult bindingResult	) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		try {
			searchVO.put("firstIndex", "0");
			searchVO.put("recordCountPerPage", "100");
			List<Map<String, Object>> partList = partService.selectFloorPartInfoList(searchVO);
			int totCnt = partList.size() > 0 ?  Integer.valueOf( partList.get(0).get("total_record_count").toString()) :0;
			model.addObject(Globals.JSON_RETURN_RESULTLISR, partList);
		    model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		    model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));	
		}
		return model;
	}
	
	@RequestMapping (value="partDetail.do")
	public ModelAndView selectPartDetailInfoManage(	@ModelAttribute("LoginVO") LoginVO loginVO, 
													@RequestParam("partCd") String partCd) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
			return model;	
		}
		
		try {
			//Detail 값 가지고 오기
			model.addObject(Globals.STATUS_REGINFO, partService.selectFloorPartInfoDetail(partCd));
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	}
	
	@RequestMapping (value="partInfoComboList.do")
	public ModelAndView selectPartInfoComboList(	@ModelAttribute("LoginVO") LoginVO loginVO, 
													@RequestParam("floorCd") String floorCd) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
			return model;	
		}
		
		try {
			model.addObject(Globals.JSON_RETURN_RESULTLISR, partService.selectFloorPartInfoManageCombo(floorCd));
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		} catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	} 

	@NoLogging
	@RequestMapping (value="partUpdate.do")
	public ModelAndView updatePartInfoManage(	HttpServletRequest request, 
												MultipartRequest mRequest, 
												@ModelAttribute("LoginVO") LoginVO loginVO, 
												@ModelAttribute("FloorPartInfo") FloorPartInfo vo, 
												BindingResult result) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
			model.setViewName("/backoffice/login");
		} else {
	    	HttpSession httpSession = request.getSession(true);
	    	loginVO = (LoginVO)httpSession.getAttribute("LoginVO");
	    	vo.setFrstRegterId(loginVO.getAdminId());
	    	vo.setLastUpdusrId(loginVO.getAdminId());
	    }
		
		try {
			model.addObject(Globals.STATUS_REGINFO , vo);
			String meesage = "";
			
	    	vo.setPartMap1(uploadFile.uploadFileNm(mRequest.getFiles("partMap1"), propertiesService.getString("Globals.filePath")));
			vo.setPartMap2( uploadFile.uploadFileNm(mRequest.getFiles("partMap2"), propertiesService.getString("Globals.filePath")));
			meesage = vo.getMode().equals("Ins") ? "sucess.common.insert" : "sucess.common.update" ;
					
			int ret = partService.updateFloorPartInfoManage(vo);
			if (ret > 0) {
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			} else {
				throw new Exception();
			}
		}catch (Exception e){
			LOGGER.error("floorUpdate ERROR : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		LOGGER.debug("model:" + model.toString());
		return model;
	}
	
	@RequestMapping (value="partInfoDelete.do")
	public ModelAndView deletePartInfoManage(	@ModelAttribute("loginVO") LoginVO loginVO,
			                                   	@RequestParam("partCd") String partCd) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }	
		
	    try{
			// 이미지 삭제
			int ret = uniService.deleteUniStatement("PART_MAP1, PART_MAP2", "TSEB_PART_INFO_D", "PART_CD=[" + partCd + "[");		      
		    if (ret > 0) {		
		    	//구역 삭제 
		    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );		    	 
		    } else {
		    	throw new Exception();		    	  
		    }
		}catch (Exception e){
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}
}