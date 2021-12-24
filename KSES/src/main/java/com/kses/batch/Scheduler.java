package com.kses.batch;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.kses.backoffice.bld.center.service.NoshowInfoManageService;
import com.kses.backoffice.bld.center.vo.NoshowInfo;
import com.kses.backoffice.cus.kko.service.KkoMsgManageSevice;
import com.kses.backoffice.rsv.reservation.mapper.ResInfoManageMapper;
import com.kses.backoffice.rsv.reservation.mapper.ResTimeInfoManageMapper;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.NoShowHisInfo;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;
import com.kses.backoffice.sym.log.service.InterfaceInfoManageService;
import com.kses.backoffice.sym.log.service.ScheduleInfoManageService;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.service.Globals;


//spring 배치 서비스 정리 
@Component
@SuppressWarnings("unchecked")
public class Scheduler {

	private static final Logger LOGGER = Logger.getLogger(Scheduler.class);

	@Autowired
	private ResTimeInfoManageMapper timeMapper;
	
	@Autowired
	private ResInfoManageMapper resMapper;
	
	@Autowired
	private ScheduleInfoManageService  scheduleService;
	
	@Autowired
	private KkoMsgManageSevice kkoSerice;
	
	@Autowired
	private ResvInfoManageService resvService;
	
	@Autowired
	private NoshowInfoManageService noshowService;
	
	@Autowired
	private InterfaceInfoManageService interfaceService;
	
	/**
 	* 23:50 분 타임 스케줄러 생성
 	* 
 	* @return
 	*/
	private String serverInfo () {
		return System.getProperty("spring.profiles.active");
	}
	
	/**
	 * 노쇼 예약정보 자동취소 스케줄러
	 * 
	 * @throws Exception
	 */

	/* @Scheduled(cron = "0 0/1 * * * * ") */
	@Transactional(rollbackFor = Exception.class)
	public void resvNoshowScheduler() throws Exception {
		List<Map<String, Object>> noshowResvList;
		JSONObject jsonObject = new JSONObject();
		NoShowHisInfo noshowHisInfo = new NoShowHisInfo();
		ResvInfo resvInfo = new ResvInfo();
		
		try {
			for(int i=1; i<=2; i++) {
				noshowResvList = i == 1 ? noshowService.selectNoshowResvInfo_R1() : noshowService.selectNoshowResvInfo_R2();  
				
				if(noshowResvList.size() != 0) {
					int successCount = 0;
					int resultCount = 0;
					int pilotCount = 0;
					
					for(Map<String, Object> map : noshowResvList) {
						String resvSeq = SmartUtil.NVL(map.get("resv_seq"),"");
						String noshowCd = SmartUtil.NVL(map.get("noshow_cd"),"");
						String centerPilotYn = SmartUtil.NVL(map.get("center_pilot_yn"),"");
						String resvPayDvsn = SmartUtil.NVL(map.get("resv_pay_dvsn"),"");
						
						/*if(centerPilotYn.equals("N")) {*/
							LOGGER.info("예약번호 : " + resvSeq + " " + i + "차 자동취소 시작" );
							
							if(i == 2 && resvPayDvsn.equals("RESV_PAY_DVSN_2")) {
								jsonObject.put("Pw_YN", "N");
								jsonObject.put("resvSeq", resvSeq);
								Map<String, Object> result = interfaceService.SpeedOnCancelPayMent(jsonObject);
								
								if(!SmartUtil.NVL(result.get(Globals.STATUS), "").equals("SUCCESS")) {
									LOGGER.info("예약번호 : " + resvSeq + " 결제취소실패");
									LOGGER.info("에러코드 : " + result.get(Globals.STATUS));
									LOGGER.info("에러메세지 : " + result.get(Globals.STATUS_MESSAGE));
									continue;
								} 
								
								LOGGER.info("예약번호 : " + resvSeq + " 결제취소성공");
							}
							
							// 노쇼정보등록 & 예약정보취소
							try {
								noshowHisInfo.setNoshowCd(noshowCd);
								noshowHisInfo.setResvSeq(resvSeq);
								resultCount = noshowService.insertNoshowResvInfo(noshowHisInfo);
								
								if(resultCount > 0) {
									LOGGER.info("예약번호 : " + resvSeq + " 노쇼 정보 등록성공");
									resvInfo.setResvSeq(resvSeq);
									resultCount = noshowService.updateNoshowResvInfoCancel(resvInfo);
									if(resultCount > 0) {
										LOGGER.info("예약번호 : " + resvSeq + " 예약 정보 취소성공");
									} else {
										LOGGER.info("예약번호 : " + resvSeq + " 예약 정보 취소실패");
										throw new Exception();
									}
								} else {
									LOGGER.info("예약번호 : " + resvSeq + " 노쇼 정보 등록실패");
									throw new Exception();
								}
							} catch (Exception e) {
								LOGGER.info("예약번호 : " + resvSeq + " 예외발생 트랜잭션 실행");
								continue;
							}
							
							successCount++;
/*						} else {
							LOGGER.info("예약번호 : " + resvSeq + " 시범지점 예외처리");
							pilotCount++;
						}*/
					}
					LOGGER.info("=====================================================================================");
					LOGGER.info(i + "차 노쇼 예약정보(총) : " + noshowResvList.size());
					LOGGER.info("성공 : " + successCount + "건");
					LOGGER.info("실패 : " + (noshowResvList.size() - successCount + pilotCount) + "건");
					LOGGER.info("시범지점예외 : " + pilotCount + "건");
					LOGGER.info("=====================================================================================");
				} else {
					LOGGER.info("resvNoshowScheduler =>" + i + "차 노쇼 예약정보 없음");
				}
			}
		} catch (RuntimeException re) {
			//scheduleService.insertScheduleManage("resStateCreateSchedulerService", "FAIL", re.toString());
			LOGGER.error("resvNoshowScheduler =>  Run Failed", re);
		} catch (Exception e) {
			//scheduleService.insertScheduleManage("resStateCreateSchedulerService", "FAIL", e.toString());
			LOGGER.error("resvNoshowScheduler => Failed", e);
		}
	}
	
