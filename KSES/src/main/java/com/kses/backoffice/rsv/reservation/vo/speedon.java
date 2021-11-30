package com.kses.backoffice.rsv.reservation.vo;

import java.util.Collections;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public enum speedon {
	
	USER_ERROR_000("USER_ERROR_000", "FEP 오류"), 
	USER_ERROR_001("USER_ERROR_001", "아이이 또는 패스워드 없음"), 
	USER_ERROR_002("USER_ERROR_002", "카드번호 또는 패스워드 없음"), 
	USER_ERROR_003("USER_ERROR_003", "알수 없는 로그인 타입"), 
	USER_ERROR_004("USER_ERROR_004", "회원정보 없음"), 
	USER_ERROR_005("USER_ERROR_005", "이용정지 회원"), 
	USER_ERROR_006("USER_ERROR_006", "비밀번호 불일치"), 
	USER_ERROR_007("USER_ERROR_007", "시스템타입 없음"), 
	TRADE_ERROR_000("TRADE_ERROR_000", "FEP 오류"), 
	TRADE_ERROR_001("TRADE_ERROR_001", "Card Id 또느 Card Seq 없음"), 
	TRADE_ERROR_002("TRADE_ERROR_002", "Card Pw 없음"), 
	TRADE_ERROR_003("TRADE_ERROR_003", "알수없는 Div_Cd"), 
	TRADE_ERROR_004("TRADE_ERROR_004", "알수없는 Trade_Cd"), 
	TRADE_ERROR_005("TRADE_ERROR_005", "거래금액 오류"), 
	TRADE_ERROR_006("TRADE_ERROR_006", "거래 상세내용 오류"), 
	TRADE_ERROR_007("TRADE_ERROR_007", "회원정보 없음"), 
	TRADE_ERROR_008("TRADE_ERROR_008", "이용정지"), 
	TRADE_ERROR_009("TRADE_ERROR_009", "카드(구매) 비밀번호 설정되지 않음"), 
	TRADE_ERROR_010("TRADE_ERROR_010", "비밀번호 불일치"), 
	TRADE_ERROR_011("TRADE_ERROR_011", "입출금 업무서비스 비활성화"), 
	TRADE_ERROR_012("TRADE_ERROR_012", "잔액 부족"), 
	TRADE_ERROR_013("TRADE_ERROR_013", "시스템타입 없음"), 
	TRADE_ERROR_014("TRADE_ERROR_014", "알수없는 Trade_No"); 
	
	
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
