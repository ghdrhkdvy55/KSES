package com.kses.batch;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.kses.backoffice.cus.kko.service.KkoMsgManageSevice;
import com.kses.backoffice.rsv.reservation.mapper.ResInfoManageMapper;
import com.kses.backoffice.rsv.reservation.mapper.ResTimeInfoManageMapper;
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
	
	/**
 	* 23:50 분 타임 스케줄러 생성
 	* 
 	* @return
 	*/
	private String serverInfo () {
		return System.getProperty("spring.profiles.active");
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
