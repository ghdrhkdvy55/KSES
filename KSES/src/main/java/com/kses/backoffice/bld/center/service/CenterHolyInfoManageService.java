package com.kses.backoffice.bld.center.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bld.center.vo.CenterHolyInfo;

public interface CenterHolyInfoManageService {

	/**
	 * SPDM 지점 휴일 정보 목록 조회
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectCenterHolyInfoList(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 지점 휴일 정보 갱신
	 * 
	 * @param list
	 * @return
	 * @throws Exception
	 */
	int updateCenterHolyInfo(CenterHolyInfo vo) throws Exception;

	int updateCenterHolyInfoList(List<CenterHolyInfo> centerHolyInfoList) throws Exception;
	
	/**
	 * SPDM 지점 휴일 정보 복사
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	int copyCenterHolyInfo(CenterHolyInfo centerHolyInfo) throws Exception;
	
	
	Map<String, Object>  centerUpdateSelect(String centerHolySeq) throws Exception;
	
	int deleteCenterHolyInfo(int centerHolySeq) throws Exception;
	/**
	 * SPDM 엑셀 업로드
	 * 
	 * @param centerHolyInfoList
	 * @return
	 * @throws Exception
	 */
	boolean insertExcelCenterHoly(List<CenterHolyInfo> centerHolyInfoList) throws Exception;
}
