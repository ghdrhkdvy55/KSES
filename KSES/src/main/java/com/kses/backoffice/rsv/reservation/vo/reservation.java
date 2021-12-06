package com.kses.backoffice.rsv.reservation.vo;

public enum reservation {
	
	RESV_ERROR_000("RESV_ERROR_000", "해당 지점은 현재 예약하려는 일자에 휴일입니다."),
	RESV_ERROR_001("RESV_ERROR_001", "해당 지점은 현재 예약 가능시간이 아닙니다."),
	RESV_ERROR_002("RESV_ERROR_002", "이미 예약된 좌석입니다."),  
	RESV_ERROR_003("RESV_ERROR_003", "시스템 에러가 발생하였습니다."); 
	
	private String code; 
	private String name; 
	reservation(String code, String name) { 
		this.code = code; 
		this.name = name; 
	} 
	public String getCode() { 
		return this.code; 
	} 
	public String getName() { 
		return this.name; 
	}	
}