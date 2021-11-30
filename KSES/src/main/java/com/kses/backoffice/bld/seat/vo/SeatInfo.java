package com.kses.backoffice.bld.seat.vo;

import lombok.Getter;
import lombok.Setter;

//좌석 정보
@Getter
@Setter
public class SeatInfo {

	 // 좌석 코드
	 private String seatCd;
	
	 // 지점 아이디
	 private String centerCd;
	
	 // 층 정보
	 private String floorCd;
	
	 // 구역 정보
	 private String partCd;
	
	 // 좌석명
	 private String seatNm;
	
	 // 사용 유무
	 private String useYn;
	
	 // 좌석 top 좌표
	 private String seatTop;
	
	 // 좌석 left 좌표
	 private String seatLeft;
	
	 // 좌석 구분
	 private String seatDvsn;
	
	 // 예약 최소 요청 일자
	 private String seatReqDay;
	
	 // 좌석 등급
	 private String seatClass;
	
	 // 비용 처리 여부
	 private String seatClassinfo;
	 
	 // 비용 처리 여부
	 private String seatOrder;
	
	 // 지불 구분
	 private String payDvsn;
	
	 // 전일 비용 금액
	 private String payCost;
	
	 // 오전 좌석 비용
	 private String payAmCost;
	
	 // 오후 좌석 비용
	 private String payPmCost;
	
	 // QR 코드
	 private String seatQrCd;
	
	 // QR 패스
	 private String seatQrCdPath;
	
	 // QR FULL 패스
	 private String seatQrCdFullPath;
	
	 // 최초 등록 일자
	 private String frstRegistDtm;
	 
	 // 최초 등록자 ID
	 private String frstRegterId;
	
	 // 최종 수정 일자 
	 private String lastUpdtDtm;
	
	 // 최종 수정자 ID 
	 private String lastUpdusrId;
	 
	 // 입력 구분
	 private String mode;
	 
	 private String userId = "";
}