package com.kses.backoffice.mng.employee.vo;

import lombok.Getter;
import lombok.Setter;

//사용자 정보
@Getter
@Setter
public class EmpInfo {
	
	private String empId = "";
	private String empNo = "";
	private String empNm = "";
	private String deptCd = "";
	private String deptNm = "";
	private String gradCd = "";
	private String gradNm = "";
	private String psitCd = "";
	private String psitNm = "";
	private String useYn = "";
	private String empClphn = "";
	private String empTlphn = "";
	private String empEmail = "";
	private String adminDvsn = "";
	private String empState = "";
	private String empPic = "";
	private String lastUpdtDtm = "";
	private String lastUpdusrId = "";
	private String mode = "";
	private int cnt = 0;
	private String userId = "";
}