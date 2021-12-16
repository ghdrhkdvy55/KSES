package com.kses.backoffice.cus.usr.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserInfo {
	// 구분값
	// 1: 아이디, 비밀번호 / 2: 카드번호, 비밀번호
	private String loginType = "";
	
	// 회원 구분 - 회원 / 비회원
	private String userDvsn = "";
	
	// 아이디
	private String userId = "";
	
	// 이름
	private String userNm = "";
	
	// 전화번호
	private String userPhone = "";
	
	// 성별
	private String userSexMf = "";
	
	// 생일
	private String userBirthDy = "";
	
	// 개인정보 동의여부
	private String indvdlinfoAgreYn = "";
	
	// 개인정보 동의일자
	private String indvdlinfoAgreDt = "";
	
	// 현금영수증 발급여부
	private String userRcptYn = "";
	
	// 현금영수증 발급구분
	private String userRcptDvsn = "";
	
	// 현금영수증 번호
	private String userRcptNumber = "";
	
	// 최종 수정일
	private String lastUpdtDtm = "";
	
	// 최종 수정자
	private String lastUpdusrId = "";
	
	// 입력 구분
	private String mode = "";
	
	// 카드 아이디
	private String userCardId = "";
	
	// 카드 번호
	private String userCardNo = "";
	
	// 카드 시퀀스
	private String userCardSeq = "";
	
	// 카드 비밀번호
	private String userCardPassword = "";
	
	// 백신접종일자
	private String vacntnDt = "";

	// 접종백신종류
	private String vacntnDvsn = "";
	
	// 백신접종회차
	private String vacntnRound = "";
	
	// 마지막 접속 일자
	private String lastLoginDt = "";
}