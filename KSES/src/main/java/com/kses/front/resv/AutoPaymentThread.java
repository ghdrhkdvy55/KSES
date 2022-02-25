package com.kses.front.resv;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.kses.backoffice.sym.log.service.InterfaceInfoManageService;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.service.Globals;

public class AutoPaymentThread extends Thread {
	private static final Logger LOGGER = LoggerFactory.getLogger(AutoPaymentThread.class);
	
	@Autowired
	InterfaceInfoManageService interfaceService;
	
	String resvSeq = "";
	String message = "";
	
	public AutoPaymentThread(String resvSeq) {
		this.resvSeq = resvSeq;
	}
	
	@Override
	public void run() {
		try {
			LOGGER.info("RESV_SEQ : " + resvSeq + " RESERVATION AUTO PAYMENT START");
			
			Map<String, Object> autoPaymentResult = interfaceService.SpeedOnPayMent(resvSeq, "", false);
			if(SmartUtil.NVL(autoPaymentResult.get(Globals.STATUS),"").equals(Globals.STATUS_SUCCESS)) {
				// 2022-02-25 에이텐시스템 장대한
				// TODO 자동결제 예약정보에 대한 알림톡 발송 적용
			} else {
				message = SmartUtil.NVL(autoPaymentResult.get(Globals.STATUS_MESSAGE),"");
				throw new Exception();
			}
			
			LOGGER.info("RESV_SEQ : " + resvSeq + " RESERVATION AUTO PAYMENT SUCCESS");
		} catch (Exception e) {
			LOGGER.error("RESV_SEQ : " + resvSeq + " RESERVATION AUTO PAYMENT FAIL");
			LOGGER.error("FAIL MESSAGE : " + message);
		}
	}
}