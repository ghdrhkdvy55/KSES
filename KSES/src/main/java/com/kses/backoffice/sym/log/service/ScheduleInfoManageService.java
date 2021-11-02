package com.kses.backoffice.sym.log.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.sym.log.vo.ScheduleInfo;

public interface ScheduleInfoManageService {

    List<Map<String, Object>> selectScheduleListInfo(@Param("params") Map<String, Object> params)throws Exception;
	
	//int insertScheduleManage(ScheduleInfo vo)throws Exception;
	
	int insertScheduleManage(String schName, String schResult, String schMessage)throws Exception;
}
