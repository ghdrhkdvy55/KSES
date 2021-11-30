package com.kses.backoffice.sys.board.vo;


import lombok.Getter;
import lombok.Setter;

//게시판 정보 
@Getter
@Setter
public class BoardInfo {

	private String boardSeq = "";
	private String boardCd = "";
	private String boardRefno = "";
	private String boardClevel = "";
	private String boardNoticeStartDay = "";
	private String boardNoticeEndDay = "";
	private String boardPopup = "";
	private String boardTitle = "";
	private String boardTopSeq = "";
	private String boardVisitCnt = "";
	private String useYn = "";
	private String frstRegterId = "";
	private String frstRegistDtm = "";
	private String lastUpdusrId = "";
	private String lastUpdtDtm = "";
	private String boardCn = "";
	private String mode = "";
	private String userId = "";
	private String boardGroup = "";
	private int seq = 0;
}