package com.kses.backoffice.mng.employee.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

// 공통직책정보
@Getter
@Setter
public class PositionInfo {
	
	private String psitCd = "";
	private String psitNm = "";
	private String psitDc = "";
	private String useYn = "";
	private String lastUpdtDtm = "";
	private String mode = "";
}
