package com.kses.backoffice.bas.kiosk.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bas.kiosk.mapper.KioskInfoManageMapper;
import com.kses.backoffice.bas.kiosk.vo.KioskInfo;
import com.kses.backoffice.bld.center.vo.CenterInfo;
import com.kses.backoffice.bas.kiosk.service.KioskInfoService;
import com.kses.backoffice.util.mapper.UniSelectInfoManageMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class KioskInfoServiceImpl extends EgovAbstractServiceImpl implements KioskInfoService{
	@Autowired
	private KioskInfoManageMapper kioskMapper;
	
	@Autowired
	private UniSelectInfoManageMapper uniMapper;

	@Override
	public List<Map<String, Object>> selectKioskInfoList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return kioskMapper.selectKioskInfoList(params);
	}

	@Override
	public Map<String, Object> selectKioskInfoDetail(String ticketMchnSno) throws Exception {
		// TODO Auto-generated method stub
		return kioskMapper.selectKioskInfoDetail(ticketMchnSno);
	}
	
	@Override
	public int updateKioskInfo(KioskInfo vo) throws Exception {
		int ret = 0;
		
		if (vo.getMode().equals("Ins")){
			ret = (uniMapper.selectIdDoubleCheck("TICKET_MCHN_SNO", "TSEC_TICKET_MCHN_M", "TICKET_MCHN_SNO = ["+ vo.getTicketMchnSno() + "[" ) > 0) ? -1 : kioskMapper.insertKioskInfo(vo);
		} else {
			kioskMapper.updateKioskInfo(vo);
			/*
			if (!vo.getTargetTicketMchnSno().equals(vo.getTicketMchnSno())) {
				ret = (uniMapper.selectIdDoubleCheck("TICKET_MCHN_SNO", "TSEC_TICKET_MCHN_M", "TICKET_MCHN_SNO = ["+ vo.getTicketMchnSno() + "[" ) > 0) ? -1 : kioskMapper.updateKioskInfo(vo);
			} else {
				kioskMapper.updateKioskInfo(vo);
			}
			*/
		}
		
		return ret;
	}

	@Override
	public int deleteKioskInfo(List<String> kioskList) throws Exception {
		// TODO Auto-generated method stub
		return kioskMapper.deleteKioskInfo(kioskList);
	}

}