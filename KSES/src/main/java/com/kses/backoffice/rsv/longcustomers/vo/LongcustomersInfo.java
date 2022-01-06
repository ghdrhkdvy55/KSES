package com.kses.backoffice.rsv.longcustomers.vo;

import lombok.Getter;
import lombok.Setter;

//휴일정보
@Getter
@Setter
public class LongcustomersInfo {

	// 장기 예약 시퀀스
	private String longResvSeq;
	 
	// 지점 코드
	private String centerCd;
		 
	// 층 코드
	private String floorCd;

	// 구역 코드
	private String partCd;

	// 층 코드
	private String seatCd;

	// 장기 예약 시작일
	private String longResvStartDt;
	
	// 장기 예약 종료일
	private String longResvEndDt;
		 
	// 고객 아이디
	private String userId;
	
	// 예약 담당자 사번
	private String empNo;
	
	// 최초 등록 시간
	private String frstRegistDtm;
	
	// 최초 등록자
	private String frstRegterId;
	
	// 최종 수정 시간
	private String lastUpdtDtm;
	
	// 최종 수정자
	private String lastUpdusrId;
	
	// 시즌 코드
	private String seasonCd;

}