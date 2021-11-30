package com.kses.backoffice.bas.kiosk.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bas.kiosk.vo.KioskInfo;

public interface KioskInfoService {
	
    List<Map<String, Object>> selectKioskInfoList(Map<String, Object> params) throws Exception;
	
    Map<String, Object> selectKioskInfoDetail(String ticketMchnSno) throws Exception;
	
    int updateKioskInfo(KioskInfo vo) throws Exception;

    int deleteKioskInfo(List<String> kioskList)throws Exception;
    
}
