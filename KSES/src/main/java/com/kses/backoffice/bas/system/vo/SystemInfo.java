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
	
	// 비회원 예약 가능 여부
	private String guestResvPossibleYn;
	
	// 1차 자동취소 사용여부 
	private String autoCancelR1UseYn;
	
	// 2차 자동취소 사용여부 
	private String autoCancelR2UseYn;
}