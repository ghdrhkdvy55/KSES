package com.kses.backoffice.bas.holy.vo;

import lombok.Getter;
import lombok.Setter;

//휴일정보
@Getter
@Setter
public class HolyInfo {

	// 휴일 코드
 	private String holySeq = "";

 	// 지점 정보
 	private String centerCd = "";

 	// 휴일
 	private String holyDt = "";
 	
 	// 휴일명
 	private String holyNm = "";

 	// 사용 유무
 	private String useYn = "";

 	// 최초 등록 일자
 	private String frstRegistDtm = "";

 	// 최초 등록 ID
 	private String frstRegisterId = "";

 	// 최종 수정 일자
 	private String lastUpdtDtm = "";

 	// 최종 수정 ID
 	private String lastUpdusrId = "";

 	private String targetHolyDt = "";
 	
 	// 입력 구분
 	private String mode = "";
 	
    private String userId = "";
    
    private int cnt = 0;
}