package com.kses.backoffice.rsv.reservation.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.cus.kko.service.KkoMsgManageSevice;
import com.kses.backoffice.mng.employee.mapper.EmpInfoManageMapper;
import com.kses.backoffice.rsv.reservation.mapper.ResInfoManageMapper;
import com.kses.backoffice.rsv.reservation.mapper.ResTimeInfoManageMapper;
import com.kses.backoffice.rsv.reservation.service.ResInfoManageService;
import com.kses.backoffice.util.service.UniSelectInfoManageService;

@Service
public class ResInfoManageServiceImpl  implements ResInfoManageService{

	  private static final Logger LOGGER = LoggerFactory.getLogger(ResInfoManageServiceImpl.class);
	
	  @Autowired
	  private ResInfoManageMapper resMapper;
	
	  @Autowired
	  private ResTimeInfoManageMapper timeMapper;
	  
	  @Autowired
	  private EmpInfoManageMapper empMapper;
	  
	  @Autowired
	  private UniSelectInfoManageService uniService;
	  
	  @Autowired
	  private KkoMsgManageSevice kkoSerice;
	  
//	  @Override
//	  public List<Map<String, Object>> selectResManageListByPagination(Map<String, Object> searchVO)   throws Exception  {
//		  return this.resMapper.selectResManageListByPagination(searchVO);
//	  }
//	  
//	  // 예약 화면 리스트
//	  @Override
//	  public List<Map<String, Object>> selectIndexList( Map<String, Object> params)   throws Exception  {
//	      return this.resMapper.selectIndexList(params);
//	  }
//	 
//	  
//	  
//	  //예약 신청  
//	  @Transactional
//	  @Override
//	  public int insertResManage(ReservationInfo vo)   throws Exception{
//
//		    int resSeq = 0;
//		    Map<String, Object> timeinfo = new HashMap<String, Object>();
//		    timeinfo.put("timeStartDay", vo.getResStartday());
//		    timeinfo.put("strTime", vo.getResStarttime());
//		    timeinfo.put("endTime",  vo.getResEndtime());
//		    timeinfo.put("meetingId", vo.getItemId());
//		    timeinfo.put("resGubun", vo.getResGubun());
//		    
//		    if (vo.getResGubun().equals("SWC_GUBUN_2")){
//		    	//영상 회의 자기 자신 아이디 이외 추가 회의실 아이디 체크 해서 넣기 
//		    	timeinfo.put("meetingSeq", util.dotToList(vo.getItemId() + "," + vo.getMeetingSeq())); 	
//		    }
//		    int resCnt  = 0;
//		    
//		    LOGGER.debug("vo.getResGubun()" + vo.getResGubun());
//		    //단기/장기 예약 정리 하기 
//		    if (vo.getResGubun().equals("SWC_GUBUN_3")) {
//		    	//장기 예약 정리 하기 
//		    	timeinfo.put("timeEndDay", vo.getResEndday());
//		    	resCnt = this.timeMapper.selectResPreCheckInfoL1(timeinfo);
//		    	
//		    }else {
//		    	resCnt = this.timeMapper.selectResPreCheckInfo(timeinfo);
//		    }
//		    // 예약 상태 확인 
//		    
//		    int ret = 0;
//		    
//		    
//		    if (resCnt == 0){
//		    	
//			    if (vo.getMeetingSeq().toString().equals("on")) {
//			        vo.setMeetingSeq("");
//			    }
//			    // 여기 구문에 FLOOR_SEQ 내용 넣기 
//			    //돌아 버리겠다 왜 좌석 회의실을 쪼갰는지 모르겠네
//			    
//			    Map<String, Object> floorInfo = !vo.getItemGubun().equals("ITEM_GUBUN_2") ? uniService.selectFieldStatement("FLOOR_SEQ", "tb_meeting_room", "MEETING_ID=[" +vo.getItemId()+"[" )
//			    		                                                                  : uniService.selectFieldStatement("FLOOR_SEQ", "tb_seatinfo", "SEAT_ID=[" +vo.getItemId()+"[" );
//		        vo.setFloorSeq(floorInfo.get("floor_seq").toString());
//			    ret = this.resMapper.insertResManage(vo);
//			    resSeq = Integer.valueOf(vo.getResSeq()).intValue();
//		        if (ret > 0){
//			        vo.setResSeq(String.valueOf(resSeq));
//			        //자동 승인 넘기기기
//			        timeinfo.put("resSeq", String.valueOf(resSeq));
//			        timeinfo.put("apprival", "R");
//			        if (vo.getResGubun().equals("SWC_GUBUN_3")) {
//		        	    this.timeMapper.updateTimeInfoL1(timeinfo);
//			        }else {
//			        	this.timeMapper.updateTimeInfo(timeinfo);
//			        }
//			        
//			        
//		        	if (vo.getSeatConfirmgubun().equals("Y")) {
//			        	//관리자 승인 일때 처리 하는 구문 
//			        	//boolean sendCk =   meetingService.sendMeetingEmpMessage(vo.getItemId(), vo);
//			        	//예약 메일 보내기 
//			        	
//			        	//Map<String, Object> resInfo = resMapper.selectResManageView(vo.getResSeq());
//			        	
//			        }else {
//			        	vo.setReservProcessGubun("PROCESS_GUBUN_2");
//			        	vo.setResSeq(String.valueOf(resSeq));
//			        	ret = updateResManageChange(vo);
//			        }
//			        
//			    }else {
//			    	 this.resMapper.errorResDateStep01(resSeq);
//				     this.resMapper.errorResDateStep02(resSeq);
//				     ret = -1;
//			    }
//	    }
//	    else {
//	    	// 초기화 시키기
//	        //this.resMapper.errorResDateStep01(resSeq);
//	        //this.resMapper.errorResDateStep02(resSeq);
//	        ret = -3;
//	    }
//	    return ret;
//	  }
//
//	@Transactional
//	@Override
//	public int updateResManageChange(ReservationInfo vo) throws Exception {
//		// TODO Auto-generated method stub
//		ResTimeInfo info = new ResTimeInfo();
//		info.setResSeq(vo.getResSeq());
//		
//		int ret = 0;
//		String resCode = "";
//		Map<String, Object> resInfo = null;
//		try {
//			
//			Map<String, Object> tennInfo = new HashMap<String, Object>();
//			LOGGER.debug("===============service" + vo.getReservProcessGubun());
//			
//			
//			
//			
//			
//			if (vo.getReservProcessGubun().equals("PROCESS_GUBUN_2") || vo.getReservProcessGubun().equals("PROCESS_GUBUN_4")){
//					info.setApprival("Y");
//					timeMapper.updateTimeInfoY(info);
//					resCode = "RES";
//					//메일 보내기
//					
//					ret = resMapper.updateResManageChange(vo);
//					//여기 구문 확인 필요
//					LOGGER.debug("체크 시작  ------");
//					LOGGER.debug("---------------- 테넌트 사용 여부 확인  ------" + util.NVL(vo.getTennCnt(), "0"));
//					if (ret > 0 && Integer.valueOf(util.NVL(vo.getTennCnt(), "0")) > 0) {
//						
//						
//						tennInfo.put("userId",  vo.getUserId());
//						tennInfo.put("resSeq",  vo.getResSeq());
//						tennInfo.put("tennCnt",  vo.getTennCnt());
////						ret = tennService.insertTennantPlayManages(tennInfo);
////						if (ret < 0) {
////							throw new Exception();  
////						}
//					}
//					resInfo = resMapper.selectResManageView(vo.getResSeq() );
//					
//					if (resInfo.get("send_message").equals("Y") ) {
//						//카카오 메세지 보내기 
//						kkoSerice.kkoMsgInsertSevice("RES", resInfo);
//					}
//					
//			}else if (vo.getReservProcessGubun().equals("PROCESS_GUBUN_3") || vo.getReservProcessGubun().equals("PROCESS_GUBUN_5")
//					|| vo.getReservProcessGubun().equals("PROCESS_GUBUN_6") || vo.getReservProcessGubun().equals("PROCESS_GUBUN_7")){
//				
//				    resCode = "CANCEL";
//					info.setApprival("N");
//					ret = resMapper.updateResManageChange(vo);
//					//여기 구문 확인 필요
//					LOGGER.debug("체크 시작  ------1");
//					
//					if (ret > 0) {
//						resInfo = resMapper.selectResManageView(vo.getResSeq() );
//						LOGGER.debug("체크 시작  ------2");
//						timeMapper.resTimeReset(info);
//						//테넌트 값이 있으지 확인 후 처리
////						if ( Integer.valueOf( util.NVL(resInfo.get("tenn_cnt"), "0")) > 0) {
////							tennInfo.put("userId",  vo.getUserId());
////						    tennInfo.put("resSeq",  vo.getResSeq());
////						    ret = tennService.updateRetireTennantInfoManage(tennInfo);
////						}
//						LOGGER.debug("체크 시작  ------3");
//					}
//					if (resInfo.get("send_message").equals("Y") && resInfo.get("item_gubun").equals("ITEM_GUBUN_3") ) {
//						//카카오 메세지 보내기 
//						kkoSerice.kkoMsgInsertSevice("CAN", resInfo);
//					}
//			}else if (vo.getReservProcessGubun().equals("PROCESS_GUBUN_8")) {
//					info.setApprival("V");
//					timeMapper.updateTimeInfoY(info);
//					resCode = "VIEW";
//					ret = resMapper.updateResManageChange(vo);
//					resInfo = resMapper.selectResManageView(vo.getResSeq() );
//			}
//
//			
//			
//		}catch(Exception e) {
//			ret = -1;
//			StackTraceElement[] ste = e.getStackTrace();
//		    int lineNumber = ste[0].getLineNumber();
//			LOGGER.error("updateResManageChange error:" + e.toString() + ":" + lineNumber );
//			//예약 일때 애러 날때 처리 
//			if (resCode.equals("RES"))
//			   this.resMapper.deleteResManage(vo.getResSeq());
//		}
//		
//		return ret;
//	}
//	
//	@Override
//	public int deleteResManage(String resSeq) throws Exception{
//	      return this.resMapper.deleteResManage(resSeq);
//	}
//	
//	
//	
//	@Override
//	public int updateCancelReason(ReservationInfo vo)  throws Exception {
//	    return this.resMapper.updateCancelReason(vo);
//	}
//	@Override
//	public ReservationInfo selectCancelReason(String resSeq)  throws Exception{
//	    return this.resMapper.selectCancelReason(resSeq);
//	}
//	@Override
//	public int updateResManageDateChange(String resSeq) throws Exception{
//	    return this.resMapper.updateResManageDateChange(resSeq);
//	}
//	@Override
//	public ReservationInfo selectResUserInfo(String resSeq) throws Exception {
//	    return this.resMapper.selectResUserInfo(resSeq);
//	}
//	@Override
//	public int updateDayChange(ReservationInfo resInfo)  throws Exception {
//	    return this.resMapper.updateDayChange(resInfo);
//	}
//	@Override 
//	public Map<String, Object> selectResManageView(String resSeq) throws Exception {
//	    return this.resMapper.selectResManageView(resSeq);
//	}
//	@Override
//	public int updateResMeetingLog(ReservationInfo vo)  throws Exception {
//	    return this.resMapper.updateResMeetingLog(vo);
//	}
//	
//	@Override
//	public List<ReservationInfo> selectCalenderInfo()  throws Exception  {
//	    return this.resMapper.selectCalenderInfo();
//	}
//	@Override
//	public List<ReservationInfo> selectCalenderDetailInfo(ReservationInfo searchVO)  throws Exception {
//		  return this.resMapper.selectCalenderDetailInfo(searchVO);
//	}
//	  // 어바이어 상태 변경 값 정리 하기 
//	@Override
//	public int updateResManageChangeAvaya(ReservationInfo vo) throws Exception{
//	    return this.resMapper.updateResManageChangeAvaya(vo);
//	}
//	  
//	  
//	@Override
//	public List<ReservationInfo> selectMessagentList()  throws Exception {
//	    return this.resMapper.selectMessagentList();
//	}
//	
//	@Override
//	public int resStateChagenCheck(ReservationInfo resInfo) throws Exception {
//		// TODO Auto-generated method stub
//		return resMapper.resStateChagenCheck(resInfo);
//	}
//	
//	@Override
//	public List<Map<String, Object>> selectKioskCalendarList(String meetingId) {
//		// TODO Auto-generated method stub
//		return resMapper.selectKioskCalendarList(meetingId);
//	}
//
//	@Override
//	public String selectTennInfo(ReservationInfo vo) throws Exception {
//		// TODO Auto-generated method stub
//		return resMapper.selectTennInfo(vo);
//	}
//
//	@Override
//	public List<ReservationInfo> selectCalenderMeetingState(ReservationInfo searchVO) throws Exception {
//		// TODO Auto-generated method stub
//		return resMapper.selectCalenderMeetingState(searchVO);
//	}
//    //전자 명패
//	@Override
//	public List<Map<String, Object>> selectNameplate() throws Exception {
//		// TODO Auto-generated method stub
//		return resMapper.selectNameplate();
//	}
//
//	@Override
//	public Map<String, Object> selectTodayResSeatInfo(String empNo) throws Exception {
//		// TODO Auto-generated method stub
//		return resMapper.selectTodayResSeatInfo(empNo);
//	}
}