package com.kses.backoffice.bld.partclass.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PartClassInfo {
	// 지점코드 
	private String partClassSeq;
	
	// 지점코드 
	private String centerCd;
	
	// 구역등급 
	private String partClass;
	
	// 구역 일반 금액
	private String partPayCost;
	
	// 구역 스피드온 금액
	private String partSpeedPayCost;
	
	// 구역아이콘 
	private String partIcon;
	
	// 사용구분 
	private String useYn;
	
	// 최초 등록일 
	private String frstRegistDtm;
	
	// 최초 등록자
	private String frstRegterId;
	
	// 최종 수정일
	private String lastUpdtDtm;
	
	// 최종 수정일
	private String lastUpdusrId;
	
	// 정렬 순서
	private String partClassOrder;
	
	// 입력 구분
	private String mode;
	
	// 등록 & 수정자 아이디
	private String userId = "";
}