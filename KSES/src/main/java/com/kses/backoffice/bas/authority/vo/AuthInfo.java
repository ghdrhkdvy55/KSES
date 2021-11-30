package com.kses.backoffice.bas.authority.vo;

import lombok.Getter;
import lombok.Setter;

//권한 정보
@Getter
@Setter
public class AuthInfo {

	 // 권한코드
	 private String authorCode;
	
	 // 권한명
	 private String authorNm;
	
	 // 권한 설명
	 private String authorDc;
	
	 // 권한 생성일자
	 private String authorCreatDe;
	 
	 // 입력구분
	 private String mode;
}