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
	public List<Map<String, Object>> selectBlackUserInfoManageListByPagination(Map<String, Object> params) throws Exception;
	
	
	/**
	 * SPDM 출입통제정보 갱신
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	int updateBlackUserInfoManage(BlackUserInfo vo) throws Exception;
}
