package com.kses.front.login.vo;

import lombok.Getter;
import lombok.Setter;

//전자카드 회원 정보 
@Getter
@Setter
public class UserLoginInfo {

	 // 구분값
	// 1: 아이디, 비밀번호 / 2: 카드번호, 비밀번호
	private String loginType;
	
	// 로그인 성공여부
	// Y : ID, 카드번호, 이름, 전화번호, 성별, 생년월일 / N : NULL
	private String loginYn;
	
	// 카드 아이디
	// 사용자 Key1
	private String cardId;
	
	// 카드발급회차
	// 사용자 Key2
	private String cardSeq;
	
	// 사용자 구분
	// I : 승인대기 / N : 정상 / C : 정상이지만 카드(결제) 비밀번호 미설정
	private String userType;
	
	// 사용자 아이디
	private String userId;
	
	// 사용자 이름
	private String userNm;
	
	// 카드번호
	private String cardNo;
	
	// 전화번호
	private String userPhone;
	
	// 성별
	// M : 남성 / F : 여성
	private String userSexMf;
	
	// 생년월일
	private String userBirthDy;
	
	// 에러코드
	// 로그인 실패시(USER_ERROR_001, ...002, ... 003 ~) / SUCCESS
	private String errorCd;
	
	// FEP 에러코드
	// FEP 실패시(FEP_ERROR_001, ...002, ... 003 ~)
	private String fepErrorCd;
	
	private String userDvsn;
}