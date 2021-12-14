package com.kses.backoffice.rsv.reservation.vo;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

//예약 정보
@Getter
@Setter
public class ResvInfo {
	// 예약 시퀀스
	private String resvSeq;

	// 지점 코드
	private String centerCd;
	
	// 층 코드
	private String floorCd;
	
	// 구역 코드
	private String partCd;
	
	// 좌석 코드
	private String seatCd;

	// 시즌 코드
	private String seasonCd;

	// 예약 시작일
	private String resvStartDt;

	// 예약 종료일
	private String resvEndDt;

	// 예약 구분 (오전오후종일)
	private String resvDvsn;

	// 예약 시작 TIME
	private String resvStartTm;

	// 예약 종료 TIME
	private String resvEndTm;

	// 요청일
	private String resvReqDate;

	// 고객 아이디
	private String userId;
	
	// 고객 이름
	private String resvUserNm;
	
	// 고객 전화번호
	private String resvUserClphn;

	// 고객 구분
	private String resvUserDvsn;

	// 입석/좌석 구분
	private String resvEntryDvsn;
	
	// 문진표 작성 여부
	private String resvUserAskYn;

	// 개인정보 수집 이용 여부
	private String resvIndvdlinfoAgreYn;
	
	// 발권 구분
	private String resvTicketYn;

	// 예약 상태
	private String resvState;

	// 취소자 ID
	private String resvCancelId;

	// 취소 사유
	private String resvCancelDc;

	// 고객 취소 시간
	private String resvCancelDt;

	// 취소 코드
	private String resvCancelCd;

	// 환불 비용
	private int resvCancelCost;

	// 현금 영수증 발급 여부
	private String resvRcptYn;
	
	// 현금 영수증 발급 구분
	private String resvRcptDvsn;
	
	// 현금 영수증 번호
	private String resvRcptNumber;
	
	// 최초 등록 일자
	private String frstRegisterPnttm;

	// 최초 등록 ID
 	private String frstRegisterId;

 	// 최종 수정 일자
	private String lastUpdusrPnttm;

	// 최종 수정 ID
	private String lastUpdusrId;
	
	// 관리자 아이디
	private String adminId;
	
	// 예약일
	private String resvDate;
	
	// 장기예약 시작일
	private String resvDateFrom;
	
	// 장기예약 종료일
	private String resvDateTo;
	
	// 장기예약일 리스트
	private List<String> resvDateList;
	
	// 입력 구분
	private String mode;
	
	// 결제 구분
	private String resvPayDvsn = "";
	
	//신규 추가
	private String tradNo = "";
	
	private String tradDate = ""; 
	
	private String refoundNo = "";
	
	private String refoundDate = "";
	
}