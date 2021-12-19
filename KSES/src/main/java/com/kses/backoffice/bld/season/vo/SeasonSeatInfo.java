package com.kses.backoffice.bld.season.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

//시즌별 좌석 현황
@Getter
@Setter
public class SeasonSeatInfo {

	private String seasonSeatCd = "";
	private String seasonCd = "";
	private String centerCd = "";
	private String floorCd = "";
	private String partCd = "";
	private String seatCd = "";
	private String seasonCost = "";
	private String seasonAmCost = "";
	private String seasonPmCost = "";
	private String seatDvsn = "";
	private String seasonClass = "";
	private String useYn = "";
	private String frstRegistDtm = "";
	private String frstRegterId = "";
	private String lastUpdtDtm = "";
	private String lastUpdusrId = "";
	private String seasonSeatTop = "";
	private String seasonSeatLeft = "";
	private String seasonSeatOrder = "";
	private String seasonSeatLabel = "";
	private String seasonSeatNumber = "";
	
	private String mode = "";
	private String userId = "";
}