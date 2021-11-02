package com.kses.backoffice.bld.season.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

//시즌별 좌석 현황
@Getter
@Setter
public class SeasonSeatInfo {

	 // 시즌 좌석 코드
	 @JsonProperty("season_seatcode")
	 private String seasonSeatcode;
	
	 // 시즌 코드
	 @JsonProperty("season_code")
	 private String seasonCode;
	
	 // 지점
	 @JsonProperty("center_code")
	 private String centerCode;
	
	 // 지점 정보
	 @JsonProperty("floor_code")
	 private String floorCode;
	
	 // 구역정보
	 @JsonProperty("part_code")
	 private String partCode;
	
	 // 좌석 코드
	 @JsonProperty("seat_code")
	 private String seatCode;
	
	 // 비용
	 @JsonProperty("seaon_cost")
	 private int seaonCost;
	
	 // 오전 비용
	 @JsonProperty("seaon_am_cost")
	 private int seaonAmCost;
	
	 // 오후 비용
	 @JsonProperty("seaon_pm_cost")
	 private int seaonPmCost;
	
	 // 좌석 구분
	 @JsonProperty("seat_gubun")
	 private String seatGubun;
	
	 // 좌석 등급
	 @JsonProperty("seat_class")
	 private String seatClass;
	
	 // 좌석 등급
	 @JsonProperty("season_class")
	 private String seasonClass;
	
	 // 사용여부
	 @JsonProperty("season_use_at")
	 private String seasonUseAt;
	
	 // 최초 등록일자
	 @JsonProperty("frst_register_pnttm")
	 private String frstRegisterPnttm;
	
	 // 최초 등록자
	 @JsonProperty("frst_register_id")
	 private String frstRegisterId;
	
	 // 최종 수정 일자
	 @JsonProperty("last_updusr_pnttm")
	 private String lastUpdusrPnttm;
	
	 // 최종 수정자
	 @JsonProperty("last_updusr_id")
	 private String lastUpdusrId;
}