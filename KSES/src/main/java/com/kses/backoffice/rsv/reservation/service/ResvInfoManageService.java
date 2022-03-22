package com.kses.backoffice.rsv.reservation.service;

import java.util.List;
import java.util.Map;

import org.springframework.ui.ModelMap;

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
	
	/**
	 * SPDM 장기예약 지점 휴일을 제외한 예약가능일자 조회
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<String> selectResvDateList(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM 예약번호 시퀀스 조회
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public String selectResvSeqNext() throws Exception;
	
	/**
	 * SPDM 지점 예약일자 조회
	 * 
	 * @param centerCd
	 * @return
	 * @throws Exception
	 */
	public String selectCenterResvDate(String centerCd) throws Exception;
	
	/**
	 * SPDM 지점 예약 가능일 목록 조회
	 * 
	 * @param centerCd
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCenterResvDateList(String centerCd) throws Exception;
	
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
	 * SPDM 회원 예약 정보 조회
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectUserResvInfoFront(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 회원 예약 현시간 예약한 정보 조회
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectInUserResvInfo(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM 회원 로그인시 자동결제 적용 예약정보 조회
	 * 
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public String selectAutoPaymentResvInfo(String userId) throws Exception;
	
	/**
	 * SPDM 현금영수증 발행정보 조회
	 * 
	 * @param resvSeq
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectResvBillInfo(String resvSeq) throws Exception;
	
	/**
	 * SPDM 회원 현재 예약일자 예약정보 유무 확인
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int selectResvDuplicate(Map<String, Object> params) throws Exception;
	
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
	 * SPDM 예약 좌석정보 변경
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int updateResvSeatInfo(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 좌석변경 프로세스
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public ModelMap resvSeatChange(Map<String, Object> params) throws Exception;
	
	/**
	 * SPDM 좌석변경으로 인한 신규 예약정보 생성
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public ModelMap updateResvInfoCopy(Map<String, Object> params) throws Exception;
	
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
	 * @param resvSeq
	 * @param cardPw
	 * @param isPassword
	 * @return
	 * @throws Exception
	 */
	public ModelMap resvInfoAdminCancel(String resvSeq, String cardPw, boolean isPassword) throws Exception;
	
	/**
	 * SPDM 최초 출입시 예약 상태값 변경 
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateResvState(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM 예약 현금영수증 발행 관련 정보 갱신
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateResvRcptInfo(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM 예약상태 이용완료 처리 
	 * 
	 * @return
	 * @throws Exception
	 */
	public int updateResvUseComplete() throws Exception;
	
	/**
	 * SPDM 예약정보 QR발급 횟수 변경
	 * 
	 * @param resvSeq
	 * @return
	 * @throws Exception
	 */
	public int updateResvQrCount(String resvSeq) throws Exception;	
	
	/**
	 * SPDM QR코드 중복체크
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectQrDuplicate(Map<String, Object> params) throws Exception;	
	
	/**
	 * SPDM 입급 또는 환불시 예약정보 상태 변경
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateResvPriceInfo(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM 현금영수증 발행시 예약정보 상태 변경
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int resvBillChange(ResvInfo vo) throws Exception;
	
	/**
	 * SPDM 예약정보 유효성 검사
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public void resvValidCheck(Map<String, Object> params) throws Exception;
}