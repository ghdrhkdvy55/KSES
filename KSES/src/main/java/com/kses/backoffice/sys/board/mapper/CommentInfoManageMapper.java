package com.kses.backoffice.sys.board.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import com.kses.backoffice.sys.board.vo.BoardCommInfo;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface CommentInfoManageMapper {

	public List<Map<String, Object>> selectCommentManageListByPagination(@Param("params") Map<String, Object> params ) throws Exception;

	public Map<String, Object> selectCommentManageDetail(String cmntNo) throws Exception;

	public int insertCommentManage(BoardCommInfo vo) throws Exception;
		
	public int updateCommentManage(BoardCommInfo vo) throws Exception;

	public int deleteCommentManage(String  cmntNo) throws Exception;
}
