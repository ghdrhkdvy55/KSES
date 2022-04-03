package com.kses.backoffice.bas.kiosk.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bas.kiosk.vo.KioskInfo;

public interface KioskInfoService {
	
    List<Map<String, Object>> selectKioskInfoList(Map<String, Object> params) throws Exception;
	
    Map<String, Object> selectKioskInfoDetail(String ticketMchnSno) throws Exception;
	
    int updateKioskInfo(KioskInfo vo) throws Exception;

    int deleteKioskInfo(List<String> kioskList)throws Exception;
    
	/**
	 * SPDM 무인발권기 조회 시 지점 체크
	 * 
	 * @param params
	 * @return
	 */
	public Map<String, Object> selectTicketMchnSnoCheck(@Param("params") Map<String, Object> params);
}
