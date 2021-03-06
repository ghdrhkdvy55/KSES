package com.kses.batch;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.ui.ModelMap;

import com.kses.backoffice.bas.system.service.SystemInfoManageService;
import com.kses.backoffice.bas.system.vo.SystemInfo;
import com.kses.backoffice.bld.center.service.NoshowInfoManageService;
import com.kses.backoffice.cus.usr.service.UserInfoManageService;
import com.kses.backoffice.mng.employee.service.EmpInfoManageService;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.stt.dashboard.service.DashboardInfoManageService;
import com.kses.backoffice.sym.log.service.InterfaceInfoManageService;
import com.kses.backoffice.sym.log.vo.InterfaceInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.property.EgovPropertyService;

//spring 배치 서비스 정리 
@Component
public class Scheduler {

	private static final Logger LOGGER = Logger.getLogger(Scheduler.class);
	
	@Autowired
	protected EgovPropertyService propertiesService;

	@Autowired
	private EmpInfoManageService empService;
	
	@Autowired
	private ResvInfoManageService resvService;
	
	@Autowired
	private NoshowInfoManageService noshowService;
	
	@Autowired
	private InterfaceInfoManageService interfaceService;
	
	@Autowired
	private SystemInfoManageService systemService;
	
	@Autowired
	private DashboardInfoManageService dashBoardService;
	
	@Autowired
	private UserInfoManageService userService;

