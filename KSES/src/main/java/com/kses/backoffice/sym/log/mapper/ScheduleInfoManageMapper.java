package com.kses.backoffice.sym.log.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.sym.log.vo.ScheduleInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface ScheduleInfoManageMapper {

    public List<Map<String, Object>> selectScheduleListInfo(@Param("params") Map<String, Object> params);
	
    public int insertScheduleManage(ScheduleInfo vo);
}
