package com.kses.backoffice.rsv.reservation.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.rsv.reservation.vo.ResvInfo;

public interface ResvInfoManageService {
	/**
	 * SPDM 예약정보 목록 조회
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectResvInfoManageListByPagination(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 예약정보 상세 조회
	 * 
	 * @param resvSeq
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectResvInfoDetail(String resvSeq) throws Exception;
	
	
	String selectFindPassword(Map<String, Object> paramMap ) throws Exception;
	
	/**
	 * SPDM 장기예약 지점 휴일을 제외한 예약가능일자 조회
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<String> selectResvDateList(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM 회원 마지막 예약 정보 조회
	 * 
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectUserLastResvInfo(String userId) throws Exception;
	
	/**
	 * SPDM 회원 예약 정보 조회
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectUserResvInfo(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 회원 예약 정보 등록 및 수정
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateUserResvInfo(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM 장기예약 정보 등록
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateLongResvInfo(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM 회원 장기예약 정보 등록 및 수정
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateUserLongResvInfo(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM 회원 예약 현시간 예약한 정보 조회
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectInUserResvInfo(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM 회원 현재 예약일자 예약정보 유무 확인
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int resvInfoDuplicateCheck(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 예약자 아이디 조회
	 * 
	 * @param resvSeq
	 * @return
	 * @throws Exception
	 */
	public String selectResvUserId(String resvSeq) throws Exception;
	
	/**
	 * SPDM 예약정보 자유석 좌석 정보 조회
	 * 
	 * @param resvSeq
	 * @return
	 * @throws Exception
	 */
	public String selectResvEntryDvsn(String resvSeq) throws Exception;
	
	/**
	 * SPDM 회원 마이페이지 예약정보 조회
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectUserMyResvInfo(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 비회원 마이페이지 예약정보 조회
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectGuestMyResvInfo(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 예약 좌석 변경
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int resvSeatChange(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 예약 정보 취소(제거예정)
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int resvInfoCancel(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 예약 정보 취소
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> resvInfoAdminCancel(String resvSeq) throws Exception;
	
	/**
	 * SPDM 최초 출입시 예약 상태값 변경 
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int resvStateChange(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM 예약상태 이용완료 처리 
	 * 
	 * @return
	 * @throws Exception
	 */
	public int resvCompleteUse() throws Exception;
	
	/**
	 * SPDM 예약정보 QR발급 횟수 변경
	 * 
	 * @param resvSeq
	 * @return
	 * @throws Exception
	 */
	public int resvQrCountChange(String resvSeq) throws Exception;	
	
	
	/**
	 * SPDM 모바일 큐알 체크인 시 같은 큐알 체크
	 * @param resvSeq
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> resvQrDoubleCheck(@Param("params") Map<String, Object> params) throws Exception;	
	
	/*
	 *  입금 또는 환불
	 * 
	 */
	public int resPriceChange(ResvInfo vo) throws Exception;
	
	
	public int resbillChange(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM 예약정보 유효성 검사
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public String resvValidCheck(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 무인발권기 조회 시 지점 체크
	 * @param params
	 * @return
	 */
	public Map<String, Object> selectTicketMchnSnoCheck(@Param("params") Map<String, Object> params);
}