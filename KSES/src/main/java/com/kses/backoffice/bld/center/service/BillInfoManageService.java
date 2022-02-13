package com.kses.backoffice.bld.center.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bld.center.vo.BillDayInfo;
import com.kses.backoffice.bld.center.vo.BillInfo;

public interface BillInfoManageService {

	/**
	 * SPDM 지점 현금영수증 발행 정보 목록 조회
	 * 
	 * @param centerCd
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectBillInfoList(String centerCd) throws Exception;
	
	/**
	 * SPDM 지점 현금영수증 발행 요일 정보 목록 조회
	 * 
	 * @param centerCd
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectBillDayInfoList(String centerCd) throws Exception;
	
	/**
	 * SPDM 지점 현금영수증 정보 상세 조회
	 * 
	 * @param billSeq
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectBillInfoDetail(String billSeq) throws Exception;

	/**
	 * SPDM 지점 현금영수증 발행 정보 갱신
	 * @param billInfo
	 * @return
	 * @throws Exception
	 */
	public int insertBillInfo(BillInfo billInfo) throws Exception;

	/**
	 * SPDM 지점 현금영수증 발행 정보 갱신
	 * 
	 * @param billInfo
	 * @return
	 * @throws Exception
	 */
	public int updateBillInfo(BillInfo billInfo) throws Exception;
	
	/**
	 * SPDM 지점 현금영수증 발행 요일 정보 갱신
	 * 
	 * @param billInfo
	 * @return
	 * @throws Exception
	 */
	public int updateBillDayInfo(List<BillDayInfo> billDayInfoList) throws Exception;
	
	/**
	 * SPDM 지점 현금영수증 발행 정보 삭제
	 * 
	 * @param billSeq
	 * @return
	 * @throws Exception
	 */
	public int deleteBillInfo(BillInfo billInfo) throws Exception;
}
