package com.kses.backoffice.cus.kko.service.impl;

import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.cus.kko.mapper.SureManageMapper;
import com.kses.backoffice.cus.kko.service.SureManageSevice;
import com.kses.backoffice.cus.kko.vo.MmsDataInfo;
import com.kses.backoffice.cus.kko.vo.SmsDataInfo;
import com.kses.backoffice.cus.kko.vo.SureDataInfo;
import com.kses.backoffice.cus.kko.vo.SureMsgInfo;
import com.kses.backoffice.rsv.reservation.mapper.ResvInfoManageMapper;

import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service
public class SureManageServiceImpl extends EgovAbstractServiceImpl implements SureManageSevice  {
	private static final Logger LOGGER = Logger.getLogger(SureManageServiceImpl.class);
	
	@Autowired
	protected EgovPropertyService propertiesService;
	
	@Autowired
	private SureManageMapper sureMapper;
	
	@Autowired
	private ResvInfoManageMapper resvMapper;
	
	public String selectCertifiCode() throws Exception {
		return sureMapper.selectCertifiCode();
	}

	public int insertSmsData(SmsDataInfo smsDataInfo) throws Exception {
		return sureMapper.insertSmsData(smsDataInfo);
	}
	
	public int insertMmsData(MmsDataInfo mmsDataInfo) throws Exception {
		return sureMapper.insertMmsData(mmsDataInfo);
	}
	
	public boolean insertResvSureData(String msgDvsn, String resvSeq) throws Exception {
		int ret = 0;
		
		try {
			Map<String, Object> resvInfo = resvMapper.selectResvInfoDetail(resvSeq);
			SureMsgInfo sureMsgInfo = new SureMsgInfo();
			SureDataInfo sureDataInfo = sureMsgInfo.resvSureDataMsg(msgDvsn, resvInfo);
			
			sureDataInfo.setUsercode(propertiesService.getString("SureBiz.UserCode"));
			sureDataInfo.setBiztype("at");
			sureDataInfo.setYellowidKey(propertiesService.getString("SureBiz.YellowidKey"));
			sureDataInfo.setReqname("KRACE");
			sureDataInfo.setReqphone("0220675000");
			sureDataInfo.setKind("T");
			sureDataInfo.setResult("0");
			sureDataInfo.setResend("Y");
			sureDataInfo.setReqtime("00000000000000");
			ret = sureMapper.insertSureData(sureDataInfo);
			
			switch(msgDvsn) {
				case Globals.SMS_TYPE_RESV : msgDvsn = "??????"; break;
				case Globals.SMS_TYPE_CANCEL : msgDvsn = "??????"; break;
				case Globals.SMS_TYPE_PAYMENT : msgDvsn = "??????"; break;
				default : msgDvsn = "??????"; break;
			}
			 
			if(ret > 0) {
				LOGGER.info("???????????? : " + resvSeq + "??? ??????" + msgDvsn + "????????? ????????????");
			} else {
				LOGGER.info("???????????? : " + resvSeq + "??? ??????" + msgDvsn + "????????? ????????????");
			}
		} catch (Exception e) {
			LOGGER.error("insertResvSureData : " + e.toString());
			return false;
		}
		
		return ret > 0 ? true : false;
	}
}