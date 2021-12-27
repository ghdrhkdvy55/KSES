package com.kses.backoffice.cus.kko.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.cus.kko.mapper.SureManageMapper;
import com.kses.backoffice.cus.kko.service.SureManageSevice;
import com.kses.backoffice.cus.kko.vo.MmsDataInfo;
import com.kses.backoffice.cus.kko.vo.SmsDataInfo;
import com.kses.backoffice.cus.kko.vo.SureDataInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class SureManageServiceImpl extends EgovAbstractServiceImpl implements SureManageSevice  {

	@Autowired
	private SureManageMapper sureMapper;
	
	public String selectCertifiCode() throws Exception {
		return sureMapper.selectCertifiCode();
	}

	public int insetSmsData(SmsDataInfo smsDataInfo) throws Exception {
		return sureMapper.insetSmsData(smsDataInfo);
	}
	
	public int insetMmsData(MmsDataInfo mmsDataInfo) throws Exception {
		return sureMapper.insetMmsData(mmsDataInfo);
	}
	
	public int insetSureData(SureDataInfo sureDataInfo) throws Exception {
		return sureMapper.insetSureData(sureDataInfo);
	}
}