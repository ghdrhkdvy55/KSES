package com.kses.backoffice.bas.kiosk.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bas.kiosk.vo.KioskInfo;

public interface KioskInfoService {
	
	/**
	 * KSES 장비 목록 조회
	 * @param params
	 * @return
	 * @throws Exception
	 */
    List<Map<String, Object>> selectKioskInfoList(Map<String, Object> params) throws Exception;
	
    /* 상세 정보 조회 -> 장비 상세 정보를  kiosk.jsp rowData 값으로 가져와 주석처리 
     * 
     * Map<String, Object> selectKioskInfoDetail(String ticketMchnSno) throws Exception;
     */
    
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
    
}
