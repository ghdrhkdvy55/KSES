package com.kses.backoffice.bas.system.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bas.system.mapper.AutoPaymentInfoManageMapper;
import com.kses.backoffice.bas.system.service.AutoPaymentInfoManageService;
import com.kses.backoffice.bas.system.vo.AutoPaymentInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class AutoPaymentInfoManageServiceImpl extends EgovAbstractServiceImpl implements AutoPaymentInfoManageService {

	@Autowired
	AutoPaymentInfoManageMapper autoPaymentMapper;
	
	@Override
	public List<Map<String, Object>> selectAutoPaymentInfoList() throws Exception {
		return autoPaymentMapper.selectAutoPaymentInfoList();
	}

	@Override
	public int updateAutoPaymentInfo(List<AutoPaymentInfo> AutoPaymentInfoList) throws Exception {
		return autoPaymentMapper.updateAutoPaymentInfo(AutoPaymentInfoList);
	}
}