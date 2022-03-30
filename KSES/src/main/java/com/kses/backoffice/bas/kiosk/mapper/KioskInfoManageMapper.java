package com.kses.backoffice.bas.kiosk.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bas.kiosk.vo.KioskInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface KioskInfoManageMapper {
	public List<Map<String, Object>> selectKioskInfoList(@Param("params") Map<String, Object> params);

//  장비 상세 정보 사용하지 않음
	public Map<String, Object> selectKioskInfoDetail(String ticketMchnSno);
	   
    public int insertKioskInfo(KioskInfo kioskInfo);
	
    public int updateKioskInfo(KioskInfo kioskInfo);
    
    public int deleteKioskInfo(@Param("kioskList") List<String> kioskList);
	
	public Map<String, Object> selectTicketMchnSnoCheck(@Param("params") Map<String, Object> params);
}
