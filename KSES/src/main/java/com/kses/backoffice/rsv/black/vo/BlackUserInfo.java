package com.kses.backoffice.rsv.black.vo;

import lombok.Getter;
import lombok.Setter;

// 블랙 리스트 정보
@Getter
@Setter
public class BlackUserInfo {
    // 블랙리스트 시퀀스 
    private String blklstSeq;

    // 사용자 구분 
    private String userDvsn;
    
    // 사용자 아이디 
    private String userId;

    // 사용자 아이디 
    private String userNm;

    // 핸드폰 
    private String userPhone;
    
    // 휴대전화
    private String userClphn;

    // 블랙리스트 유형 
    private String blklstDvsn;

    // 이유 
    private String blklstReason;
    
    // 해제여부
    private String blklstCancelYn;
    
    // 최초 등록자 
    private String frstRegisterId;

    // 최초 등록일 
    private String frstRegisterPnttm;

    // 최종 수정자 
    private String lastUpdusrId;

    // 최종 수정 일자 
    private String lastUpdusrPnttm;
    
    // 등록자 ID
    private String adminId;
    
    // 입력 구분
    private String mode;
}