package com.kses.backoffice.cus.kko.vo;

import lombok.Data;

@Data
public class SmsDataInfo {
	//연번
	private String seqno = "";
	
	//입력일자
	private String indate = "";
	
	//요청일시
	private String intime = "";

	//예약발시
	private String member = "";

	//회사아이디
	private String sendid = "";
	
	//발신자이름
	private String sendname = "";
	
	//수신전화번호(전체)
	private String rphone;
	
	//수신전화번호(앞자리)
	private String rphone1 = "";

	//수신전화번호(두번째자리)
	private String rphone2 = "";
	
	//수신전화번호(세번째자리)
	private String rphone3 = "";
	
	//수신자이름
	private String recvname = "";
	
	//발신자전화번호(앞자리)
	private String sphone1 = "";
	
	//발신자전화번호(두번째자리)
	private String sphone2 = "";
	
	//발신자전화번호(세번째자리)
	private String sphone3 = "";
	
	//메세지
	private String msg = "";
	
	//URL
	private String url = "";
	
	//발송일자(사용안함)
	private String rdate = "";
	
	//발송시간(사용안함)
	private String rtime = "";
	
	//발송결과(Y:발송기 발송성공, N:발송기 발송실패, 2:통신사에서 발송성공, 4:통신사에서 오류(번호오류,수신불가))
	private String result = "";
	
	//메세지종류(SMS:S)
	private String kind = "";
	
	//에러코드(77:메세지내용없음)
	private String errcode = "";
	
	//시스템 구분
	private String sysGbn = "";
	
	//발송자 사번
	private String userid = "";
	
	//회신시각(결과값 수신시간)
	private String recvtime = "";
	
	//인증코드
	private String certifiCode = "";
	
	@Override 
	public boolean equals(Object o) { 
		if (o instanceof SmsDataInfo) { 
			return this.rphone.equals(((SmsDataInfo) o).getRphone()); 
		} else {
			return super.equals(o);
		}
	}
}