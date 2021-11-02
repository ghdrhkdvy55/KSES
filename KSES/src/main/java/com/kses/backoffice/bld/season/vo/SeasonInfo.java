package com.kses.backoffice.bld.season.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

// 시즌 정보
@Getter
@Setter
public class SeasonInfo {

    // 시즌 코드
    @JsonProperty("season_code")
    private String seasonCode;

    // 시즌시작일
    @JsonProperty("season_start_day")
    private String seasonStartDay;

    // 시즌 종작일
    @JsonProperty("season_end_day")
    private String seasonEndDay;

    // 사용유무
    @JsonProperty("season_useyn")
    private String seasonUseyn;

    // 시즌명
    @JsonProperty("season_nm")
    private String seasonNm;

    // 상세 설명
    @JsonProperty("season_dc")
    private String seasonDc;

    // 최초 등록 일자
    @JsonProperty("frst_register_pnttm")
    private String frstRegisterPnttm;

    // 최초 등록자 아이디
    @JsonProperty("frst_register_id")
    private String frstRegisterId;

    // 최초 수정 일자
    @JsonProperty("last_updusr_pnttm")
    private String lastUpdusrPnttm;

    // 최종 등록자 아이디
    @JsonProperty("last_updusr_id")
    private String lastUpdusrId;
}