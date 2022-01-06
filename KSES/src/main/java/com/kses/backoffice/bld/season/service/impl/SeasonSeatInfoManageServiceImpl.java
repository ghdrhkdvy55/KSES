package com.kses.backoffice.bld.season.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bld.season.mapper.SeasonSeatInfoManageMapper;
import com.kses.backoffice.bld.season.service.SeasonSeatInfoManageService;
import com.kses.backoffice.bld.season.vo.SeasonSeatInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class SeasonSeatInfoManageServiceImpl extends EgovAbstractServiceImpl implements SeasonSeatInfoManageService{

	@Autowired
	private SeasonSeatInfoManageMapper seasonSeatMapper;
	
	@Override
	public List<Map<String, Object>> selectSeasonSeatInfoList(Map<String, Object> params) {
		return seasonSeatMapper.selectSeasonSeatInfoList(params);
	}

	@Override
	public Map<String, Object> selectSeasonSeatInfoDetail(String seasonSeatCd) {
		return seasonSeatMapper.selectSeasonSeatInfoDetail(seasonSeatCd);
	}
	
	@Override
	public List<Map<String, Object>> selectReservationSeasonSeatList(Map<String, Object> params) {
		return seasonSeatMapper.selectReservationSeasonSeatList(params);
	}

	@Override
	public int updateSeasonSeatInfo(SeasonSeatInfo vo) {
		return seasonSeatMapper.updateSeasonSeatInfo(vo);
	}

	@Override
	public int updateSeasonSeatPositionInfo(List<SeasonSeatInfo> seasonSeatList) {
		return seasonSeatMapper.updateSeasonSeatPositionInfo(seasonSeatList);
	}

	@Override
	public int deleteSeasonSeatInfo(List<String> seasonSeatList) {
		return seasonSeatMapper.deleteSeasonSeatInfo(seasonSeatList);
	}

}