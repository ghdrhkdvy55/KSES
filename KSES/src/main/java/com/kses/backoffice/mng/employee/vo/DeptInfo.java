package com.kses.backoffice.mng.employee.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

//공통 부서 정보
@Getter
@Setter
public class DeptInfo {
	 // 부서코드
	 private String deptCd = "";
	
	 // 부서명
	 private String deptNm = "";
	
	 // 부서 상세 설명
	 private String deptDc = "";
	
	 // 사용 유무
	 private String useYn = "";
	 // 최종 수정 일자
	 private String lastUpdusrPnttm;
	 
	 private String mode = "";
}
