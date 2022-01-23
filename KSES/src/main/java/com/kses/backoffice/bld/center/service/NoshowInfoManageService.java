package com.kses.backoffice.bld.center.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bld.center.vo.NoshowInfo;
import com.kses.backoffice.rsv.reservation.vo.NoShowHisInfo;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;

public interface NoshowInfoManageService {

	/**
	 * SPDM 지점 자동취소시간(노쇼) 정보 목록 조회
	 * 
	 * @param centerCd
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectNoshowInfoList(String centerCd) throws Exception;
	
	/**
	 * SPDM 1차 노쇼 예약정보 목록 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectNoshowResvInfo_R1() throws Exception;
	
	/**
	 * SPDM 2차 노쇼 예약정보 목록 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectNoshowResvInfo_R2() throws Exception;
	
	/**
	 * SPDM 예약정보 자동취소 정보 입력
	 * 
	 * @return
	 * @throws Exception
	 */
	public int insertNoshowResvInfo(NoShowHisInfo noshowHisInfo) throws Exception;
	
	/**
	 * SPDM 예약정보 자동취소 정보 갱신
	 * 
	 * @return
	 * @throws Exception
	 */
	public int updateNoshowResvInfoTranCancel(ResvInfo resvInfo) throws Exception;
	
	/**
	 * SPDM 지점 자동취소시간(노쇼) 정보 갱신
	 * 
	 * @param list
	 * @return
	 * @throws Exception
	 */
	public int updateNoshowInfo(List<NoshowInfo> noshowInfoList) throws Exception;
	
	/**
	 * SPDM 지점 자동취소시간(노쇼) 정보 복사
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int copyNoshowInfo(Map<String, Object> params) throws Exception;
	
	/**
	 * 트랜잭션 테스트진행중 
	 * 
	 * @param resvSeq
	 * @param noshowCd
	 * @return
	 * @throws Exception
	 */
	public boolean updateNoshowResvInfoTran(Map<String, Object> params) throws Exception;
}
