package com.kses.backoffice.cus.kko.service;

import java.util.Map;

import com.kses.backoffice.cus.kko.vo.MmsDataInfo;
import com.kses.backoffice.cus.kko.vo.SmsDataInfo;

public interface SureManageSevice {
	public String selectCertifiCode() throws Exception;
	
	public int insertSmsData(SmsDataInfo smsDataInfo) throws Exception;
	
	public int insertMmsData(MmsDataInfo mmsDataInfo) throws Exception;
	
	public boolean insertResvSureData(String msgDvsn, Map<String, Object> resvInfo) throws Exception;
}
