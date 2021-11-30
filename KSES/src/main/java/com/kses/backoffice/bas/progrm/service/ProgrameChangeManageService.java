package com.kses.backoffice.bas.progrm.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bas.progrm.vo.ProgrameChangeInfo;


public interface ProgrameChangeManageService {


	/**
	 * 프로그램변경요청 정보를 조회
	 * @param vo ProgrmManageDtlVO
	 * @return ProgrmManageDtlVO  프로그램변경요청 리스트
	 * @exception Exception
	 */
	Map<String, Object> selectProgrmChangeRequst(Map<String, Object> vo) throws Exception;

	/**
	 * 프로그램변경요청 목록을 조회
	 * @param vo ComDefaultVO
	 * @return List
	 * @exception Exception
	 */
	List<Map<String, Object>> selectProgrmChangeRequstList(Map<String, Object> vo) throws Exception;

	int updateProgrmChangeRequst(ProgrameChangeInfo vo) throws Exception;

	/**
	 * 프로그램변경요청을 삭제
	 * @param vo ProgrmManageDtlVO
	 * @exception Exception
	 */
	void deleteProgrmChangeRequst(ProgrameChangeInfo vo) throws Exception;

	/**
	 * 프로그램변경요청 요청번호MAX 정보를 조회
	 * @param vo ProgrmManageDtlVO
	 * @return ProgrmManageDtlVO
	 * @exception Exception
	 */
	String selectProgrmChangeRequstNo() throws Exception;

	/**
	 * 프로그램변경요청처리 목록을 조회
	 * @param vo ComDefaultVO
	 * @return List
	 * @exception Exception
	 */
	List<Map<String, Object>> selectChangeRequstProcessList(Map<String, Object> vo) throws Exception;


	/**
	 * 프로그램변경요청처리를 수정
	 * @param vo ProgrmManageDtlVO
	 * @exception Exception
	 */
	int updateProgrmChangeRequstProcess(ProgrameChangeInfo vo) throws Exception;

	
	
}
