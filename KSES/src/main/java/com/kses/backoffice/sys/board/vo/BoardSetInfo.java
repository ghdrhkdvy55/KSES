package com.kses.backoffice.sys.board.vo;

import lombok.Getter;
import lombok.Setter;

//게시판 환경 설정 
@Getter
@Setter
public class BoardSetInfo {

	private String boardCd  = "";
	private String boardTitle  = "";
	private String boardDvsn  = "";
	private String boardAuthor  = "";
	private String boardCenterId  = "";
	private String boardSize  = "";
	private String boardNoticeDvsn  = "";
	private String useYn  = "";
	private String boardFileUploadYn  = "";
	private String boardCmntUse  = "";
	private String frstRegterId  = "";
	private String frstRegistDtm  = "";
	private String lastUpdusrId  = "";
	private String lastUpdtDtm  = "";
	private String mode = "";
	private String userId = "";
	private String menuNo = "";
	
}