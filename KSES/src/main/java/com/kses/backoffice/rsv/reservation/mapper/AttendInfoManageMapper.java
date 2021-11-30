package com.kses.backoffice.rsv.reservation.mapper;


import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.rsv.reservation.vo.AttendInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface AttendInfoManageMapper {

    public List<Map<String, Object>> selectAttendInfoListPage(@Param("params") Map<String, Object> params);
    
    public Map<String, Object> selectAttendInfoDetail(AttendInfo vo);
    
    public int insertAttendInfo(AttendInfo vo);
	
    public void deleteAttendInfo(@Param("delCds") List<String> delCds);
}
