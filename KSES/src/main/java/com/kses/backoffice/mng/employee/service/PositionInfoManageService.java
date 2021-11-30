package com.kses.backoffice.mng.employee.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.mng.employee.vo.PositionInfo;

/**
 * SPDM 공통 직급 정보 서비스
 * 
 * @author JangDaeHan
 *
 */
public interface PositionInfoManageService {
	
	/**
	 * SPDM 공통 직급 목록 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectPositionInfoList(@Param("params") Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 공통 직급 콤보박스 목록 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	public List<PositionInfo> selectPositionInfoComboList() throws Exception;
	
	/**
	 * SPDM 공통 직급 정보 상세 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectPositionDetailInfo(String psitCd) throws Exception;
	
	/**
	 * SPDM 공통 직급 정보 수정
	 * 
	 * @param jikwCode
	 * @return
	 * @throws Exception
	 */
	public int updateJikwInfo(PositionInfo jikwInfo) throws Exception;
	
}