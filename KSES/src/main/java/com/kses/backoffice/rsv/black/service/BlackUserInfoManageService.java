package com.kses.backoffice.rsv.black.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.rsv.black.vo.BlackUserInfo;

public interface BlackUserInfoManageService {
	/**
	 * SPDM ���������ο� ��� ��ȸ
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectBlackUserInfoManageListByPagination(Map<String, Object> params) throws Exception;
	
	
	/**
	 * SPDM ������������ ����
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	int updateBlackUserInfoManage(BlackUserInfo vo) throws Exception;
}
