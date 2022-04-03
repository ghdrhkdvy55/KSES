package com.kses.backoffice.mng.employee.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.mng.employee.vo.EmpInfo;

/**
 * SPDM 직원(사용자) 정보 서비스
 * 
 * @author JangDaeHan
 *
 */
public interface EmpInfoManageService {
	
	/**
	 * SPDM 직원(사용자) 목록 조회
	 * 
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> selectEmpInfoList(@Param("params") Map<String, Object> params);
	
	/**
	 * SPDM 직원(사용자) 정보 상세 조회
	 * 
	 * @param empId
	 * @return
	 */
	public Map<String, Object> selectEmpInfoDetail(String empId);
	
	/**
	 * SPDM 직원(사용자) 정보 수정
	 * 
	 * @param empId
	 * @return
	 */
	public int updateEmpInfo(EmpInfo params);
	
	/**
	 * SPDM 직원(사용자) 정보 삭제
	 * 
	 * @param empId
	 * @return
	 */
	public int deleteEmpInfo(List<String> empList) throws Exception;
	
	/**
	 * SPDM 직원(사용자) 목록 갱신
	 * 
	 * @return
	 */
	public int mergeEmpInfo();	
}