package com.kses.backoffice.bld.seat.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bld.seat.mapper.SeatInfoManageMapper;
import com.kses.backoffice.bld.seat.service.SeatInfoManageService;
import com.kses.backoffice.bld.seat.vo.SeatInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class SeatInfoManageServiceImpl extends EgovAbstractServiceImpl implements SeatInfoManageService{

	@Autowired
	private SeatInfoManageMapper seatMapper;

	@Override
	public List<Map<String, Object>> selectSeatInfoList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return seatMapper.selectSeatInfoList(params);
	}

	@Override
	public Map<String, Object> selectSeatInfoDetail(String seatCd) throws Exception {
		// TODO Auto-generated method stub
		return seatMapper.selectSeatInfoDetail(seatCd);
	}

	@Override
	public int updateSeatInfo(SeatInfo vo) throws Exception {
		// TODO Auto-generated method stub
		return vo.getMode().equals("Ins") ?  seatMapper.insertSeatInfo(vo) :  seatMapper.updateSeatInfo(vo);
	}

	@Override
	public int updateSeatPositionInfo(List<SeatInfo> list) throws Exception {
		// TODO Auto-generated method stub
		return seatMapper.updateSeatPositionInfo(list);
	}

	@Override
	public int deleteSeatQrInfo(List<String> seatList) throws Exception {
		// TODO Auto-generated method stub
		return seatMapper.deleteSeatQrInfo(seatList);
	}
}