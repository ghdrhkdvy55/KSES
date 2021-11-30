package com.kses.backoffice.rsv.reservation.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.rsv.reservation.vo.ResTimeInfo;

public interface ResTimeInfoManageService {

	    //단일 예약
	    List<Map<String, Object>> selectSTimeInfoBarList(Map<String, Object>  searchVO) throws Exception;
		//장기 예약 
		List<ResTimeInfo> selectLTimeInfoBarList(ResTimeInfo searchVO) throws Exception;
	    //좌석 검색 
		List <Map<String, Object>> selectSeatSearchResult(Map<String, Object> params)throws Exception;
		//좌석 현황 
		List <Map<String, Object>> selectSeatStateInfo(Map<String, Object> params) throws Exception;
		//
		String selectTimeUp(String endTime) throws Exception;
		// 장기 예약 
		int selectResPreCheckInfoL(Map<String, Object> searchVO) throws Exception;
		//장기 기간 시작 끝 시간
		int selectResPreCheckInfoL1(Map<String, Object> searchVO) throws Exception;
		
		int selectResPreCheckInfo(Map<String, Object> searchVO) throws Exception;
		//좌석 중복 예약 체크
		int selectResSeatPreCheckInfo( Map<String, Object> params) throws Exception;
		//시간바 업데이트 
		int inseretTimeCreate() throws Exception;
		//추후 변경 예정 
		int updateTimeInfoL(Map<String, Object> searchVO) throws Exception;
		
		int updateTimeInfoL1(Map<String, Object> searchVO) throws Exception;
		
		int updateTimeInfo(Map<String, Object> vo) throws Exception;
		
		int updateTimeInfoY(ResTimeInfo vo) throws Exception;
		
		int resTimeReset(ResTimeInfo vo) throws Exception;
		
		int multiResTimeReset() throws Exception;
}