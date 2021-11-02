package com.kses.backoffice.mng.employee.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.mng.employee.vo.DeptInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;




@Mapper
public interface DeptInfoManageMapper {
	public List<Map<String, Object>> selectDeptInfoList(@Param("params") Map<String, Object> params);
	
	public List<Map<String, Object>> selectOrgInfoComboList();
	
	public List<DeptInfo> selectDeptInfoComboList();
	
	public Map<String, Object> selectDeptDetailInfo(String deptCd);
	
	public int insertDeptInfo(DeptInfo deptInfo);
	
	public int updateDeptInfo(DeptInfo deptInfo);
	
}
