package com.kses.backoffice.bld.center.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bld.center.vo.CenterHolyInfo;

public interface CenterHolyInfoManageService {

	/**
	 * SPDM 지점 휴일 정보 목록 조회
	 * 
	 * @param centerCd
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCenterHolyInfoList(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 지점 휴일 정보 갱신
	 * 
	 * @param list
	 * @return
	 * @throws Exception
	 */
	public int updateCenterHolyInfo(CenterHolyInfo vo) throws Exception;
	
	/**
	 * SPDM 지점 휴일 정보 복사
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int copyCenterHolyInfo(Map<String, Object> params) throws Exception;
	
	public boolean insertExcelCenterHoly(List<CenterHolyInfo> centerHolyInfoList) throws Exception;
	
	public Map<String, Object>  centerUpdateSelect(String centerHolySeq) throws Exception;
	
	public int deleteCenterHolyInfo(int centerHolySeq) throws Exception;
}
