package com.kses.backoffice.sys.board.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.sys.board.vo.BoardInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface BoardInfoManageMapper {

	
    public List<Map<String, Object>> selectBoardManageListByPagination(@Param("params") Map<String, Object> params ) throws Exception;
	
    public List<Map<String, Object>> selectBoardMainManageListByPagination() throws Exception;
    
    public Map<String, Object> selectBoardManageDetail(String boardSeq) throws Exception;
	
    public int insertBoardManage(BoardInfo vo) throws Exception;
	
    public int updateBoardManage(BoardInfo vo) throws Exception;
    
    public int updateBoardVisitedManage(String  boardSeq) throws Exception;
	
    public int deleteBoardManage(String  boardSeq) throws Exception;

	public int updateBoardTopSeq() throws Exception;

}
