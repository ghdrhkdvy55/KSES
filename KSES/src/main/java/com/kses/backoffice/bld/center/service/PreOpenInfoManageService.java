package com.kses.backoffice.bld.center.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bld.center.vo.PreOpenInfo;

public interface PreOpenInfoManageService {
	
	/**
	 * SPDM 지점사전예약 입장시간 목록 조회
	 * 
	 * @param centerCd
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectPreOpenInfoList(String centerCd) throws Exception;
	
	
	/**
	 * SPDM 지점 사전예약 입장시간 정보 갱신
	 * 
	 * @param list
	 * @return
	 * @throws Exception
	 */
	public int updatePreOpenInfo(List<PreOpenInfo> list) throws Exception;
	
	/**
	 * SPDM 지점 사전예약 입장시간 정보 복사
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int copyPreOpenInfo(Map<String, Object> params) throws Exception;
}
