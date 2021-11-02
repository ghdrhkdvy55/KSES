package com.kses.backoffice.bld.center.vo;

import lombok.Getter;
import lombok.Setter;

//지점 휴일 정보 
@Getter
@Setter
public class CenterHolyInfo {

	 // 지점 휴일 코드
	 private String centerHolySeq;
	
	 // 지점 정보 
	 private String centerCd;
	
	 // 휴일
	 private String holyDt;
	 
	 // 휴일명
	 private String holyNm;
	
	 // 사용 유무
	 private String useYn;
	 
	 // 최초 등록 일자
	 private String frstRegistDtm;
	
	 // 최초 등록자 ID 
	 private String frstRegterId;
	
	 // 최종 수정 일자 
	 private String lastUpdtDtm;
	
	 // 최종 수정자 ID 
	 private String lastUpdusrId;
	 
	 // 입력 구분 
	 private String mode;
}