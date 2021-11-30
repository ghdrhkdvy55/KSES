package com.kses.backoffice.bas.code.service;

import java.util.List;
import java.util.Map;
import com.kses.backoffice.bas.code.vo.CmmnDetailCode;


public interface EgovCcmCmmnDetailCodeManageService {

	/**
	 * 공통상세코드를 삭제한다.
	 * @param cmmnDetailCode
	 * @throws Exception
	 */
	int deleteCmmnDetailCode(String  code) throws Exception;

	/**
	 * 공통상세코드 상세항목을 조회한다.
	 * @param cmmnDetailCode
	 * @return CmmnDetailCode(공통상세코드)
	 * @throws Exception
	 */
	List<Map<String, Object>> selectCmmnDetailCombo (String code) throws Exception;
	
	List<Map<String, Object>> selectCmmnDetailAjaxCombo (String code) throws Exception;
	/**
	 * 공통상세코드 상세항목을 조회한다.
	 * @param cmmnDetailCode
	 * @return CmmnDetailCode(공통상세코드)
	 * @throws Exception
	 */
	List<CmmnDetailCode> selectCmmnDetailComboEtc(Map<String, Object> params) throws Exception;
	
	CmmnDetailCode selectCmmnDetailCodeDetail(CmmnDetailCode vo) throws Exception;

	/**
	 * 공통상세코드 목록을 조회한다.
	 * @param searchVO
	 * @return List(공통상세코드 목록)
	 * @throws Exception
	 */
	
	Map<String, Object> selectCmmnDetail(String code) throws Exception;
	
	List<Map<String, Object>> selectComboSwcCon()throws Exception;
	
	List<?> selectCmmnDetailCodeList(String codeId) throws Exception;

	/**
	 * 공통상세코드를 수정한다.
	 * @param cmmnDetailCode
	 * @throws Exception
	 */
    int updateCmmnDetailCode(CmmnDetailCode cmmnDetailCode) throws Exception;
    
	Object selectCmmnDetailResTypeCombo(Map<String, Object> vo) throws Exception;
}
