package com.kses.backoffice.mng.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.mng.admin.vo.AdminInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface AdminInfoManageMapper {

	public List<Map<String, Object>>selectAdminUserManageListByPagination(@Param("params") Map<String, Object> params);
	
	public Map<String, Object> selectAdminUserManageDetail(String empNo);
	
	public int insertAdminUserManage(AdminInfo vo);
	
	public int updateAdminUserManage(AdminInfo vo);
	
	public int updateAdminUserLockManage(String adminId);
	
	public int deleteAdminUserManage(String adminId);
	
}
