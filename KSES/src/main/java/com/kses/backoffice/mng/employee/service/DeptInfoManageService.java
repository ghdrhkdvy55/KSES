package com.kses.backoffice.mng.employee.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.mng.employee.vo.DeptInfo;

/**
 * SPDM 공통 부서 정보 서비스
 * 
 * @author JangDaeHan
 *
 */
public interface DeptInfoManageService {
	
	/**
	 * SPDM 공통 부서 목록 조회
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectDeptInfoList(@Param("params") Map<String, Object> params) throws Exception;
	
	
	List<Map<String, Object>> selectOrgInfoComboList() throws Exception;
	/**
	 * SPDM 공통 부서 콤보박스 목록 조회
	 * 
	 * @return
	 * @throws Exception
	 */
	List<DeptInfo> selectDeptInfoComboList() throws Exception;
	
	/**
	 * SPDM 공통 부서 정보 상세 조회
	 * 
	 * @param deptCode
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectDeptDetailInfo(String deptCode) throws Exception;
	
	/**
	 * SPDM 공통 부서 정보 수정
	 * 
	 * @param deptInfo
	 * @return
	 * @throws Exception
	 */
	int updateDeptInfo(DeptInfo deptInfo) throws Exception;
	
}