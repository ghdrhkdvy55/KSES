package com.kses.backoffice.bld.center.vo;

import lombok.Getter;
import lombok.Setter;

//자동 취소 시간 정보
@Getter
@Setter
public class NoshowInfo {

	 // 노쇼 코드
	 private String noshowCd;
	
	 // 지점 아이디
	 private String centerCd;
	
	 // 실행 요일
	 private String noshowDay;
	
	 // 노쇼 오전 시간
	 private String noshowAmTm;
	
	 // 노쇼 오후 종료 시간
	 private String noshowPmTm;
	
	 // 노쇼 종일 시간
	 private String noshowAllTm;
	
	 // 최초 등록 일자
	 private String frstRegistDtm;
	
	 // 최초 등록자 ID 
	 private String frstRegterId;
	
	 // 최종 수정 일자 
	 private String lastUpdtDtm;
	
	 // 최종 수정자 ID 
	 private String lastUpdusrId;
}