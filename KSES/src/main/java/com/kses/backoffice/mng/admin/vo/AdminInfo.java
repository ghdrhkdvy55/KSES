package com.kses.backoffice.mng.admin.vo;

import lombok.Getter;
import lombok.Setter;

//휴일정보
@Getter
@Setter
public class AdminInfo {

   
	private String adminId = "";
	private String adminPwd = "";
	private String empNo = "";
	private String authorCd = "";
	private String adminLockyn = "";
	private String useYn = "";
	private String adminPassUpdtDt = "";
	private String frstRegistDtm = "";
	private String frstRegterId = "";
	private String lastUpdtDtm = "";
	private String lastUpdusrId = "";
	private String mode = "";
	private String userId = "";
	private String centerCd = "";
	private int cnt = 0;
}