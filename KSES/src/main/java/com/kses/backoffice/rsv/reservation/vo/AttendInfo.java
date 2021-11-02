package com.kses.backoffice.rsv.reservation.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

//입출입 내역
@Getter
@Setter
public class AttendInfo {

	 // 입출입 시퀀스 
	 @JsonProperty("att_seq")
	 private Double attSeq;
	
	 // 예약 시퀀스 
	 @JsonProperty("res_seq")
	 private Double resSeq;
	
	 // 고객 아이디 
	 @JsonProperty("user_id")
	 private String userId;
	
	 // qr 체크 시간 
	 @JsonProperty("room_checktime")
	 private String roomChecktime;
	
	 // 입출입구분 
	 @JsonProperty("att_gubun")
	 private String attGubun;
	
	 // QR 업데이트 상태 
	 @JsonProperty("qr_update")
	 private String qrUpdate;
	
	 // 통신 시간 
	 @JsonProperty("receive_date")
	 private String receiveDate;
	
	 // 통신 결과 
	 @JsonProperty("receive_code")
	 private String receiveCode;
}