package com.kses.backoffice.sys.board.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.sys.board.vo.BoardInfo;

import egovframework.com.cmm.service.FileVO;

public interface BoardInfoManageService {
	/**
	 * 게시물 목록 조회
	 * @param SearchVO
	 * @return
	 * @throws Exception
	 */
    List<Map<String, Object>> selectBoardManageListByPagination(Map<String, Object> SearchVO) throws Exception;
	
    List<Map<String, Object>> selectBoardMainManageListByPagination() throws Exception;
    /**
     * 게시물 상세 조회
     * @param boardSeq
     * @return
     * @throws Exception
     */
    Map<String, Object> selectBoardManageDetail(String boardSeq) throws Exception;
	/**
	 * 게시물 수정
	 * @param vo
	 * @param result
	 * @return
	 * @throws Exception
	 */
    int updateBoardManage(BoardInfo vo, List<FileVO> result ) throws Exception;
    
    /**
     * 게시물 등록
     * @param vo
     * @param result
     * @return
     * @throws Exception
     */
    int insertBoardManage(BoardInfo vo, List<FileVO> result ) throws Exception;
    
    int updateBoardVisitedManage(String  boardSeq) throws Exception;
	/**
	 * 게시물 삭제
	 * @param boardSeq
	 * @return
	 * @throws Exception
	 */
    int deleteBoardManage(String  boardSeq) throws Exception;

	int updateBoardTopSeq() throws Exception;
	/**
	 * 업로드 된 파일명 조회
	 * @param atchFileId
	 * @return
	 */
	public String selectBoardUploadFileName(String atchFileId);
	/**
	 * 업로드 시 기존 파일명 조회
	 * @param atchFileId
	 * @return
	 */
	public String selectBoardoriginalFileName(String atchFileId);
	
}
