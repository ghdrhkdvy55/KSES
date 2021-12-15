package com.kses.backoffice.bld.season.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.kses.backoffice.bld.season.vo.SeasonSeatInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper
public interface SeasonSeatInfoManageMapper {

	public List<Map<String, Object>> selectSeasonSeatInfoList(@Param("params") Map<String, Object> params);
	
	public Map<String, Object> selectSeasonSeatInfoDetail(String seasonSeatCd);
	
	public List<Map<String, Object>> selectReservationSeasonSeatList(@Param("params") Map<String, Object> params);
		
	public int updateSeasonSeatInfo(SeasonSeatInfo vo);
	
	public int updateSeasonSeatPositionInfo(@Param("seasonSeatInfoList") List<SeasonSeatInfo> seasonSeatInfoList);
	
	public int deleteSeasonSeatInfo(List<String> seasonSeatList);
}