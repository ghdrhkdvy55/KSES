package com.kses.backoffice.bld.center.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

//자동 취소 시간 정보
@Getter
@Setter
public class NoShowInfo {

	 // 노쇼 코드
	 @JsonProperty("noshow_code")
	 private String noshowCode;
	
	 // 지점 아이디
	 @JsonProperty("center_code")
	 private String centerCode;
	
	 // 실행 요일
	 @JsonProperty("noshow_week")
	 private String noshowWeek;
	
	 // 노쇼 오전 시간
	 @JsonProperty("noshow_am_time")
	 private String noshowAmTime;
	
	 // 노쇼 오후 종료 시간
	 @JsonProperty("noshow_pm_time")
	 private String noshowPmTime;
	
	 // 노쇼 종일 시간
	 @JsonProperty("noshow_all_time")
	 private String noshowAllTime;
	
	 // 최초 등록일
	 @JsonProperty("frst_register_pnttm")
	 private String frstRegisterPnttm;
	
	 // 최초 등록자
	 @JsonProperty("frst_register_id")
	 private String frstRegisterId;
	
	 // 최종 수정일
	 @JsonProperty("last_updusr_pnttm")
	 private String lastUpdusrPnttm;
	
	 // 최종 수정자 아이디
	 @JsonProperty("last_updusr_id")
	 private String lastUpdusrId;
}