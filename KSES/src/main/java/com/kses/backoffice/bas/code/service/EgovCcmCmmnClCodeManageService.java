package com.kses.backoffice.bas.code.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bas.code.vo.CmmnClCode;


public interface EgovCcmCmmnClCodeManageService {

	/**
	 * 공통분류코드를 삭제한다.
	 * @param cmmnClCode
	 * @throws Exception
	 */
	int deleteCmmnClCode(CmmnClCode cmmnClCode) throws Exception;

	
	/**
	 * 공통분류코드 상세항목을 조회한다.
	 * @param cmmnClCode
	 * @return CmmnClCode(공통분류코드)
	 * @throws Exception
	 */
	Map<String, Object> selectCmmnClCodeDetail(String clCode) throws Exception;

	/**
	 * 공통분류코드 목록을 조회한다.
	 * @param searchVO
	 * @return List(공통분류코드 목록)
	 * @throws Exception
	 */
	List<?> selectCmmnClCodeList(Map<String, Object> searchVO) throws Exception;

  
	/**
	 * 공통분류코드를 수정한다.
	 * @param cmmnClCode
	 * @throws Exception
	 */
    int updateCmmnClCode(CmmnClCode cmmnClCode) throws Exception;
}
