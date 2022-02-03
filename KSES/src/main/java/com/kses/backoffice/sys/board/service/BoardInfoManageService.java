package com.kses.backoffice.sys.board.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.sys.board.vo.BoardInfo;

import egovframework.com.cmm.service.FileVO;

public interface BoardInfoManageService {

    List<Map<String, Object>> selectBoardManageListByPagination(Map<String, Object> SearchVO) throws Exception;
	
    List<Map<String, Object>> selectBoardMainManageListByPagination() throws Exception;
    
    Map<String, Object> selectBoardManageDetail(String boardSeq) throws Exception;
	
    int updateBoardManage(BoardInfo vo, List<FileVO> result ) throws Exception;
    
    int updateBoardVisitedManage(String  boardSeq) throws Exception;
	
    int deleteBoardManage(String  boardSeq) throws Exception;

	int updateBoardTopSeq() throws Exception;

	public String selectBoardUploadFileName(String boardSeq);
	
	public String selectBoardoriginalFileName(String boardSeq);
	
}
