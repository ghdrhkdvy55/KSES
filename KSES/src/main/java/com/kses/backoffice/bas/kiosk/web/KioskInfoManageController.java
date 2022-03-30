package com.kses.backoffice.bas.kiosk.web;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bas.kiosk.service.KioskInfoService;
import com.kses.backoffice.bas.kiosk.vo.KioskInfo;
import com.kses.backoffice.bas.kiosk.web.KioskInfoManageController;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@RestController
@RequestMapping("/backoffice/bas")
public class KioskInfoManageController {
	
    @Autowired
	protected EgovMessageSource egovMessageSource;
	
	@Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private KioskInfoService kioskService;
	
	@Autowired
	private UniSelectInfoManageService uniService;
	
	@Autowired
	private CenterInfoManageService centerInfoManageService;
	
	@Autowired
	private EgovCcmCmmnDetailCodeManageService codeDetailService;
	
	/**
	 * 장비 관리 화면
	 * @return
	 * @throws Exception
	 */
	@NoLogging
	@RequestMapping(value="kioskList.do", method = RequestMethod.GET)
	public ModelAndView selectKioskInfoList() throws Exception {
		
		ModelAndView model = new ModelAndView("/backoffice/bas/kioskList");
		model.addObject("centerInfo", centerInfoManageService.selectCenterInfoComboList());
		model.addObject("machInfo", codeDetailService.selectCmmnDetailCombo("MACH_GUBUN"));
		return model;
	}
	
	/**
	 * 장비 관리 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="kioskListAjax.do", method = RequestMethod.POST)
	public ModelAndView selectKioskInfoListAjax(@RequestBody Map<String, Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView (Globals.JSONVIEW);
			
		int pageUnit = searchVO.get("pageUnit") == null ?   propertiesService.getInt("pageUnit")
				: Integer.valueOf((String) searchVO.get("pageUnit"));
		            
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo( Integer.parseInt(SmartUtil.NVL(searchVO.get("pageIndex"), "1") ) );
		paginationInfo.setRecordCountPerPage(pageUnit);
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		searchVO.put("firstIndex", paginationInfo.getFirstRecordIndex());
		searchVO.put("lastRecordIndex", paginationInfo.getLastRecordIndex());
		searchVO.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
					  
		List<Map<String, Object>> list = kioskService.selectKioskInfoList(searchVO);
		int totCnt =  list.size() > 0 ? Integer.valueOf( list.get(0).get("total_record_count").toString()) :0;
		paginationInfo.setTotalRecordCount(totCnt);
		
		model.addObject(Globals.STATUS_REGINFO, searchVO);
		model.addObject(Globals.JSON_RETURN_RESULTLISR, list);
		model.addObject(Globals.PAGE_TOTALCNT, totCnt);
		model.addObject(Globals.JSON_PAGEINFO, paginationInfo);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);	    
		  
		return model;
	}
	/**
	 * 사용하지 않음
	@RequestMapping (value="kioskInfoDetail.do")
	public ModelAndView selectKioskInfoDetail(	@ModelAttribute("loginVO") LoginVO loginVO, 
												@RequestParam("ticketMchnSno") String ticketMchnSno,
												HttpServletRequest request, 
												BindingResult bindingResult) throws Exception{	
		
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    if(!isAuthenticated) {
	    	model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.login"));
	    	model.setViewName("/backoffice/login");
	    	return model;	
	    }
	    
	    try {
	    	model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_REGINFO, kioskService.selectKioskInfoDetail(ticketMchnSno));
	    } catch(Exception e) {
			LOGGER.info(e.toString());
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.msg"));
	    }
	    return model;
	}
	*/
	
	/**
	 * 장비 시리얼 중복검사
	 * @param ticketMchnSno
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="kisokSerialCheck.do", method = RequestMethod.GET)
	public ModelAndView selectKisokSerialCheckManger(@RequestParam("ticketMchnSno") String ticketMchnSno) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		int ret = uniService.selectIdDoubleCheck("TICKET_MCHN_SNO", "TSEC_TICKET_MCHN_M", "TICKET_MCHN_SNO = ["+ ticketMchnSno+ "[" );
    	if (ret == 0) {
    		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("common.codeOk.msg"));
    	}
    	else {
    		model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("common.codeFail.msg"));
    	}

		return model;
	}
	
	/**
	 * 장비 정보 저장
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="kioskUpdate.do", method = RequestMethod.POST)
	public ModelAndView updateKioskInfo(@RequestBody KioskInfo vo) throws Exception{
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);
		
		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		vo.setFrstRegterId(userId);
		vo.setLastUpdusrId(userId);

		int ret = 0;
		switch (vo.getMode()) {
			case Globals.SAVE_MODE_INSERT:
				ret = kioskService.insertKioskInfo(vo);
				break;
			case Globals.SAVE_MODE_UPDATE:
				ret = kioskService.updateKioskInfo(vo);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
		}

		String messageKey = StringUtils.equals(vo.getMode(), Globals.SAVE_MODE_INSERT)
				? "sucess.common.insert" : "sucess.common.update";
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));

		return model;
	}
	
	/**
	 * 장비정보 삭제
	 * @param kioskInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value="kioskDelete.do", method = RequestMethod.POST)
	public ModelAndView deleteKioskInfoManage(@RequestBody KioskInfo kioskInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW); 

		int ret = kioskService.deleteKioskInfo(SmartUtil.dotToList(kioskInfo.getTicketMchnSno()));
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete"));
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("fail.common.delete"));
		}
		
		return model;
	}

}