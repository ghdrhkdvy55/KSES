package com.kses.backoffice.mng.admin.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.mng.admin.mapper.AdminInfoManageMapper;
import com.kses.backoffice.mng.admin.service.AdminInfoService;
import com.kses.backoffice.mng.admin.vo.AdminInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class AdminInfoServiceImpl extends EgovAbstractServiceImpl implements AdminInfoService{

	
	
	@Autowired
	private AdminInfoManageMapper adminMapper;
	
	@Override
	public List<Map<String, Object>> selectAdminUserManageListByPagination(Map<String, Object> params) {
		return adminMapper.selectAdminUserManageListByPagination(params);
	}

	@Override
	public Map<String, Object> selectAdminUserManageDetail(String empNo) {
		return adminMapper.selectAdminUserManageDetail(empNo);
	}

	@Override
	public int updateAdminUserManage(AdminInfo vo) {
		return vo.getMode().equals("Ins") ?  adminMapper.insertAdminUserManage(vo) :  adminMapper.updateAdminUserManage(vo);
	}

	@Override
	public int updateAdminUserLockManage(String adminId) {
		return adminMapper.updateAdminUserLockManage(adminId);
	}

	@Override
	public int deleteAdminUserManage(String adminId) {
		return adminMapper.deleteAdminUserManage(adminId);
	}

}