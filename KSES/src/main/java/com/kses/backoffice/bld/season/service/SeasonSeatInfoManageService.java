package com.kses.backoffice.bld.season.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bld.season.vo.SeasonSeatInfo;

public interface SeasonSeatInfoManageService {

    List<Map<String, Object>> selectSeasonSeatInfoList(Map<String, Object> params);
	
	Map<String, Object> selectSeasonSeatInfoDetail(String seasonSeatCd);
	
	public List<Map<String, Object>> selectReservationSeasonSeatList(Map<String, Object> params);
		
	int updateSeasonSeatInfo(SeasonSeatInfo vo);
	
	int updateSeasonSeatPositionInfo(List<SeasonSeatInfo> seasonSeatList);
	
	int deleteSeasonSeatInfo(List<String> seasonSeatList);
}