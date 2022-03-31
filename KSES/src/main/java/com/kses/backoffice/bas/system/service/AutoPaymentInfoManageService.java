package com.kses.backoffice.bas.system.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bas.system.vo.AutoPaymentInfo;

/**
 * SPDM 스피드온 자동결제관리 서비스
 * 
 * @author JangDaeHan
 *
 */
public interface AutoPaymentInfoManageService {
	
	/**
	 * SPDM 스피드온 자동결제 정보 목록 조회
	 * 
	 * @param centerCd
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectAutoPaymentInfoList() throws Exception;
	
	
	/**
	 * SPDM 스피드온 자동결제 정보 갱신
	 * 
	 * @param list
	 * @return
	 * @throws Exception
	 */
	int updateAutoPaymentInfo(List<AutoPaymentInfo> list) throws Exception;
}
