package com.kses.batch;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.ui.ModelMap;

import com.kses.backoffice.bld.center.service.NoshowInfoManageService;
import com.kses.backoffice.mng.employee.service.EmpInfoManageService;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.sym.log.service.InterfaceInfoManageService;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.service.Globals;

//spring 배치 서비스 정리 
@Component
public class Scheduler {

	private static final Logger LOGGER = Logger.getLogger(Scheduler.class);

	@Autowired
	private EmpInfoManageService empService;
	
	@Autowired
	private ResvInfoManageService resvService;
	
	@Autowired
	private NoshowInfoManageService noshowService;
	
	@Autowired
	private InterfaceInfoManageService interfaceService;

	/**
	 * 노쇼 예약정보 자동취소 스케줄러
	 * 
	 * @throws Exception
	 */
	@Scheduled(cron = "0 0/1 * * * * ")
	//@Transactional(rollbackFor=Exception.class)
	public void resvNoshowScheduler() throws Exception {
		List<Map<String, Object>> noshowResvList;

		try {
			for(int i=1; i<=2; i++) {
				noshowResvList = i == 1 ? noshowService.selectNoshowResvInfo_R1() : noshowService.selectNoshowResvInfo_R2();  
				
				if(noshowResvList.size() != 0) {
					int successCount = 0;
					int ticketCount = 0;
					
					for(Map<String, Object> map : noshowResvList) {
						String resvSeq = SmartUtil.NVL(map.get("resv_seq"),"");
						String resvPayDvsn = SmartUtil.NVL(map.get("resv_pay_dvsn"),"");
						String resvTicketDvsn = SmartUtil.NVL(map.get("resv_ticket_dvsn"),"");
						
						if(!resvTicketDvsn.equals("RESV_TICKET_DVSN_2")) {
							LOGGER.info("예약번호 : " + resvSeq + " " + i + "차 자동취소 시작" );
							
							if(i == 2 && resvPayDvsn.equals("RESV_PAY_DVSN_2") && resvTicketDvsn.equals("RESV_TICKET_DVSN_1")) {
								ModelMap result = interfaceService.SpeedOnPayMentCancel(resvSeq, "", false);

								if(!SmartUtil.NVL(result.get(Globals.STATUS), "").equals("SUCCESS")) {
									LOGGER.info("예약번호 : " + resvSeq + " 결제취소실패");
									LOGGER.info("에러코드 : " + result.get(Globals.STATUS));
									LOGGER.info("에러메세지 : " + result.get(Globals.STATUS_MESSAGE));
									continue;
								} 
								
								LOGGER.info("예약번호 : " + resvSeq + " 결제취소성공");
							}
							
							// 노쇼정보등록 & 예약정보취소
							if(!noshowService.updateNoshowResvInfoTran(map)) {
								LOGGER.info("예약번호 : " + resvSeq + " 예약취소 및 노쇼예약정보 등록 실패");
								continue;
							}
							
							successCount++;
						} else {
							LOGGER.info("예약번호 : " + resvSeq + " 무인발권기 거래 예약정보 예외처리");
							ticketCount++;
						}
					}
					
					LOGGER.info("=====================================================================================");
					LOGGER.info(i + "차 노쇼 예약정보(총) : " + noshowResvList.size());
					LOGGER.info("성공 : " + successCount + "건");
					LOGGER.info("실패 : " +  (noshowResvList.size() - (ticketCount + successCount)) + "건");
					LOGGER.info("무인발권기예외 : " + ticketCount + "건");
					LOGGER.info("=====================================================================================");
				} else {
					LOGGER.info("resvNoshowScheduler =>" + i + "차 노쇼 예약정보 없음");
				}
			}
		} catch (RuntimeException re) {
			LOGGER.error("resvNoshowScheduler =>  Run Failed", re);
		} catch (Exception e) {
			LOGGER.error("resvNoshowScheduler => Failed", e);
		}
	}
	
