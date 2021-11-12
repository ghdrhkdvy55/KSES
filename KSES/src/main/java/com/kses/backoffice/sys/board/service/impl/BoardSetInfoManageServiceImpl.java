package com.kses.backoffice.sys.board.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.sys.board.mapper.BoardSetInfoManageMapper;
import com.kses.backoffice.sys.board.service.BoardSetInfoManageService;
import com.kses.backoffice.sys.board.vo.BoardSetInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class BoardSetInfoManageServiceImpl extends EgovAbstractServiceImpl implements BoardSetInfoManageService {

	private static final Logger LOGGER = LoggerFactory.getLogger(BoardSetInfoManageServiceImpl.class);
			
	@Autowired
	private BoardSetInfoManageMapper boardSetMapper;

	@Override
	public List<Map<String, Object>> selectBoardSettingInfoList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return boardSetMapper.selectBoardSettingInfoList(params);
	}

	@Override
	public Map<String, Object> selectBoardSettingInfoDetail(String boardCd) throws Exception {
		// TODO Auto-generated method stub
		return boardSetMapper.selectBoardSettingInfoDetail(boardCd);
	}

	@Override
	public int updateBoardSetInfo(BoardSetInfo vo) throws Exception {
		// TODO Auto-generated method stub
		int ret = 0;
		try {
			if (vo.getMode().equals("Ins")) {
				boardSetMapper.insertBoardSettingInfo(vo);
			}else {
				boardSetMapper.updateBoardSettingInfo(vo);
			}
			
			return 1;
		}catch(Exception e) {
			LOGGER.error("updateBoardSetInfo error:" + e.toString());
			return 0;
		}
	}

	@Override
	public boolean deleteBoardSetInfo(String delCd) throws Exception {
		// TODO Auto-generated method stub
		try {
			boardSetMapper.deleteBoardSettingInfo(SmartUtil.dotToList(delCd));
			return true;
		}catch(Exception e) {
			LOGGER.error("deleteAuthInfo error:" + e.toString());
			return false;
		}
	}
	
	
	
}
