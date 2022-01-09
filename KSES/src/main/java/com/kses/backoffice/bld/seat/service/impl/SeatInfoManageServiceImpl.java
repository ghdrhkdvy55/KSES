package com.kses.backoffice.bld.seat.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bld.seat.mapper.SeatInfoManageMapper;
import com.kses.backoffice.bld.seat.service.SeatInfoManageService;
import com.kses.backoffice.bld.seat.vo.SeatInfo;

import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class SeatInfoManageServiceImpl extends EgovAbstractServiceImpl implements SeatInfoManageService{

	@Autowired
	private SeatInfoManageMapper seatMapper;

	@Override
	public List<Map<String, Object>> selectSeatInfoList(Map<String, Object> params) throws Exception {
		return seatMapper.selectSeatInfoList(params);
	}

	@Override
	public Map<String, Object> selectSeatInfoDetail(String seatCd) throws Exception {
		return seatMapper.selectSeatInfoDetail(seatCd);
	}

	@Override
	public List<Map<String, Object>> selectReservationSeatList(Map<String, Object> params) throws Exception {
		return seatMapper.selectReservationSeatList(params);
	}
	
	@Override
	public int updateSeatInfo(SeatInfo vo) throws Exception {
		return vo.getMode().equals(Globals.SAVE_MODE_INSERT) ?  seatMapper.insertSeatInfo(vo) :  seatMapper.updateSeatInfo(vo);
	}

	@Override
	public int updateSeatPositionInfo(List<SeatInfo> list) throws Exception {
		return seatMapper.updateSeatPositionInfo(list);
	}

	@Override
	public int deleteSeatInfo(List<String> seatList) throws Exception {
		return seatMapper.deleteSeatInfo(seatList);
	}
}