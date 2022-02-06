package com.kses.backoffice.bld.floor.web;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.kses.backoffice.bld.floor.service.FloorPartInfoManageService;
import com.kses.backoffice.bld.floor.vo.FloorPartInfo;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;
import com.kses.backoffice.util.service.fileService;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/backoffice/bld")
public class FloorPartInfoManageController {
	
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

	/**
	 * 구역 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "partListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectPartInfoListAjax(@RequestBody Map<String,Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		int pageUnit = searchVO.get("pageUnit") == null ? propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1").toString()));
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));

		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());

		List<Map<String, Object>> partList = partService.selectFloorPartInfoList(searchVO);
		int totCnt = partList.size() > 0 ? Integer.valueOf( partList.get(0).get("total_record_count").toString()) : 0;
		paginationInfo.setTotalRecordCount(totCnt);

		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, partList);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

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
			log.info(e.toString());
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
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
		}
		return model;
	} 

	
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
			meesage = vo.getMode().equals(Globals.SAVE_MODE_INSERT) ? "sucess.common.insert" : "sucess.common.update" ;
					
			int ret = partService.updateFloorPartInfoManage(vo);
			if (ret > 0) {
				model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
				model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(meesage));
			} else {
				throw new Exception();
			}
		}catch (Exception e){
			log.error("floorUpdate ERROR : " + e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.insert"));	
		}	
		log.debug("model:" + model.toString());
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
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));			
		}		
		return model;
	}
	//신규 
	@RequestMapping(value="partGuiUpdate.do", method=RequestMethod.POST)
	public ModelAndView updatePartGuiPosition (	@RequestBody Map<String, Object> params, 
												HttpServletRequest request, 
												BindingResult bindingResult) throws Exception {
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		try {
			
			Gson gson = new GsonBuilder().create();
			List<FloorPartInfo> seatInfos = gson.fromJson(params.get("data").toString(), new TypeToken<List<FloorPartInfo>>(){}.getType());
			int result = partService.updateFloorPartInfPositionInfo(seatInfos);
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
            model.addObject("resutlCnt", result);
		}catch(Exception e) {
			log.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.update"));
		}
		return model;
		
	}
}