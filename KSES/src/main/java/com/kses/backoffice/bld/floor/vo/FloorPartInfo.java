package com.kses.backoffice.bld.floor.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FloorPartInfo {
		
	 // 층 정보
	 private String centerCd;
	 
	 // 지점 아이디 
	 private String floorCd;

	 // 지점 층 코드 
	 private String partCss;
	 
	 // 지점 층 코드 
	 private String partCd;
	
	 // 층 이름 
	 private String partNm;
	
	 // 층 이미지1
	 private String partMap1;
	
	 // 층 이미지2
	 private String partMap2;
	 
	 // 지점 층 코드 
	 private String partMiniCss;

	 // 지점 층 코드 
	 private String partMiniLeft;
	 
	 // 지점 층 코드 
	 private String partMiniTop;
	 
	 // 지점 층 코드 
	 private String partMiniWidth;
	 
	 // 지점 층 코드 
	 private String partMiniHeight;
	
	 // 층 네이밍 정보
	 private String partSeatRule;
	
	 // 사용 유무
	 private String useYn;
	 
	 // 구역 사용 유무
	 private String partOrder;
	 
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
	 
	 private String userId = "";
	 
	 private String partMiniRotate = "";
	 
	 private String partPayCost = "";
}