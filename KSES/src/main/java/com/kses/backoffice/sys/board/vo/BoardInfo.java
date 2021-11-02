package com.kses.backoffice.sys.board.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

//게시판 정보 
@Getter
@Setter
public class BoardInfo {

	 // 시퀀스 
	 @JsonProperty("board_seq")
	 private Double boardSeq;
	
	 // 게시판 코드 
	 @JsonProperty("board_code")
	 private String boardCode;
	
	 // 게층형 게시판 참조글 
	 @JsonProperty("board_refno")
	 private Double boardRefno;
	
	 // 게시판 참조 순서 
	 @JsonProperty("board_clevel")
	 private Double boardClevel;
	
	 // 공지 시작일 
	 @JsonProperty("board_notice_startday")
	 private String boardNoticeStartday;
	
	 // 공지 종료일 
	 @JsonProperty("board_notice_endday")
	 private String boardNoticeEndday;
	
	 // 공지 팝업 구분 
	 @JsonProperty("board_popup")
	 private String boardPopup;
	
	 // 제목 
	 @JsonProperty("board_title")
	 private String boardTitle;
	
	 // 공지 시퀀스 
	 @JsonProperty("board_top_seq")
	 private Double boardTopSeq;
	
	 // 방문자 수 
	 @JsonProperty("board_visited")
	 private Double boardVisited;
	
	 // 사용유무 
	 @JsonProperty("board_useyn")
	 private String boardUseyn;
	
	 // 최초 등록자 
	 @JsonProperty("frst_register_id")
	 private String frstRegisterId;
	
	 // 최초 등록일자 
	 @JsonProperty("frst_register_pnttm")
	 private String frstRegisterPnttm;
	
	 // 최종 수정자 
	 @JsonProperty("last_updusr_id")
	 private String lastUpdusrId;
	
	 // 최종 수정자 아이디 
	 @JsonProperty("last_updusr_pnttm")
	 private String lastUpdusrPnttm;
	
	 // 내용 
	 @JsonProperty("board_content")
	 private String boardContent;
	 
	 // 입력 구분
	 @JsonProperty("mode")
	 private String mode;
}