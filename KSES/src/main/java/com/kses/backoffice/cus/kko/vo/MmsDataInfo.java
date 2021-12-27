package com.kses.backoffice.cus.kko.vo;

import lombok.Data;

@Data
public class MmsDataInfo {
	//연번
	private String seqno = "";
	
	//고객사 코드
	private String usercode = "";
	
	//요청일시
	private String intime = "";
	
	//예약발시
	private String reqtime = "";
	
	//단말기 수신시간
	private String recvtime = "";
	
	//수신자 전화번호
	private String callphone = "";
	
	//발송자 전화번호
	private String reqphone = "";
	
	//제목
	private String subject = "";
	
	//문자메세지 내용(한글 1,000자, 영문 2,000자)
	private String msg = "";
	
	//미디어 외부참조키
	private String fkcontent = "";
	
	//미디어 타입(수신단말기의 이동통신사 구분)
	private String mediatype = "";
	
	//전송결과("Y":슈어엠 전송, "N" : 슈어엠 전송실패, "2":단말기 전송성공, "4":단말기 전송실패)
	private String result = "";
	
	//에러코드(RESULT가 "4" 일 경우 "205":번호이동 DB조회불가, "208":기타실패, "211":전원꺼짐)
	private String errcode = "";
}
