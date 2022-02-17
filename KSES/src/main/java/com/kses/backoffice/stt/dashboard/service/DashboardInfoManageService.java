package com.kses.backoffice.stt.dashboard.service;

import java.util.List;
import java.util.Map;

public interface DashboardInfoManageService {

    int selectEntryMaximumNumber() throws Exception;

    int selectTodayResvNumber(List<String> resvStates) throws Exception;

    List<Map<String, Object>> selectDashboardList() throws Exception;
    
    List<Map<String, Object>> selectCenterUsageStatList(Map<String, Object> parmas) throws Exception;

    int insertCenterUsageStat() throws Exception;
}