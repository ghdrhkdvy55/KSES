package com.kses.backoffice.bas.system.vo;

import lombok.Getter;
import lombok.Setter;

//스피드온 자동결제 정보
@Getter
@Setter
public class AutoPaymentInfo {
	
	// 자동결제 요일
	private String autoPaymentDay;
	
	// 자동결제 시작시간
	private String autoPaymentOpenTm;
	
	// 자동결제 종료시간
	private String autoPaymentCloseTm;

	// 사용여부
	private String useYn;
}