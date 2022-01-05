package com.kses.backoffice.mng.employee.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.mng.employee.mapper.DeptInfoManageMapper;
import com.kses.backoffice.mng.employee.service.DeptInfoManageService;
import com.kses.backoffice.mng.employee.vo.DeptInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class DeptInfoManageServiceImpl extends EgovAbstractServiceImpl implements DeptInfoManageService {

	@Autowired 
	private DeptInfoManageMapper deptMapper;

	@Override
	public List<Map<String, Object>> selectDeptInfoList(@Param("params") Map<String, Object> params) throws Exception {
		return deptMapper.selectDeptInfoList(params);
	}
	
	@Override
	public List<DeptInfo> selectDeptInfoComboList() throws Exception {
		return deptMapper.selectDeptInfoComboList();
	}
	
	@Override
	public Map<String, Object> selectDeptDetailInfo(String deptCode) throws Exception {
		return deptMapper.selectDeptDetailInfo(deptCode);
	}

	@Override
	public int updateDeptInfo(DeptInfo deptInfo) throws Exception {
		return deptInfo.getMode().equals("Ins") ? deptMapper.insertDeptInfo(deptInfo) : deptMapper.updateDeptInfo(deptInfo);
	}

	@Override
	public List<Map<String, Object>> selectOrgInfoComboList() throws Exception {
		return deptMapper.selectOrgInfoComboList();
	}

}