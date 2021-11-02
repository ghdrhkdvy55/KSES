package com.kses.backoffice.rsv.reservation.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

//예약 시간 정보 테이블
@Getter
@Setter
public class ResTimeInfo {

	// 예약 시간 시퀀스
	@JsonProperty("time_seq")
 	private int timeSeq;

 	// 지점 정보
 	@JsonProperty("center_code")
 	private String centerCode;

 	// 시즌코드
 	@JsonProperty("seat_code")
 	private String seatCode;

 	// 층 정보
 	@JsonProperty("floor_code")
 	private String floorCode;

 	// 구역 정보
 	@JsonProperty("part_code")
 	private String partCode;

 	// 예약 시간
 	@JsonProperty("swc_time")
 	private String swcTime;

 	// 예약 시퀀스
 	@JsonProperty("res_seq")
 	private int resSeq;

 	// 승인 여부
 	@JsonProperty("apprival")
 	private String apprival;
}
