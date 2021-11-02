package com.kses.backoffice.sys.board.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.sys.board.vo.BoardInfo;

public interface BoardInfoManageService {

    List<Map<String, Object>> selectBoardManageListByPagination(Map<String, Object> SearchVO) throws Exception;
	
    List<Map<String, Object>> selectBoardMainManageListByPagination() throws Exception;
    
    Map<String, Object> selectBoardManageView(String boardSeq) throws Exception;
	
    int updateBoardManage(BoardInfo vo) throws Exception;
    
    int updateBoardVisitedManage(String  boardSeq) throws Exception;
	
    int deleteBoardManage(String  boardSeq) throws Exception;

	int updateBoardNoticeUseYn() throws Exception;

	int updateBoardTopSeq() throws Exception;

	String selectBoardUploadFileName(String boardSeq) throws Exception;

	String selectBoardoriginalFileName(String boardSeq) throws Exception;

}
