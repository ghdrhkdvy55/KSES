package com.kses.backoffice.rsv.black.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.rsv.black.vo.BlackUserInfo;

public interface BlackUserInfoManageService {
	/**
	 * SPDM 출입통제인원 목록 조회
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectBlackUserInfoList(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 출입통제정보 등록
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	int insertBlackUserInfo(BlackUserInfo vo) throws Exception;
	
	/**
	 * SPDM 출입통제정보 갱신
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	int updateBlackUserInfo(BlackUserInfo vo) throws Exception;
}