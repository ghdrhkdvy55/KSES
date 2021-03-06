package com.kses.backoffice.bld.center.vo;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

//지점 정보 
@Getter
@Setter
public class CenterInfo {

	 // 지점 아이디 
	 private String centerCd;
	
	 // 지점명 
	 private String centerNm;
	
	 // 우편번호 
	 private String centerZipcd;
	
	 // 주소1 
	 private String centerAddr1;
	
	 // 주소2
	 private String centerAddr2;
	
	 // 전화번호 
	 private String centerTel;
	
	 // 팩스 
	 private String centerFax;
	
	 // URL 주소 
	 private String centerUrl;
	
	 // 전경 사진 
	 private String centerImg;
	
	 // 지도 
	 private String centerMap;
	
	 // 사용유무 
	 private String useYn;
	
	 // 지점 상세 정보 
	 private String centerInfo;
	
	 // 휴일 정보 사용 여부 
	 private String centerHolyUseYn;
	
	 // 사용 층수 
	 private String floorInfo;
	
	 // 시작 층수 
	 private String startFloor;
	
	 // 종료 층수 
	 private String endFloor;
		
	 // 지점 예약 구분 ; 회원만 비회원도 예약 
	 private String centerResvDvsn;
	
	 // 지점 지역정보 
	 private String centerArea;
	
	 // 경기장 구분 
	 private String centerStdmDvsn;
	 
	 // 최초 등록 일자
	 private String frstRegistDtm;
	
	 // 최초 등록자 ID 
	 private String frstRegterId;
	
	 // 최종 수정 일자 
	 private String lastUpdtDtm;
	
	 // 최종 수정자 ID 
	 private String lastUpdusrId;
	 	 
	 // 사용 층수
	 private List<?> floorList;
	 
	 // 입력 구분 
	 private String mode;
	 
	 // 등록/수정자 ID
	 private String userId = "";
	 
	 // 시범 지점 유무 
	 private String centerPilotYn = "";
	 
	 // 스피드온 지점코드
	 private String centerSpeedCd = "";
	 
	 // 자유석 사용 유무
	 private String centerStandYn = "";
	 
	 // 비회원 예약 가능 유무
	 private String centerGuestYn = "";
	 
	 // 지점 최대 자유석 수
	 private String centerStandMax = "";
	 
	 // 지점 입장료
	 private String centerEntryPayCost = "";
	 
	 // 지점 스피드온 입장료
	 private String centerSpeedEntryPayCost = "";
	 
	 // SPDM 지점코드
	 private String centerRbmCd = "";
	 
	 // 지점 예약가능일
	 private String centerResvAbleDay = "";
	 
	 // 지점 정렬 순서
	 private String centerOrder = "";
}