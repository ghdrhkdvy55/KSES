package com.kses.backoffice.rsv.reservation.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

//자동 취소 시간 결과 정보
@Getter
@Setter
public class NoShowHisInfo {

	 // 노쇼 his 시퀀스
	 @JsonProperty("noshow_seq")
	 private int noshowSeq;
	
	 // 노쇼 코드
	 @JsonProperty("noshow_coe")
	 private String noshowCoe;
	
	 // 좌석 코드
	 @JsonProperty("seat_code")
	 private String seatCode;
	
	 // 예약 코드
	 @JsonProperty("res_seq")
	 private int resSeq;
	
	 // 노쇼 배치 실행 타임
	 @JsonProperty("noshow_palytime")
	 private String noshowPalytime;
	
	 // 배치 결과
	 @JsonProperty("noshow_result")
	 private String noshowResult;
	
	 // 노쇼 코드
	 @JsonProperty("noshow_result_code")
	 private String noshowResultCode;
}
