package com.kses.backoffice.cus.kko.mapper;

import com.kses.backoffice.cus.kko.vo.MmsDataInfo;
import com.kses.backoffice.cus.kko.vo.SmsDataInfo;
import com.kses.backoffice.cus.kko.vo.SureDataInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper
public interface SureManageMapper {
	public String selectCertifiCode() throws Exception;
	
	public int insertSmsData(SmsDataInfo smsDataInfo) throws Exception;
	
	public int insertMmsData(MmsDataInfo mmsDataInfo) throws Exception;
	
	public int insertSureData(SureDataInfo sureDataInfo) throws Exception;
}
