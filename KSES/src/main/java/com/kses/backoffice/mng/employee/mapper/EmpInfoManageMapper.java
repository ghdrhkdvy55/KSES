package com.kses.backoffice.mng.employee.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.mng.employee.vo.EmpInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EmpInfoManageMapper {
	
	public List<Map<String, Object>> selectEmpInfoList(@Param("params") Map<String, Object> params);
	
	public Map<String, Object> selectEmpInfoDetail(String empId);
	
	public int insertEmpInfo(EmpInfo params);
	
	public int updateEmpInfo(EmpInfo params);
	
	public int deleteEmpInfo(@Param("empList") List<String> empList);
	
	public int mergeEmpInfo();	
}
