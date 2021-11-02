package com.kses.backoffice.sys.board.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

//게시판 환경 설정 
@Getter
@Setter
public class BoardSetInfo {

	 // 게시판 아아디 
	 @JsonProperty("board_code")
	 private String boardCode;
	
	 // 게시판명 
	 @JsonProperty("board_title")
	 private String boardTitle;
	
	 // 게시판 구분 
	 @JsonProperty("board_gubun")
	 private String boardGubun;
	
	 // 사용자 구분 (관리자/지점사용자/일반사용자) 
	 @JsonProperty("board_author")
	 private String boardAuthor;
	
	 // 지점 코드 
	 @JsonProperty("board_center_code")
	 private String boardCenterCode;
	
	 // 게시물 페이지 사이즈 
	 @JsonProperty("board_size")
	 private Double boardSize;
	
	 // 공지 구분 
	 @JsonProperty("board_notice_gubun")
	 private String boardNoticeGubun;
	
	 // 사용 유무 
	 @JsonProperty("board_use_at")
	 private String boardUseAt;
	
	 // 파일 업로드 구분 
	 @JsonProperty("board_file")
	 private String boardFile;
	
	 // 댓글 사용 여부 
	 @JsonProperty("board_comment_use")
	 private String boardCommentUse;
	
	 // 최초 등록자 아이디 
	 @JsonProperty("frst_register_id")
	 private String frstRegisterId;
	
	 // 최조 등록일자 
	 @JsonProperty("frst_register_pnttm")
	 private String frstRegisterPnttm;
	
	 // 최종 수정자 아이디 
	 @JsonProperty("last_updusr_id")
	 private String lastUpdusrId;
	
	 // 최종 수정 일자 
	 @JsonProperty("last_updusr_pnttm")
	 private String lastUpdusrPnttm;
	 
	 // 입력 구분
	 @JsonProperty("mode")
	 private String mode;
}