package com.kses.backoffice.bld.seat.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bld.seat.mapper.QrcodeInfoManageMapper;
import com.kses.backoffice.bld.seat.service.QrcpdeInfoManageServie;
import com.kses.backoffice.bld.seat.vo.QrcodeInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class QrcpdeInfoManageServieImpl extends EgovAbstractServiceImpl implements QrcpdeInfoManageServie{

	@Autowired
	private QrcodeInfoManageMapper qrmapper;

	@Override
	public List<Map<String, Object>> selectQrCodeList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return qrmapper.selectQrCodeList(params);
	}

	@Override
	public Map<String, Object> selectQrCodeDetail(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return qrmapper.selectQrCodeDetail(params);
	}

	@Override
	public int updateQrcodeManage(QrcodeInfo vo) throws Exception {
		// TODO Auto-generated method stub
		return vo.getMode().equals("Ins") ? qrmapper.insertQrcodeManage(vo) : qrmapper.updateQrcodeManage(vo);
	}
}