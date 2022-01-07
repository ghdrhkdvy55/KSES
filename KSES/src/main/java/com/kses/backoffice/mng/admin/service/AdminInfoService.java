package com.kses.backoffice.mng.admin.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.mng.admin.vo.AdminInfo;

public interface AdminInfoService {

    List<Map<String, Object>>selectAdminUserManageListByPagination(Map<String, Object> params);
	
	Map<String, Object> selectAdminUserManageDetail(String empNo);
	
	int insertAdminUserManage(AdminInfo adminInfo);
	
	int updateAdminUserManage(AdminInfo adminInfo);
	
	int updateAdminUserLockManage(String adminId);
	
	int deleteAdminUserManage(String adminId);
}