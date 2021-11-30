package com.kses.backoffice.rsv.reservation.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.rsv.reservation.vo.ReservationInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface ResInfoManageMapper {
	//예약 리스트 조회 
    public List<Map<String, Object>> selectResManageListByPagination(@Param("params") Map<String, Object> params);
    
    public List<Map<String, Object>> selectIndexList(@Param("params") Map<String, Object> params );
    // 회의실 예약 배치 파일 
    public List<Map<String, Object>> selectMessageInfoList(String searchDay );
    //당일 일반 좌석 예약 현황
    public Map<String, Object> selectTodayResSeatInfo(String empNo);
    
    public List<ReservationInfo> selectCalenderInfo();
    //월별 예약 상세 리스트
    public List<ReservationInfo> selectCalenderDetailInfo(ReservationInfo searchVO);
    //월별 회의실 상태
    public List<ReservationInfo> selectCalenderMeetingState(ReservationInfo searchVO);
    
    //메일 보내는 구문 
    public List <ReservationInfo> selectMessagentList();
    
    public List<Map<String, Object>> selectKioskCalendarList(String meetingId);
    //전자 명패 정보
    public List<Map<String, Object>> selectNameplate();
    
    public Map<String, Object> selectResManageView(String resSeq);
	
    public String selectTennInfo(ReservationInfo vo);
    
    public int insertResManage(ReservationInfo vo);
	
    public int updateResManageChange(ReservationInfo vo);
    
    public int updateResManageChangeAvaya(ReservationInfo vo);
    
    public int updateResEquipChnageManage(ReservationInfo vo);
    
    public int deleteResManage(String  resSeq);
    //회의록 작성
	public int updateResMeetingLog(ReservationInfo vo);
	// 예약 취소 및 시간 타입 원복
	public int updateResCancel10MinLateEmpty();
	
	public int updateCancelReason(ReservationInfo vo);
	//에러 일때 사용 하기 
	public int errorResDateStep01(int resSeq);
	
	public int errorResDateStep02(int resSeq);
	
	public ReservationInfo selectCancelReason(String resSeq);
	
	public int updateResManageDateChange(String resSeq);
	//신규 추가 분
	public int updateDayChange(ReservationInfo resInfo);
	//신규 추가 끝 부분
	public ReservationInfo selectResUserInfo(String resSeq);
	//입/퇴실
	public int resStateChagenCheck(ReservationInfo resInfo);

}
