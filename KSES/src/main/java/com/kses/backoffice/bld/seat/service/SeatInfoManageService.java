package com.kses.backoffice.bld.seat.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.seat.vo.SeatInfo;

public interface SeatInfoManageService {

    List<Map<String, Object>> selectSeatInfoList(@Param("params") Map<String, Object> params) throws Exception;
	
	Map<String, Object> selectSeatInfoDetail(String seatCd) throws Exception;
	
	List<Map<String, Object>> selectReservationSeatList(Map<String, Object> params) throws Exception;
	
	int updateSeatInfo(SeatInfo vo) throws Exception;
	
	int updateSeatPositionInfo(List<SeatInfo> list) throws Exception;
	
	int deleteSeatInfo(List<String> seatList)throws Exception;
}