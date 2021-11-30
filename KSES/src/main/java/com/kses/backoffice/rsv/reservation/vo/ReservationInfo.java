package com.kses.backoffice.rsv.reservation.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

//예약 정보
@Getter
@Setter
public class ReservationInfo {
	// 예약 시퀀스
	@JsonProperty("res_seq")
	private int resSeq;

	//좌석 코드
	@JsonProperty("seat_code")
	private String seatCode;

	// 시즌코드
	@JsonProperty("season_code")
	private String seasonCode;

	// 예약 시작일
	@JsonProperty("res_start_day")
	private String resStartDay;

	// 예약 종료일
	@JsonProperty("res_end_day")
	private String resEndDay;

	// 예약 구분 (오전오후종일)
	@JsonProperty("res_gubun")
	private String resGubun;

	// 예약 시작 TIME
	@JsonProperty("res_time01")
	private String resTime01;

	// 예약 종료 TIME
	@JsonProperty("res_time02")
	private String resTime02;

	// 요청일
	@JsonProperty("res_req_date")
	private String resReqDate;

	// 고객 아이디
	@JsonProperty("user_id")
	private String userId;

	// 예약 상태
	@JsonProperty("res_state")
	private String resState;

	// 취소자 ID
	@JsonProperty("res_cancel_id")
	private String resCancelId;

	// 취소 사유
	@JsonProperty("res_cancel_reason")
	private String resCancelReason;

	// 고객 취소 시간
	@JsonProperty("res_cancel_date")
	private String resCancelDate;

	// 취소 코드
	@JsonProperty("res_cancel_code")
	private String resCancelCode;

	// 환불 비용
	@JsonProperty("res_cancel_cost")
	private int resCancelCost;

	// 예약 QR
	@JsonProperty("res_qr_code")
	private String resQrCode;

	// 예약 QR_PATH
	@JsonProperty("res_qr_code_path")
	private String resQrCodePath;

	// 예약 QR_FULL_PATH
	@JsonProperty("res_qr_code_full_path")
	private String resQrCodeFullPath;

	// 최초 등록 일자
	@JsonProperty("frst_register_pnttm")
	private String frstRegisterPnttm;

	// 최초 등록 ID
	@JsonProperty("frst_register_id")
 	private String frstRegisterId;

 	// 최종 수정 일자
	@JsonProperty("last_updusr_pnttm")
	private String lastUpdusrPnttm;

	// 최종 수정 ID
	@JsonProperty("last_updusr_id")
	private String lastUpdusrId;
}