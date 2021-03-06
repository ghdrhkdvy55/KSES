package com.kses.backoffice.bld.floor.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bld.floor.mapper.FloorInfoManageMapper;
import com.kses.backoffice.bld.floor.service.FloorInfoManageService;
import com.kses.backoffice.bld.floor.vo.FloorInfo;
import com.kses.backoffice.bld.seat.mapper.SeatInfoManageMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class FloorInfoManageServiceImpl extends EgovAbstractServiceImpl implements FloorInfoManageService{

	@Autowired
	private FloorInfoManageMapper floorMapper;
	
	@Autowired
    private SeatInfoManageMapper seatMapper;
	
	@Override
	public List<Map<String, Object>> selectFloorInfoList(Map<String, Object> params) {
		return floorMapper.selectFloorInfoList(params);
	}
	
	@Override
	public Map<String, Object> selectFloorInfoDetail(String floorCd) {
		return floorMapper.selectFloorInfoDetail(floorCd);
	}
	
	@Override
	public List<Map<String, Object>> selectFloorInfoComboList(String centerCd) {
		return floorMapper.selectFloorInfoComboList(centerCd);
	}

	@Override
	public int updateFloorInfo(FloorInfo vo) {
		return floorMapper.updateFloorInfo(vo);
	}

	@Override
	public int insertFloorSeatUpdate(Map<String, Object> params) throws Exception {
		return seatMapper.insertFloorSeatInfo(params);
	}
}