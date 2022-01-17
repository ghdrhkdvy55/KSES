package com.kses.backoffice.bld.partclass.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PartClassInfo {
	// 지점코드 
	private String partSeq;
	
	// 지점코드 
	private String centerCd;
	
	// 구역등급 
	private String partClass;
	
	// 지점코드 
	private String partPayCost;
	
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
	
	//
	private String mode;
	
	private String userId = "";
}
