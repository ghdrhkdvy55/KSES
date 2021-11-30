package com.kses.backoffice.bas.menu.service;

import java.util.List;
import java.util.Map;

import egovframework.com.cmm.ComDefaultVO;
import com.kses.backoffice.bas.menu.vo.MenuCreatInfo;

public interface MenuCreateManageService {

	/**
	 * 메뉴생성 내역을 조회
	 * @param  vo MenuCreatVO
	 * @return List
	 * @exception Exception
	 */
	List<Map<String, Object>> selectMenuCreatList(String authorCode) throws Exception;
	
	List<Map<String, Object>> selectMenuCreatList_Author(String authorCode)throws Exception;
	
	/**
	 * 메뉴생성관리 총건수를 조회한다.
	 * @param vo ComDefaultVO
	 * @return int
	 * @exception Exception
	 */
	int selectMenuCreatManagTotCnt(String searchKeyword) throws Exception;
	
	/**
	 * ID 존재여부를 조회
	 * @param vo ComDefaultVO
	 * @return int
	 * @exception Exception
	 */
	int selectUsrByPk(String empNo) throws Exception;

	/**
	 * ID에 대한 권한코드를 조회
	 * @param vo ComDefaultVO
	 * @return List
	 * @exception Exception
	 */
	MenuCreatInfo selectAuthorByUsr(String empNo) throws Exception;


	/**
	 * 메뉴생성관리 목록을 조회
	 * @param vo ComDefaultVO
	 * @return List
	 * @exception Exception
	 */
	List<Map<String, Object>> selectMenuCreatManagList(Map<String, Object> searchVO) throws Exception;

	/**
	 * 화면에 조회된 메뉴정보로 메뉴생성내역 데이터베이스에서 입력
	 * @param checkedScrtyForInsert String
	 * @param checkedMenuNoForInsert String
	 * @exception Exception
	 */
	void insertMenuCreatList(String checkedAuthorForInsert, String checkedMenuNoForInsert) throws Exception;
}
