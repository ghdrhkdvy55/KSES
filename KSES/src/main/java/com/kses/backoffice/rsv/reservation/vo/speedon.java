package com.kses.backoffice.rsv.reservation.vo;

import java.util.Collections;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public enum speedon {
	
	USER_ERROR_000("USER_ERROR_000", "FEP 오류"), 
	USER_ERROR_001("USER_ERROR_001", "아이디 또는 패스워드 정보가 불일치 합니다."), 
	USER_ERROR_002("USER_ERROR_002", "카드번호 또는 패스워드 없음"), 
	USER_ERROR_003("USER_ERROR_003", "알수 없는 로그인 타입"), 
	USER_ERROR_004("USER_ERROR_004", "존재하지 않는 회원 정보입니다."), 
	USER_ERROR_005("USER_ERROR_005", "스피드온 앱에서 본인인증 및 이용정지 해제 바랍니다."), 
	USER_ERROR_006("USER_ERROR_006", "아이디 또는 패스워드 정보가 불일치 합니다."), 
	USER_ERROR_007("USER_ERROR_007", "시스템타입이 올바르지 않습니다."), 
	TRADE_ERROR_000("TRADE_ERROR_000", "FEP 오류발생"), 
	TRADE_ERROR_001("TRADE_ERROR_001", "알수없는 카드정보로 인한 오류가 발생하였습니다."), 
	TRADE_ERROR_002("TRADE_ERROR_002", "카드비밀번호가 불일치 합니다."), 
	TRADE_ERROR_003("TRADE_ERROR_003", "알수없는 Div_Cd"), 
	TRADE_ERROR_004("TRADE_ERROR_004", "알수없는 Trade_Cd"), 
	TRADE_ERROR_005("TRADE_ERROR_005", "잔액이 부족합니다. <br>스피드온 계좌를 충전하거나 무인발권기를 이용해주세요."), 
	TRADE_ERROR_006("TRADE_ERROR_006", "거래 상세내용 오류"), 
	TRADE_ERROR_007("TRADE_ERROR_007", "존재하지 않는 회원 정보입니다."), 
	TRADE_ERROR_008("TRADE_ERROR_008", "스피드온 앱에서 본인인증 및 이용정지 해제 바랍니다."), 
	TRADE_ERROR_009("TRADE_ERROR_009", "카드(구매) 비밀번호 설정되지 않음"), 
	TRADE_ERROR_010("TRADE_ERROR_010", "카드비밀번호가 불일치 합니다."), 
	TRADE_ERROR_011("TRADE_ERROR_011", "입출금 업무서비스 비활성화"), 
	TRADE_ERROR_012("TRADE_ERROR_012", "잔액이 부족합니다.<br>스피드온 앱에서 계좌충전 바랍니다."), 
	TRADE_ERROR_013("TRADE_ERROR_013", "시스템타입 없음"), 
	TRADE_ERROR_014("TRADE_ERROR_014", "지금은 결제 가능시간이 아닙니다."),
	TRADE_ERROR_015("TRADE_ERROR_015", "External key 없음"), 
	TRADE_ERROR_016("TRADE_ERROR_016", "거래내역 정보 없음"); 
	
	private String code; 
	private String name; 
	speedon(String code, String name) { 
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