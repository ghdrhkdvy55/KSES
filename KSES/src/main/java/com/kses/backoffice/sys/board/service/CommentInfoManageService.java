package com.kses.backoffice.sys.board.service;

import java.util.List;
import java.util.Map;
import com.kses.backoffice.sys.board.vo.BoardCommInfo;

public interface CommentInfoManageService {

	List<Map<String, Object>> selectCommentManageListByPagination(Map<String, Object> params ) throws Exception;

	Map<String, Object> selectCommentManageDetail(String cmntNo) throws Exception;

	int updateCommentManage(BoardCommInfo vo) throws Exception;

	int deleteCommentManage(String  cmntNo) throws Exception;
}
