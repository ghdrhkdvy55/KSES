package com.kses.backoffice.mng.employee.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.mng.employee.vo.GradInfo;

/**
 * SPDM 공통 직책 정보 서비스
 * 
 * @author JangDaeHan
 *
 */
public interface GradInfoManageService {
	
	/**
	 * SPDM 공통 직책 목록 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectGradInfoList(@Param("params") Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 공통 직책 콤보박스 목록 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	List<GradInfo> selectGradInfoComboList() throws Exception;
	
	/**
	 * SPDM 공통 직책 정보 상세 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectGradDetailInfo(String gradCode) throws Exception;
		
	/**
	 * SPDM 공통 직책 정보 수정
	 * 
	 * @param gradCode
	 * @return
	 * @throws Exception
	 */
	int updateGradInfo(GradInfo gradInfo) throws Exception;
	
	
}