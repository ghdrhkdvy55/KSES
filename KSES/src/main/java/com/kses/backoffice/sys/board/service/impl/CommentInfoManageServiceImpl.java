package com.kses.backoffice.sys.board.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.sys.board.mapper.CommentInfoManageMapper;
import com.kses.backoffice.sys.board.service.CommentInfoManageService;
import com.kses.backoffice.sys.board.vo.BoardCommInfo;

import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class CommentInfoManageServiceImpl  extends EgovAbstractServiceImpl implements CommentInfoManageService{

	@Autowired
	private CommentInfoManageMapper commtMapper;
	
	@Override
	public List<Map<String, Object>> selectCommentManageListByPagination(Map<String, Object> params) throws Exception {
		return commtMapper.selectCommentManageListByPagination(params);
	}

	@Override
	public Map<String, Object> selectCommentManageDetail(String cmntNo) throws Exception {
		return commtMapper.selectCommentManageDetail(cmntNo);
	}


	@Override
	public int updateCommentManage(BoardCommInfo vo) throws Exception {
		return !vo.getMode().equals(Globals.SAVE_MODE_INSERT)? commtMapper.updateCommentManage(vo) : commtMapper.insertCommentManage(vo);
	}

	@Override
	public int deleteCommentManage(String cmntNo) throws Exception {
		return commtMapper.deleteCommentManage(cmntNo);
	}
	
	
	

}
