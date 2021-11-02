package com.kses.backoffice.sys.board.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.sys.board.mapper.BoardInfoManageMapper;
import com.kses.backoffice.sys.board.service.BoardInfoManageService;
import com.kses.backoffice.sys.board.vo.BoardInfo;

@Service
public class BoardInfoManageServiceImpl extends EgovAbstractServiceImpl implements BoardInfoManageService {
	
	@Autowired
	private BoardInfoManageMapper boardMapper;

	@Override
	public List<Map<String, Object>> selectBoardManageListByPagination(Map<String, Object> SearchVO) throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.selectBoardManageListByPagination(SearchVO);
	}
	
	@Override
	public List<Map<String, Object>> selectBoardMainManageListByPagination()
			throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.selectBoardMainManageListByPagination();
	}

	
	@Override
	public Map<String, Object> selectBoardManageView(String boardSeq) throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.selectBoardManageView(boardSeq);
	}
	
	@Override
	public int updateBoardManage(BoardInfo vo) throws Exception {
		// TODO Auto-generated method stub
		return vo.getMode().equals("Ins") ? boardMapper.insertBoardManage(vo) : boardMapper.updateBoardManage(vo);
	}

	@Override
	public int deleteBoardManage(String boardSeq) throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.deleteBoardManage(boardSeq);
	}

	@Override
	public int updateBoardVisitedManage(String boardSeq) throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.updateBoardVisitedManage(boardSeq);
	}
	@Override
	public int updateBoardNoticeUseYn() throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.updateBoardNoticeUseYn();
	}

	@Override
	public int updateBoardTopSeq() throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.updateBoardTopSeq();
	}

	@Override
	public String selectBoardUploadFileName(String boardSeq) throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.selectBoardUploadFileName(boardSeq);
	}

	@Override
	public String selectBoardoriginalFileName(String boardSeq) throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.selectBoardoriginalFileName(boardSeq);
	}
}