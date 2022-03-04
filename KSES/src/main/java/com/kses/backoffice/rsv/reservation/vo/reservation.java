package com.kses.backoffice.rsv.reservation.vo;

public enum reservation {
	
	RESV_ERROR_000("RESV_ERROR_000", "해당 지점은 현재 예약하려는<br>일자에 휴일입니다."),
	RESV_ERROR_001("RESV_ERROR_001", "해당 지점은 현재 예약 가능시간이 아닙니다."),
	RESV_ERROR_002("RESV_ERROR_002", "이미 예약된 좌석입니다 좌석현황을 확인해주세요."),
	RESV_ERROR_003("RESV_ERROR_003", "출입통제 대상입니다 관리자에게 문의바랍니다."),
	RESV_ERROR_004("RESV_ERROR_004", "현재 예약일자에 이미 예약정보가 존재합니다."),
	RESV_ERROR_005("RESV_ERROR_005", "예약 기간중 이미 예약 회원의 예약정보가 존재합니다."),
	RESV_ERROR_006("RESV_ERROR_006", "최대자유석수를 초과하였습니다.<br>지정 좌석예약을 이용바랍니다."),
	RESV_ERROR_007("RESV_ERROR_007", "예약일자가 올바르지 않습니다."),
	RESV_ERROR_999("RESV_ERROR_999", "시스템 에러가 발생하였습니다.");
	
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