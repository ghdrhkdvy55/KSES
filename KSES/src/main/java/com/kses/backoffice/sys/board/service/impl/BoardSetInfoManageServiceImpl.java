package com.kses.backoffice.sys.board.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bas.authority.vo.AuthInfo;
import com.kses.backoffice.sys.board.mapper.BoardSetInfoManageMapper;
import com.kses.backoffice.sys.board.service.BoardSetInfoManageService;
import com.kses.backoffice.sys.board.vo.BoardSetInfo;
import com.kses.backoffice.util.SmartUtil;
import com.kses.backoffice.util.mapper.UniSelectInfoManageMapper;

import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class BoardSetInfoManageServiceImpl extends EgovAbstractServiceImpl implements BoardSetInfoManageService {

	private static final Logger LOGGER = LoggerFactory.getLogger(BoardSetInfoManageServiceImpl.class);
			
	@Autowired
	private BoardSetInfoManageMapper boardSetMapper;

	@Autowired
	private UniSelectInfoManageMapper uniMapper;

	@Override
	public List<Map<String, Object>> selectBoardSettingInfoList(Map<String, Object> params) throws Exception {
		return boardSetMapper.selectBoardSettingInfoList(params);
	}

	@Override
	public Map<String, Object> selectBoardSettingInfoDetail(String boardCd) throws Exception {
		return boardSetMapper.selectBoardSettingInfoDetail(boardCd);
	}

	@Override
	public int insertBoardInfo(BoardSetInfo vo) throws Exception {
		int cnt = uniMapper.selectIdDoubleCheck("BOARD_CD", "TSES_BRDSET_INFO_M", "BOARD_CD = ["+ vo.getBoardCd() + "[" );
		
		if(cnt == 0) {
			try {
				boardSetMapper.insertBoardInfo(vo);
				return 1;
			}catch(Exception e) {
				LOGGER.error("insertBoardInfo error:" + e.toString());
				return -1;
			}
			
		}else {
			return -1;
		}
	}
	
	@Override
	public int updateBoardInfo(BoardSetInfo vo) throws Exception {
		try {
			boardSetMapper.updateBoardInfo(vo);
			return 1;
		}catch (Exception e) {
			LOGGER.error("updateBoardInfo error:" + e.toString());
			return -1;
		}
	}

	@Override
	public void deleteBoardSetInfo(String delCd) throws Exception {
		boardSetMapper.deleteBoardSettingInfo(SmartUtil.dotToList(delCd));
	}
	
	
	
}
