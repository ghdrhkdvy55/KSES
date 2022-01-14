package com.kses.backoffice.bas.system.vo;

import lombok.Getter;
import lombok.Setter;

//기초 환경 정보
@Getter
@Setter
public class SystemInfo {
	
	// 시스템 코드
	private String systemCd;
	
	// 사이트명
	private String comTitle;
	
	// 회원 전일 오픈 시간
	private String userEveDayOptm;

	// 비회원 전일 오픈 시간
	private String nonUserEveDayOptm;
	
	// 지점 자동취소 오전시간
	private String centerAutoCancleAmtm;

	// 지점 자동취소 오후시간
	private String centerAutoCanclePmtm;
	
	// 지점 자동취소 종일시간
	private String centerAutoCancleAlltm;
	
	// 블랙리스트 해제일
	private String blklstRlsdt;
	
	//비회원 예약 가능 여부
	private String guestResvPossibleYn;
}

