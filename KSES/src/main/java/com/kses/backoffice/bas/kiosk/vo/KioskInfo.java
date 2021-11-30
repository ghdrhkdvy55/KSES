package com.kses.backoffice.bas.kiosk.vo;

import lombok.Getter;
import lombok.Setter;

//휴일정보
@Getter
@Setter
public class KioskInfo {

	
	// 무인 발권기 시리얼 넘버
 	private String ticketMchnSno;
 	
 	// 무인 발권기 타겟 시리얼 넘버
 	private String targetTicketMchnSno = "";

 	// 지점 코드
 	private String centerCd = "";

 	// 층 코드
 	private String floorCd = "";

 	// 사용 유무
 	private String useYn = "";
 	
 	// 무인 발권기 상세 설명
 	private String ticketMchnRemark = "";

 	// 최초 등록자
 	private String frstRegisterId = "";
 	
 	// 최초 등록 일자
 	private String frstRegistDtm = "";

 	// 최종 수정자
	private String lastUpdusrId = "";
 	
	// 최종 수정 일자
 	private String lastUpdtDtm = "";
 	
 	// 입력 구분
 	private String mode = "";
 	
 	private String userId = "";
}