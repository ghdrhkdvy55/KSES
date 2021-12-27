package com.kses.backoffice.cus.kko.service;


import com.kses.backoffice.cus.kko.vo.MmsDataInfo;
import com.kses.backoffice.cus.kko.vo.SmsDataInfo;
import com.kses.backoffice.cus.kko.vo.SureDataInfo;

public interface SureManageSevice {
	public String selectCertifiCode() throws Exception;
	
	public int insetSmsData(SmsDataInfo smsDataInfo) throws Exception;
	
	public int insetMmsData(MmsDataInfo mmsDataInfo) throws Exception;
	
	public int insetSureData(SureDataInfo sureDataInfo) throws Exception;
}