	@Scheduled(cron="0 0 23 * * ?")
	public void ksesupdateResvUseComplete() throws Exception {		
		try {
			LOGGER.info("----------------------------KSES COMPLETE USE BATCH START----------------------------");
			resvService.updateResvUseComplete();
		} catch (RuntimeException re) {
			LOGGER.error("ksesupdateResvUseComplete =>  Run Failed", re);
		} catch (Exception e) {
			LOGGER.error("ksesupdateResvUseComplete => Failed", e);
		}
		LOGGER.info("----------------------------KSES COMPLETE USE BATCH END----------------------------");
	}

	
	@Scheduled(cron="0 0 08 * * ?")
	public void ksesEmpInfoUpdateScheduler() throws Exception {		
		try {
			LOGGER.info("----------------------------KSES EMP BATCH START----------------------------");
			int ret = empService.mergeEmpInfo();
			if(ret >= 0) {
				LOGGER.info("ksesEmpInfoUpdateScheduler =>" + "인사정보 " + ret + "건 갱신");
			} else {
				throw new Exception();
			}
		} catch (RuntimeException re) {
			LOGGER.error("ksesEmpInfoUpdateScheduler =>  Run Failed", re);
		} catch (Exception e) {
			LOGGER.error("ksesEmpInfoUpdateScheduler => Failed", e);
		}
		LOGGER.info("----------------------------KSES EMP BATCH END----------------------------");
	}

	
/*	0분 단위로 입실 처리 없을때 배치 돌리기
	@Scheduled(cron = "0 0/10 * * * * ")
    public void resRaiSchedule10Minute() throws Exception{
		LOGGER.debug("profile:" + System.getProperty("spring.profiles.active"));
		
    	try{
    		if ("Active1".equals(serverInfo().toString())) {
    			//10분 후 입실 처리 안되는 회의실 문자 보내기
    			int ret = resMapper.updateResCancel10MinLateEmpty();
    			LOGGER.info("10분 후 미입실 문자" + ret + "건 전송");
    			scheduleService.insertScheduleManage("RaiSchedule10Minute", "OK", "");
    			
    			//1일 전 회의실 문자 보내기
    			List<Map<String, Object>> resDayInfos = resMapper.selectMessageInfoList("DAY");
    			for (Map<String, Object> resDayInfo : resDayInfos) {
    				kkoSerice.kkoMsgInsertSevice("DAY", resDayInfo);
    			}
    			//당일 20분전 카톡 보내기 
    			resDayInfos = resMapper.selectMessageInfoList("STR");
    			for (Map<String, Object> resDayInfo : resDayInfos) {
    				kkoSerice.kkoMsgInsertSevice("STR", resDayInfo);
    			}
    		}
    	}catch(Exception e){
    		StackTraceElement[] ste = e.getStackTrace();
			LOGGER.info(e.toString() + ':' + ste[0].getLineNumber());
			scheduleService.insertScheduleManage("RaiSchedule10Minute", "FAIL", e.toString());
    		LOGGER.error("resRaiSchedule10Minute failed", e);
    	}
	}*/
    
	/*@Scheduled(cron = "0 0/10 * * * * ") 
	@Transactional(rollbackFor = Exception.class)
	public void resvNoshowScheduler() throws Exception {
		int errorCount = 0; 
		try {
			for(int i=1; i<2; i++) {
				JSONObject jsonObject = new JSONObject();
				Map<String, Object> result = interfaceService.SpeedOnPayMentCancel(jsonObject);
				
				errorCount = i;
				int noShowCount = i == 1 ? noshowService.insertNoshowResvInfo_R1() : noshowService.insertNoshowResvInfo_R2(); 
				
				if(noShowCount != 0) {
					int resvCancelCount = i == 2 ? noshowService.updateNoshowResvInfoTranCancel_R1() : noshowService.updateNoshowResvInfoTranCancel_R2();

					if(resvCancelCount == noShowCount) {
						LOGGER.info("resvNoshowScheduler =>" + i + "차 노쇼 예약정보 자동취소 " + resvCancelCount + "건");
					} else {
						throw new Exception();
					}
				} else {
					LOGGER.info("resvNoshowScheduler =>" + i + "차 노쇼 예약정보 없음");
				}
			}
		} catch (RuntimeException re) {
			//scheduleService.insertScheduleManage("resStateCreateSchedulerService", "FAIL", re.toString());
			LOGGER.error("resvNoshowScheduler " + errorCount + "차  =>  Run Failed", re);
		} catch (Exception e) {
			//scheduleService.insertScheduleManage("resStateCreateSchedulerService", "FAIL", e.toString());
			LOGGER.error("resvNoshowScheduler " + errorCount + "차 => Failed", e);
		}
	}*/
}