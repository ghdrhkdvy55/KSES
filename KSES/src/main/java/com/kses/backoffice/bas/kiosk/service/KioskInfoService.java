package com.kses.backoffice.bas.kiosk.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bas.kiosk.vo.KioskInfo;

public interface KioskInfoService {
	
	/**
	 * KSES 장비 목록 조회
	 * @param params
	 * @return
	 * @throws Exception
	 */
    List<Map<String, Object>> selectKioskInfoList(Map<String, Object> params) throws Exception;
	
    /**
     * KSES 장비 정보 수정
     * @param kioskInfo
     * @return
     * @throws Exception
     */
    int updateKioskInfo(KioskInfo kioskInfo) throws Exception;
    
    /**
     * KSES 장비 정보 등록
     * @param kioskInfo
     * @return
     * @throws Exception
     */
    int insertKioskInfo(KioskInfo kioskInfo) throws Exception;

    /**
     * KSES 장비 정보 삭제
     * @param kioskList
     * @return
     * @throws Exception
     */
    int deleteKioskInfo(List<String> kioskList)throws Exception;
    
	/**
	 * SPDM 무인발권기 조회 시 지점 체크
	 * 
	 * @param params
	 * @return
	 */
	public Map<String, Object> selectTicketMchnSnoCheck(@Param("params") Map<String, Object> params);
}