	/*@Scheduled(cron = "0 50 23 * * * ")*/
	public void resTimeCreateStateSchede() throws Exception{
		
		try{
			if("Active1".equals(serverInfo().toString())) {
				int ret = timeMapper.inseretTimeCreate();
				LOGGER.info("resTime " + ret + "행 생성");
				scheduleService.insertScheduleManage("resStateCreateSchedulerService", "OK", "");
			}   
		}catch (RuntimeException re) {
			scheduleService.insertScheduleManage("resStateCreateSchedulerService", "FAIL", re.toString());
			LOGGER.error("resStateCreateSchedulerService run failed", re);
		}catch (Exception e) {
			scheduleService.insertScheduleManage("resStateCreateSchedulerService", "FAIL", e.toString());
			LOGGER.error("resStateCreateSchedulerService failed", e);
		}
	}
	
	//10분 단위로 입실 처리 없을때 배치 돌리기
	/*@Scheduled(cron = "0 0/10 * * * * ")*/
    public void resRaiSchedule10Minute() throws Exception{
		//LOGGER.debug("profile:" + System.getProperty("spring.profiles.active"));
		
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
	}
    
	/*@Scheduled(cron = "0 0/10 * * * * ") 
	@Transactional(rollbackFor = Exception.class)
	public void resvNoshowScheduler() throws Exception {
		int errorCount = 0; 
		try {
			for(int i=1; i<2; i++) {
				JSONObject jsonObject = new JSONObject();
				Map<String, Object> result = interfaceService.SpeedOnCancelPayMent(jsonObject);
				
				errorCount = i;
				int noShowCount = i == 1 ? noshowService.insertNoshowResvInfo_R1() : noshowService.insertNoshowResvInfo_R2(); 
				
				if(noShowCount != 0) {
					int resvCancelCount = i == 2 ? noshowService.updateNoshowResvInfoCancel_R1() : noshowService.updateNoshowResvInfoCancel_R2();

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