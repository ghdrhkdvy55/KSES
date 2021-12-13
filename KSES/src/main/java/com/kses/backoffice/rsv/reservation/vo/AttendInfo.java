package com.kses.backoffice.rsv.reservation.vo;

import lombok.Getter;
import lombok.Setter;

//입출입 내역
@Getter
@Setter
public class AttendInfo {
	
	private String qrCheckSeq = "";
	private String resvSeq = "";
	private String userId = "";
	private String qrCheckTm = "";
	private String inoutDvsn = "";
	private String qrUpdt = "";
	private String rcvDt = "";
	private String rcvCd = "";
	private String qrCode = "";
	private String userNm = "";
	private String mode = "";
	private int ret = 0;
	
	private String qrInot = "";
	private String qrCneterCd = "";
			
}