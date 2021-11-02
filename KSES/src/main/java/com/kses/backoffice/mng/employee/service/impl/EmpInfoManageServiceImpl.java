package com.kses.backoffice.mng.employee.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.kses.backoffice.mng.employee.mapper.EmpInfoManageMapper;
import com.kses.backoffice.mng.employee.service.EmpInfoManageService;
import com.kses.backoffice.mng.employee.vo.EmpInfo;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;



@Service
public class EmpInfoManageServiceImpl extends EgovAbstractServiceImpl implements EmpInfoManageService {

	private static final Logger LOGGER = LoggerFactory.getLogger(EmpInfoManageServiceImpl.class);
	 
	@Autowired
	private EmpInfoManageMapper empMapper;
	
	
	@Override
	public List<Map<String, Object>> selectEmpInfoList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return empMapper.selectEmpInfoList(params);
	}

	@Override
	public Map<String, Object> selectEmpInfoDetail(String empId) {
		// TODO Auto-generated method stub
		return empMapper.selectEmpInfoDetail(empId);
	}



	@Override
	public int updateEmpInfo(EmpInfo params) {
		// TODO Auto-generated method stub
		return  params.getMode().equals("Ins") ? empMapper.insertEmpInfo(params) : empMapper.updateEmpInfo(params);
	}

	@Override
	public int deleteEmpInfo(String empId) {
		// TODO Auto-generated method stub
		return empMapper.deleteEmpInfo(empId);
	}

	@Override
	public int mergeEmpInfo(List<EmpInfo> empInfoList) {
		// TODO Auto-generated method stub
		return empMapper.mergeEmpInfo(empInfoList);
	}
}