	/**
	 * 노쇼 예약정보 자동취소 스케줄러
	 * 
	 * @throws Exception
	 */
	@Scheduled(cron = "0 0/30 * * * * ")
	public void updateResvNoshowScheduler() throws Exception {
		List<Map<String, Object>> noshowResvList;
		SystemInfo systemInfo = systemService.selectSystemInfo();

		try {
			for(int i=1; i<=2; i++) {
				String noshowAutoCancelYn = i == 1 ? systemInfo.getAutoCancelR1UseYn() : systemInfo.getAutoCancelR2UseYn();  
				noshowResvList = i == 1 ? noshowService.selectNoshowResvInfo_R1() : noshowService.selectNoshowResvInfo_R2();  
				
				if(noshowAutoCancelYn.equals("Y")) { 
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
									ModelMap result = interfaceService.SpeedOnPayMentCancel(resvSeq, "", false, false);
	
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
						LOGGER.info("resvNoshowScheduler => " + i + "차 노쇼 예약정보 없음");
					}
				} else {
					LOGGER.info("resvNoshowScheduler => " + i + "차 자동취소 사용안함 설정으로 인한 미 실행");
				}
			}
		} catch (RuntimeException re) {
			LOGGER.error("resvNoshowScheduler => Run Failed", re);
		} catch (Exception e) {
			LOGGER.error("resvNoshowScheduler => Failed", e);
		}
	}
	
	/**
	 * SPDM 인사정보 배치 스케줄러
	 * 
	 * @throws Exception
	 */
	@Scheduled(cron="0 0 08 * * ?")
	public void updateEmpInfoScheduler() throws Exception {		
		try {
			LOGGER.info("----------------------------KSES EMP BATCH START----------------------------");
			int ret = empService.mergeEmpInfo();
			if(ret >= 0) {
				LOGGER.info("updateEmpInfoScheduler => " + "인사정보 " + ret + "건 갱신");
			} else {
				throw new Exception();
			}
		} catch (RuntimeException re) {
			LOGGER.error("updateEmpInfoScheduler => Run Failed", re);
		} catch (Exception e) {
			LOGGER.error("updateEmpInfoScheduler => Failed", e);
		}
		LOGGER.info("----------------------------KSES EMP BATCH END----------------------------");
	}
	
	/**
	 * 폐점 후 예약상태 '이용완료' 변경
	 * 
	 * @throws Exception
	 */
	@Scheduled(cron="0 0 23 * * ?")
	public void updateResvUseComplete() throws Exception {		
		try {
			LOGGER.info("----------------------------KSES COMPLETE USE BATCH START----------------------------");
			resvService.updateResvUseComplete();
		} catch (RuntimeException re) {
			LOGGER.error("updateResvUseComplete => Run Failed", re);
		} catch (Exception e) {
			LOGGER.error("updateResvUseComplete => Failed", e);
		}
		LOGGER.info("----------------------------KSES COMPLETE USE BATCH END----------------------------");
	}
	
	/**
	 * 지점별 이용통계 현황 갱신
	 * 
	 * @throws Exception
	 */
	@Scheduled(cron="0 30 23 * * ?")
	public void updateResvUsageStat() throws Exception {		
		try {
			LOGGER.info("----------------------------KSES RESV USAGE STAT UPDATE BATCH START----------------------------");
			int ret = dashBoardService.insertCenterUsageStat();
			
			if(ret >= 0) {
				LOGGER.info("updateResvUsageStat => " + "지점별 이용통계 " + ret + "건 갱신");
			} else {
				throw new Exception();
			}
		} catch (RuntimeException re) {
			LOGGER.error("updateResvUsageStat => Run Failed", re);
		} catch (Exception e) {
			LOGGER.error("updateResvUsageStat => Failed", e);
		}
		LOGGER.info("----------------------------KSES RESV USAGE STAT UPDATE BATCH END----------------------------");
	}
	
	/**
	 * 지점별 결제 금액통계 갱신
	 * 
	 * @throws Exception
	 */
	@Scheduled(cron="0 50 23 * * ?")
	public void updateResvCenterPayStat() throws Exception {		
		try {
			LOGGER.info("----------------------------KSES RESV PAY STAT UPDATE BATCH START----------------------------");
			int ret = dashBoardService.insertCenterResvPayStat();
			
			if(ret >= 0) {
				LOGGER.info("updateResvCenterPayStat => " + "지점별 결제 금액통계 " + ret + "건 갱신");
			} else {
				throw new Exception();
			}
		} catch (RuntimeException re) {
			LOGGER.error("updateResvCenterPayStat => Run Failed", re);
		} catch (Exception e) {
			LOGGER.error("updateResvCenterPayStat => Failed", e);
		}
		LOGGER.info("----------------------------KSES RESV PAY STAT UPDATE BATCH END----------------------------");
	}
	
	/**
	 * 금일자 회원/비회원 최초 입장정보 등록
	 * 
	 * @throws Exception
	 */
	@Scheduled(cron="0 55 23 * * ?")
	public void updateUserEntryInfo() throws Exception {		
		try {
			LOGGER.info("----------------------------KSES USER ENTRY INFO UPDATE BATCH START----------------------------");
			int ret = userService.insertUserEntryInfo();
			
			if(ret >= 0) {
				LOGGER.info("updateUserEntryInfo => " + "지점별 결제 금액통계 " + ret + "건 갱신");
			} else {
				throw new Exception();
			}
		} catch (RuntimeException re) {
			LOGGER.error("updateUserEntryInfo => Run Failed", re);
		} catch (Exception e) {
			LOGGER.error("updateUserEntryInfo => Failed", e);
		}
		LOGGER.info("----------------------------KSES USER ENTRY INFO UPDATE BATCH END----------------------------");
	}

	/**
	 * 스피드온 회원 휴대폰번호 갱신 스케줄러
	 * 
	 * @throws Exception
	 */
	@Scheduled(cron="0 0 01 * * ?")
	public void updateUserPhoneNumber() throws Exception {		
		try {
			LOGGER.info("----------------------------KSES USER PHONE NUMBER UPDATE BATCH START----------------------------");
			int ret = userService.updateUserPhoneNumber(propertiesService.getString("Globals.envType"));
			
			if(ret >= 0) {
				LOGGER.info("updateUserPhoneNumber => " + "회원 휴대폰 번호 " + ret + "건 갱신");
			} else {
				throw new Exception();
			}
		} catch (RuntimeException re) {
			LOGGER.error("updateUserPhoneNumber => Run Failed", re);
		} catch (Exception e) {
			LOGGER.error("updateUserPhoneNumber => Failed", e);
		}
		LOGGER.info("----------------------------KSES USER PHONE NUMBER UPDATE BATCH END----------------------------");
	}
	
	/**
	 * 스피드온 회원테이블 등록일 4주지난 비회원 개인정보 갱신 -> 휴대폰 번호, 이름 
	 * 
	 * @throws Exception
	 */
	@Scheduled(cron="0 05 01 * * ?")
	public void updateGuestPrivacyInfo() throws Exception {		
		try {
			LOGGER.info("----------------------------KSES GUEST PRIVACY INFO UPDATE BATCH START----------------------------");
			int ret = userService.updateGuestPrivacyInfo();
			
			if(ret >= 0) {
				LOGGER.info("updateGuestPrivacyInfo => " + " 기간만료된 비회원 개인정보 " + ret + "건 갱신");
			} else {
				throw new Exception();
			}
		} catch (RuntimeException re) {
			LOGGER.error("updateGuestPrivacyInfo => Run Failed", re);
		} catch (Exception e) {
			LOGGER.error("updateGuestPrivacyInfo => Failed", e);
		}
		LOGGER.info("----------------------------KSES GUEST PRIVACY INFO UPDATE BATCH END----------------------------");
	}
	
	/**
	 * 일주일 분량의 인터페이스 송수신 로그  CSV파일 생성 및 DB데이터 삭제
	 * 
	 * @throws Exception
	 */
	@Scheduled(cron="0 59 23 ? * 7", zone="Asia/Seoul")
	public void selectInterfaceLogFileCreate() throws Exception {		
		LOGGER.info("----------------------------KSES INTERFACE LOG FILE CRATE BATCH START----------------------------");
		String csvFilePath = propertiesService.getString("InterfaceLog.filePath");
		String csvFilePrefix = propertiesService.getString("InterfaceLog.prefix");
		String csvFileSuffix = propertiesService.getString("InterfaceLog.suffix");
		String NEWLINE = System.lineSeparator();
		
		File csvFile = null;
		BufferedWriter bw = null;
		
		try {
			InterfaceInfo interfaceInfo = new InterfaceInfo();
			LocalDateTime now = LocalDateTime.now();
			
			String[] dateList = new String[7];
			String csvHeader = interfaceService.selectInterfaceLogCsvHeader();
			List<String> csvList;
			
			for(int i=0; i<7; i++) {
				dateList[i] = now.minusDays(i).format(DateTimeFormatter.ofPattern("yyyyMMdd"));
			}
			
			for(String logDate : dateList) {
				String fileFullPath = csvFilePath + csvFilePrefix + logDate + csvFileSuffix; 
				csvFile = new File(fileFullPath);
				bw = new BufferedWriter(new FileWriter(csvFile));
				
				interfaceInfo.setOccrrncDe(logDate);
				csvList = interfaceService.selectInterfaceLogCsvList(interfaceInfo);
				bw.write(csvHeader);
				bw.write(NEWLINE);
				
				for(String csvRow : csvList) {
					bw.write(csvRow);
					bw.write(NEWLINE);
				}
				
				bw.flush();
				bw.close();
				
				interfaceService.deleteInterfaceLogCsvList(logDate);
			}

		} catch (RuntimeException re) {
			LOGGER.error("selectInterfaceLogFileCreate => Run Failed", re);
		} catch (Exception e) {
			LOGGER.error("selectInterfaceLogFileCreate => Failed", e);
		}
		LOGGER.info("----------------------------KSES INTERFACE LOG FILE CRATE BATCH END----------------------------");
	}
}