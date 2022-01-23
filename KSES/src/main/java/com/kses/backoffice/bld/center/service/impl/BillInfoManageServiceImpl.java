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
	public int updateBillInfo(BillInfo vo) throws Exception {
		String checkQuery = "BILL_DVSN = ["+ vo.getBillDvsn() + "[ AND CENTER_CD = ["+ vo.getCenterCd() + "[";
		checkQuery += vo.getMode().equals("Edt") ? " AND BILL_SEQ != [" + vo.getBillSeq() + "[" : "";
		
		if(uniService.selectIdDoubleCheck("BILL_DVSN", "TSER_BILL_INFO_I", checkQuery) > 0) {
			return -1;
		}
		
		return vo.getMode().equals("Edt") ? billMapper.updateBillInfo(vo) : billMapper.insertBillInfo(vo);
	}
	
	@Override
	public int updateBillDayInfo(List<BillDayInfo> billDayInfoList) throws Exception {
		return billMapper.updateBillDayInfo(billDayInfoList);
	}

	@Override
	public int deleteBillInfo(String billSeq) throws Exception {
		return billMapper.deleteBillInfo(billSeq);
	}
}