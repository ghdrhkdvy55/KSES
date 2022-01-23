package com.kses.backoffice.bld.center.vo;

import lombok.Getter;
import lombok.Setter;

//지점 휴일 정보 
@Getter
@Setter
public class BillDayInfo {
	 // 지점 현금영수증 코드
	 private String billdayCd;

	 // 지점 현금영수증 코드
	 private String billSeq;
	
	 // 지점 정보 
	 private String centerCd;
	
	 // 지점 현금영수증 발행처 사업자 번호
	 private String billNum;
	
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