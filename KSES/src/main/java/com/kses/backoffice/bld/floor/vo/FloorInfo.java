package com.kses.backoffice.bld.floor.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FloorInfo {

	 // 지점 층 코드 
	 private String floorCd;
	
	 // 지점 아이디 
	 private String centerCd;
	
	 // 층 정보
	 private String floorInfo;
	
	 // 층 이름 
	 private String floorNm;
	
	 // 층 이미지1
	 private String floorMap1;
	
	 // 층 이미지2
	 private String floorMap2;
	
	 // 좌석 사용 수량
	 private String floorSeatCnt;
	
	 // 층 네이밍 정보
	 private String floorSeatRule;
	
	 // 사용 유무
	 private String useYn;
	 
	 // 구역 사용 유무
	 private String floorPartDvsn;
	 
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