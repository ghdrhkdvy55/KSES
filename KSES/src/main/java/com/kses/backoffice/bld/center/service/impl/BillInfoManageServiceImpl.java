package com.kses.backoffice.bld.center.service.impl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bld.center.mapper.BillInfoManageMapper;
import com.kses.backoffice.bld.center.service.BillInfoManageService;
import com.kses.backoffice.bld.center.vo.BillDayInfo;
import com.kses.backoffice.bld.center.vo.BillInfo;
import com.kses.backoffice.util.service.UniSelectInfoManageService;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BillInfoManageServiceImpl extends EgovAbstractServiceImpl implements BillInfoManageService {

	@Autowired
	BillInfoManageMapper billMapper;
	
	@Autowired
	UniSelectInfoManageService uniService;
	
	@Override
	public List<Map<String, Object>> selectBillInfoList(String centerCd) throws Exception {
		return billMapper.selectBillInfoList(centerCd);
	}
	
	@Override
	public List<Map<String, Object>> selectBillDayInfoList(String centerCd) throws Exception {
		return billMapper.selectBillDayInfoList(centerCd);
	}

	@Override
	public Map<String, Object> selectBillInfoDetail(String billSeq) throws Exception {
		return billMapper.selectBillInfoDetail(billSeq);
	}

	@Override
	public int insertBillInfo(BillInfo billInfo) throws Exception {
		return billMapper.insertBillInfo(billInfo);
	}

	@Override
	public int updateBillInfo(BillInfo billInfo) throws Exception {
		return billMapper.updateBillInfo(billInfo);
	}
	
	@Override
	public int updateBillDayInfo(List<BillDayInfo> billDayInfoList) throws Exception {
		return billMapper.updateBillDayInfo(billDayInfoList);
	}

	@Override
	@Transactional
	public int deleteBillInfo(BillInfo billInfo) throws Exception {
		billMapper.updateBillDayInfoByCenterCd(billInfo);
		return billMapper.deleteBillInfo(billInfo.getBillSeq());
	}
}