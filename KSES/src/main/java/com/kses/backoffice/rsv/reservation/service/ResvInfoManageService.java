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
	public List<Map<String, Object>> selectResInfoManageListByPagination(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 예약정보 상세 조회
	 * 
	 * @param resvSeq
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectResInfoDetail(String resvSeq) throws Exception;
	
	
	String selectFindPassword(Map<String, Object> paramMap ) throws Exception;
	
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
	 * SPDM 회원 예약 현시간 예약한 정보 조회
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectInUserResvInfo(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM QR코드 생성용 예약정보 조회
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectResvQrInfo(String resvSeq) throws Exception;
	
	/**
	 * SPDM 회원 현재 예약일자 예약정보 유무 확인
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int checkUserResvInfo(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 예약정보 입석 좌석 정보 조회
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
	public Map<String, Object> selectGuestMyResvInfo(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 예약 정보 취소
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int resvInfoCancel(Map<String, Object> params) throws Exception;
	
	/*
	 *  입금 또는 환불
	 * 
	 */
	public int resPriceChange(ResvInfo vo)throws Exception;
	
	/**
	 * SPDM 예약 정보 취소
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public String resvValidCheck(Map<String, Object> params) throws Exception;
}