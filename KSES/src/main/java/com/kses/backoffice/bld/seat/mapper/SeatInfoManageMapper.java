package com.kses.backoffice.bld.seat.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.seat.vo.SeatInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface SeatInfoManageMapper {

	public List<Map<String, Object>> selectSeatInfoList(@Param("params") Map<String, Object> params);
	
	public Map<String, Object> selectSeatInfoDetail(@Param("seatCd") String seatCd);
		
	public List<Map<String, Object>> selectReservationSeatList(@Param("params") Map<String, Object> params);
	
	public int insertSeatInfo(SeatInfo vo);
	
	public int insertFloorSeatInfo(@Param("params") Map<String, Object> params);
		
	public int updateSeatInfo(SeatInfo vo);
	
	public int updateSeatPositionInfo(@Param("seatInfoList") List<SeatInfo> seatInfoList);
	
	public int deleteSeatInfo(@Param("seatInfoList") List<String> seatList);
	
}