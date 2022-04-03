package com.kses.backoffice.sys.board.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.sys.board.vo.BoardSetInfo;

public interface BoardSetInfoManageService {

	
    List<Map<String, Object>> selectBoardSettingInfoList(@Param("params") Map<String, Object> params) throws Exception;
    
    Map<String, Object> selectBoardSettingInfoDetail(String boardCd) throws Exception;
    
    int updateBoardSetInfo(BoardSetInfo vo) throws Exception;
    
    boolean deleteBoardSetInfo(String delCd) throws Exception;
}
