package com.kses.backoffice.stt.dashboard.mapper;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface DashboardInfoManageMapper {

    int selectEntryMaximumNumber();

    int selectTodayResvNumber(@Param("resvStates") List<String> resvStates);

    List<Map<String, Object>> selectDashboardList();
    
    List<Map<String, Object>> selectCenterUsageStatList(@Param("params") Map<String, Object> parmas);
    
    Map<String, Object> selectCenterUsageStatTotal(@Param("params") Map<String, Object> parmas);

    int insertCenterUsageStat();
    
    int insertCenterResvPayStat();
}
