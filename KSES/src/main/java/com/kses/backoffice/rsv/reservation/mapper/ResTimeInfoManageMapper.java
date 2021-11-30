package com.kses.backoffice.rsv.reservation.mapper;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.rsv.reservation.vo.ResTimeInfo;

@Mapper
public interface ResTimeInfoManageMapper {
    //단일 예약
	public List<Map<String, Object>> selectSTimeInfoBarList(@Param("params") Map<String, Object> params);
	
	//좌석 검색 리스트 
	public List <Map<String, Object>> selectSeatSearchResult(@Param("params") Map<String, Object> params);
	//좌석 예약 리스트 
	public List <Map<String, Object>> selectSeatStateInfo(@Param("params") Map<String, Object> params);
	//장기 예약 
	public List<ResTimeInfo> selectLTimeInfoBarList(ResTimeInfo searchVO);
	//예약 체크
	public int selectResPreCheckInfo(@Param("params") Map<String, Object> params);
	//좌석 동일 시간때 중복 예약 체크
	public int selectResSeatPreCheckInfo(@Param("params") Map<String, Object> params);
	//장기 일반
	public int selectResPreCheckInfoL(@Param("params") Map<String, Object> params);
	//장기 시작일 시작 시간 부터 종료일 끝 시간 까지 
	public int selectResPreCheckInfoL1(@Param("params") Map<String, Object> params);
	
	public int inseretTimeCreate();
	
	public String selectTimeUp(String endTime);
	//단기 예약
	public int updateTimeInfo(@Param("params") Map<String, Object> params);
    //장기 일반
	public int updateTimeInfoL(@Param("params") Map<String, Object> params);
	//장기 시작일 시작 시간 부터 종료일 끝 시간 까지 
	public int updateTimeInfoL1(@Param("params") Map<String, Object> params);
	
	public int updateTimeInfoY(ResTimeInfo vo); 
	//예약 시간 정리 
	public int resTimeReset(ResTimeInfo searchVO);

	public int multiResTimeReset();
	
}