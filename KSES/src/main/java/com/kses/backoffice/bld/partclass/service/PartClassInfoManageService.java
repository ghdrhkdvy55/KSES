package com.kses.backoffice.bld.partclass.service;

import java.util.List; import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.partclass.vo.PartClassInfo;
  
  
public interface PartClassInfoManageService {

	/**
	* 장비 관리 목록 조회
	* 
	* @param searchVO
	* @return
	* @throws Exception
	*/

	List<Map<String, Object>> selectPartClassList (@Param("params") Map<String, Object> searchVO) throws Exception;

	/**
	* 장비 정보 등록
	* 
	* @param partClassInfo
	* @return
	* @throws Exception
	*/

	int insertPartClassInfo(PartClassInfo partClassInfo) throws Exception;

	/**
	* 구역 정보 수정
	* 
	* @param partClassInfo
	* @return
	* @throws Exception
	*/

	int updatePartClassInfo(PartClassInfo partClassInfo) throws Exception;

	/**
	* 구역 정보 삭제
	* 
	* @param partSeq
	* @return
	* @throws Exception
	*/
	int deletePartClassInfo(String partSeq) throws Exception; 
}
		 