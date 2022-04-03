package com.kses.backoffice.bas.menu.service;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

import com.kses.backoffice.bas.menu.vo.MenuInfo;

public interface MenuInfoService {

	/**
	 * 메뉴 상세정보를 조회
	 * @param vo ComDefaultVO
	 * @return MenuManageVO
	 * @exception Exception
	 */
	List<Map<String, Object>> selectMenuManage(String searchKeyword) throws Exception;

	/**
	 * 메뉴 목록을 조회
	 * @param vo ComDefaultVO
	 * @return List
	 * @exception Exception
	 */
	List<Map<String, Object>> selectMenuManageList(Map<String, Object> vo) throws Exception;

	/**
	 * 메뉴번호 존재 여부를 조회한다.
	 * @param vo ComDefaultVO
	 * @return int
	 * @exception Exception
	 */
	int selectMenuNoByPk(MenuInfo vo) throws Exception;


	int selectUpperMenuNoByPk(String menuNo) throws Exception;

	
	/**
	 * 메뉴 정보를 수정
	 * @param vo MenuManageVO
	 * @exception Exception
	 */
	int updateMenuManage(MenuInfo vo) throws Exception;

	/**
	 * 메뉴 정보를 삭제
	 * @param vo MenuManageVO
	 * @exception Exception
	 */
	int deleteMenuManage(String menuNo) throws Exception;

	/**
	 * 화면에 조회된 메뉴 목록 정보를 데이터베이스에서 삭제
	 * @param checkedMenuNoForDel String
	 * @exception Exception
	 */
	int deleteMenuManageList(String checkedMenuNoForDel) throws Exception;


	/*  메뉴 생성 관리  */

	/**
	 * 메뉴 목록을 조회
	 * @return List
	 * @exception Exception
	 */
	List<Map<String, Object>> selectMenuList() throws Exception;

	/*### 메뉴관련 프로세스 ###*/
	/**
	 * MainMenu Head Menu 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	List<Map<String, Object>> selectMainMenuHead(String empNo) throws Exception;

	/**
	 * MainMenu Head Left 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	List<Map<String, Object>> selectMainMenuLeft(String empNo) throws Exception;

	/**
	 * MainMenu Head MenuURL 조회
	 * @param iMenuNo int
	 * @param sUniqId String
	 * @return String
	 * @exception Exception
	 */
	String selectLastMenuURL(int iMenuNo, String sUniqId) throws Exception;

	/* 일괄처리 프로세스   */

	/**
	 * 메뉴일괄초기화 프로세스 메뉴목록테이블, 프로그램 목록테이블 전체 삭제
	 * @return boolean
	 */
	boolean menuBndeAllDelete() throws Exception;

	/**
	 * 메뉴일괄등록 프로세스
	 * @param  vo MenuManageVO
	 * @param  inputStream InputStream
	 * @exception Exception
	 */
	String menuBndeRegist(MenuInfo vo, InputStream inputStream) throws Exception;
}