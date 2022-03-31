package com.kses.backoffice.rsv.longcustomers.service;

import java.util.List;
import java.util.Map;


public interface LongcustomersInfoService {

	/**
	 * 장기예약 목록 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectLongcustomerList (Map<String, Object> searchVO) throws Exception;
	
	/**
	 * 장기예매 하위 예약 목록 조회
	 * @param longResvSeq
	 * @return
	 * @throws Exception
	 */
	List<?> selectLongcustomerResvList(String longResvSeq) throws Exception;
}