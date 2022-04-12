package com.kses.backoffice.bld.floor.web;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.kses.backoffice.bld.floor.service.FloorPartInfoManageService;
import com.kses.backoffice.bld.floor.vo.FloorPartInfo;
import com.kses.backoffice.bld.partclass.service.PartClassInfoManageService;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.service.UniSelectInfoManageService;
import com.kses.backoffice.util.service.fileService;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
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

	@Autowired
	private PartClassInfoManageService partClassService;

	/**
	 * 구역 팝업 화면
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "partInfoPopup.do", method = RequestMethod.GET)
	public ModelAndView popupPartInfo() throws Exception {
		return new ModelAndView("/backoffice/bld/sub/partInfo");
	}

	/**
	 * 구역 정보 GUI 화면
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "partGui.do", method = RequestMethod.GET)
	public ModelAndView guiPart() throws Exception {
		return new ModelAndView("/backoffice/bld/sub/partGui");
	}
	
	/**
	 * 구역 현황 화면
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "partPreview.do", method = RequestMethod.GET)
	public ModelAndView preview(@RequestParam Map <String, Object> params) throws Exception {
		ModelAndView model = new ModelAndView("/backoffice/bld/sub/partPreview");
		model.addObject("areaInfo", params);
		return model;
	}

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

	/**
	 * 구역 상세 조회
	 * @param partCd
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "partDetail.do", method = RequestMethod.GET)
	public ModelAndView selectPartDetailInfoManage(@RequestParam("partCd") String partCd) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		model.addObject(Globals.JSON_RETURN_RESULT, partService.selectFloorPartInfoDetail(partCd));
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

		return model;
	}

	/**
	 * 지점 층 구역 목록 얻기
	 * @param floorCd
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "partInfoComboList.do", method = RequestMethod.GET)
	public ModelAndView selectPartInfoComboList(@RequestParam("floorCd") String floorCd) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		model.addObject(Globals.JSON_RETURN_RESULTLISR, partService.selectFloorPartInfoManageCombo(floorCd));
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);

		return model;
	}

	/**
	 * 구역 정보 저장
	 * @param floorPartInfo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "partUpdate.do", method = RequestMethod.POST)
	public ModelAndView updatePartInfoManage(@ModelAttribute("FloorPartInfo") FloorPartInfo floorPartInfo) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		floorPartInfo.setFrstRegterId(userId);
		floorPartInfo.setLastUpdusrId(userId);
		floorPartInfo.setPartMap1(uploadFile.uploadFileNm(floorPartInfo.getPartMap1File(), propertiesService.getString("Globals.filePath")));

		Map<String, Object> partClass = partClassService.selectPartClass(floorPartInfo.getPartClassSeq());
		floorPartInfo.setPartClass(partClass.get("part_class").toString());

		int ret = 0;
		switch (floorPartInfo.getMode()) {
			case Globals.SAVE_MODE_INSERT:
				ret = partService.insertFloorPartInfoManage(floorPartInfo);
				break;
			case Globals.SAVE_MODE_UPDATE:
				ret = partService.updateFloorPartInfoManage(floorPartInfo);
				break;
			default:
				throw new EgovBizException("잘못된 호출입니다.");
		}

		String messageKey = "";
		if (ret > 0) {
			model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
			messageKey = StringUtils.equals(floorPartInfo.getMode(), Globals.SAVE_MODE_INSERT)
					? "sucess.common.insert" : "sucess.common.update";
		}
		else {
			model.addObject(Globals.STATUS, Globals.STATUS_FAIL);
			messageKey = StringUtils.equals(floorPartInfo.getMode(), Globals.SAVE_MODE_INSERT)
					? "fail.common.insert" : "fail.common.update";
		}
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage(messageKey));

		return model;
	}

	/**
	 * 구역 삭제
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "partInfoDelete.do", method = RequestMethod.POST)
	public ModelAndView deletePartInfoManage(@RequestBody Map<String,Object> searchVO) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		uniService.deleteUniStatement("PART_MAP1, PART_MAP2", "TSEB_PART_INFO_D", "PART_CD=[" + searchVO.get("partCd") + "[");
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("success.common.delete") );

		return model;
	}


	/**
	 * 구역 정보 저장
	 * @param floorPartInfoList
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "partGuiUpdate.do", method = RequestMethod.POST)
	public ModelAndView updatePartGuiPosition(@RequestBody List<FloorPartInfo> floorPartInfoList) throws Exception {
		ModelAndView model = new ModelAndView(Globals.JSONVIEW);

		String userId = EgovUserDetailsHelper.getAuthenticatedUserId();
		floorPartInfoList.stream().forEach(x -> x.setLastUpdusrId(userId));
		partService.updateFloorPartInfPositionInfo(floorPartInfoList);
		model.addObject(Globals.STATUS, Globals.STATUS_SUCCESS);
		model.addObject(Globals.STATUS_MESSAGE, egovMessageSource.getMessage("sucess.common.update"));

		return model;
	}

}