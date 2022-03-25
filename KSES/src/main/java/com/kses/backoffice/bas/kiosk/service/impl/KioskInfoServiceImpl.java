package com.kses.backoffice.bas.kiosk.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bas.kiosk.mapper.KioskInfoManageMapper;
import com.kses.backoffice.bas.kiosk.vo.KioskInfo;
import com.kses.backoffice.bas.kiosk.service.KioskInfoService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class KioskInfoServiceImpl extends EgovAbstractServiceImpl implements KioskInfoService{
	@Autowired
	private KioskInfoManageMapper kioskMapper;

	@Override
	public List<Map<String, Object>> selectKioskInfoList(Map<String, Object> params) throws Exception {
		return kioskMapper.selectKioskInfoList(params);
	}

//  장비 상세 정보(사용안함)	
	@Override 
	public Map<String, Object> selectKioskInfoDetail(String ticketMchnSno) throws Exception {
	    return kioskMapper.selectKioskInfoDetail(ticketMchnSno);
	}
	
	@Override
	public int insertKioskInfo(KioskInfo kioskInfo) throws Exception {
		return kioskMapper.insertKioskInfo(kioskInfo);
	}
	
	@Override
	public int updateKioskInfo(KioskInfo kioskInfo) throws Exception {
		return kioskMapper.updateKioskInfo(kioskInfo);
	}

	@Override
	public int deleteKioskInfo(List<String> kioskList) throws Exception {
		return kioskMapper.deleteKioskInfo(kioskList);
	}
	
	@Override
	public Map<String, Object> selectTicketMchnSnoCheck(Map<String, Object> params) {
		return kioskMapper.selectTicketMchnSnoCheck(params);
	}
}