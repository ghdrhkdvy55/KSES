package com.kses.backoffice.bas.code.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bas.code.vo.CmmnCode;


public interface EgovCcmCmmnCodeManageService {

	
	List<Map<String, Object>> selectCmmnCodeListByPagination(Map<String, Object> vo) throws Exception;
	/**
	 * 공통코드를 삭제한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	int deleteCmmnCode(String codeId) throws Exception;
	     
	/**
	 * 공통코드 상세항목을 조회한다.
	 * @param cmmnCode
	 * @return CmmnCode(공통코드)
	 * @throws Exception
	 */
	Map<String, Object> selectCmmnCodeDetail(String codeId) throws Exception;

	/**
	 * 공통코드 목록을 조회한다.
	 * @param searchVO
	 * @return List(공통코드 목록)
	 * @throws Exception
	 */
	List<?> selectCmmnCodeList() throws Exception;

	/**
	 * 공통코드를 수정한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	int updateCmmnCode(CmmnCode cmmnCode) throws Exception;

}
