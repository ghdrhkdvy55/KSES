package com.kses.batch;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.kses.backoffice.bld.center.service.NoshowInfoManageService;
import com.kses.backoffice.cus.kko.service.KkoMsgManageSevice;
import com.kses.backoffice.rsv.reservation.mapper.ResInfoManageMapper;
import com.kses.backoffice.rsv.reservation.mapper.ResTimeInfoManageMapper;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.NoShowHisInfo;
import com.kses.backoffice.sym.log.service.ScheduleInfoManageService;


//spring 배치 서비스 정리 
@Component
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
	/*@Scheduled(cron = "0 0/1 * * * * ")*/
	@Transactional(rollbackFor = Exception.class)
	public void resvNoshowScheduler() throws Exception {
		int errorCount = 0; 
		try {
			for(int i=1; i<2; i++) {
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
}