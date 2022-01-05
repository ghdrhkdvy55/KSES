package com.kses.backoffice.rsv.reservation.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.rsv.reservation.mapper.ResTimeInfoManageMapper;
import com.kses.backoffice.rsv.reservation.service.ResTimeInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.ResTimeInfo;

@Service
public class ResTimeInfoManageServiceImpl extends EgovAbstractServiceImpl implements ResTimeInfoManageService {

	@Autowired
	private ResTimeInfoManageMapper timeMapper;

	@Override
	public List<Map<String, Object>> selectSTimeInfoBarList(Map<String, Object> searchVO) throws Exception {
		return timeMapper.selectSTimeInfoBarList(searchVO);
	}

	@Override
	public List<ResTimeInfo> selectLTimeInfoBarList(ResTimeInfo searchVO) throws Exception {
		return timeMapper.selectLTimeInfoBarList(searchVO);
	}

	@Override
	public int updateTimeInfo(Map<String, Object> vo) throws Exception {
		return timeMapper.updateTimeInfo(vo);
	}
	
	@Override
	public int selectResPreCheckInfoL(Map<String, Object> searchVO) throws Exception {
		return timeMapper.selectResPreCheckInfoL(searchVO);
	}
	@Override
	public int selectResPreCheckInfoL1(Map<String, Object> searchVO) throws Exception {
		return timeMapper.selectResPreCheckInfoL1(searchVO);
	}

	@Override
	public int updateTimeInfoL(Map<String, Object> searchVO) throws Exception {
		return timeMapper.updateTimeInfoL(searchVO);
	}
	
	@Override
	public int updateTimeInfoL1(Map<String, Object> searchVO) throws Exception {
		return timeMapper.updateTimeInfoL1(searchVO);
	}

	@Override
	public int resTimeReset(ResTimeInfo vo) throws Exception {
		return timeMapper.resTimeReset(vo);
	}
	@Override
	public String selectTimeUp(String endTime) throws Exception {
		return timeMapper.selectTimeUp(endTime);
	}

	@Override
	public int multiResTimeReset() throws Exception {
		return timeMapper.multiResTimeReset();
	}

	@Override
	public int updateTimeInfoY(ResTimeInfo vo) throws Exception {
		return timeMapper.updateTimeInfoY(vo);
	}

	@Override
	public int inseretTimeCreate() throws Exception {
		return timeMapper.inseretTimeCreate();
	}

	@Override
	public int selectResPreCheckInfo(Map<String, Object> searchVO) throws Exception {
		return timeMapper.selectResPreCheckInfo(searchVO);
	}

	@Override
	public List<Map<String, Object>> selectSeatStateInfo(Map<String, Object> params) throws Exception {
		return timeMapper.selectSeatStateInfo(params);
	}

	@Override
	public List<Map<String, Object>> selectSeatSearchResult(Map<String, Object> params) throws Exception {
		return timeMapper.selectSeatSearchResult(params);
	}

	@Override
	public int selectResSeatPreCheckInfo(Map<String, Object> params) throws Exception {
		return timeMapper.selectResSeatPreCheckInfo(params);
	}
}