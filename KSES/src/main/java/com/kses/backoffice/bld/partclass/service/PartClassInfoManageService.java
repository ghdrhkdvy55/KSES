package com.kses.backoffice.bld.partclass.service;

import java.util.List; import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.partclass.vo.PartClassInfo;
  
  
public interface PartClassInfoManageService {

	/**
	 * SPDM 구역 등급 관리 리스트 조회
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectPartClassList (@Param("params") Map<String, Object> searchVO) throws Exception;

	/**
	 * SPDM 구역 등급 관리 콤보 리스트 조회
	 * 
	 * @param centerCd
	 * @return
	 */
	List<Map<String, Object>> selectPartClassComboList (String centerCd) throws Exception;
	
	/**
	 * SPDM 구역 등급 정보 등록
	 * 
	 * @param partClassInfo
	 * @return
	 * @throws Exception
	 */
	int insertPartClassInfo(PartClassInfo partClassInfo) throws Exception;

	/**
	 * SPDM 구역 등급 정보 갱신
	 * 
	 * @param partClassInfo
	 * @return
	 * @throws Exception
	 */
	int updatePartClassInfo(PartClassInfo partClassInfo) throws Exception;

	/**
	 * SPDM 구역 등급 정보 삭제
	 * 
	 * @param partClassSeq
	 * @return
	 * @throws Exception
	 */
	int deletePartClassInfo(String partClassSeq) throws Exception; 
}
		 