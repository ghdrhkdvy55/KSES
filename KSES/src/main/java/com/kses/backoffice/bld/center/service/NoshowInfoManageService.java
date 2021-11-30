package com.kses.backoffice.bld.center.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.center.vo.NoshowInfo;

public interface NoshowInfoManageService {

	/**
	 * SPDM 지점 자동취소시간(노쇼) 정보 목록 조회
	 * 
	 * @param centerCd
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectNoshowInfoList(@Param("centerCd") String centerCd) throws Exception;
	
	
	/**
	 * SPDM 지점 자동취소시간(노쇼) 정보 갱신
	 * 
	 * @param list
	 * @return
	 * @throws Exception
	 */
	public int updateNoshowInfo(@Param("noshowInfoList") List<NoshowInfo> noshowInfoList) throws Exception;
	
	/**
	 * SPDM 지점 자동취소시간(노쇼) 정보 복사
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int copyNoshowInfo(Map<String, Object> params) throws Exception;
}
