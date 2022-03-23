package com.kses.backoffice.bld.center.vo;

import lombok.Getter;
import lombok.Setter;

//사전예약 입장시간
@Getter
@Setter
public class PreOpenInfo {

	 // 사전예약 입장시간 코드
	 private String optmCd;
	
	 // 지점 코드
	 private String centerCd;

	 // 입장 요일
	 private String openDay;
	 
	 // 회원 입장시간
	 private String openMemberTm;
	
	 // 비회원 입장시간
	 private String openGuestTm;
	 
	 // 회원 예약 종료시간
	 private String closeMemberTm;
		
	 // 비회원 예약 종료시간
	 private String closeGuestTm;
	
	 // 사용유무
	 private String useYn;
	
	 // 최초 등록 일자
	 private String frstRegistDtm;
	
	 // 최초 등록자 ID 
	 private String frstRegterId;
	
	 // 최종 수정 일자 
	 private String lastUpdtDtm;
	
	 // 최종 수정자 ID 
	 private String lastUpdusrId;
	 
	 // 복사 지점 코드
	 private String copyCenterCd;
}