package com.kses.backoffice.bld.floor.vo;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

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

	@JsonIgnore
	private MultipartFile partMap1File;
	
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
	 
	 // 구역 등급
	 private String partClass;
	 
	 // 구역 비용
	 private String partPayCost;
	 
	 // 구역 순서
	 private String partOrder;
	 
	// 구역 등급 시퀀스
	private String partClassSeq;
	 
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
}