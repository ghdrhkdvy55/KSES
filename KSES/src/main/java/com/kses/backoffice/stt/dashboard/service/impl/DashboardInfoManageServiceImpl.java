package com.kses.backoffice.stt.dashboard.service.impl;

import com.kses.backoffice.stt.dashboard.mapper.DashboardInfoManageMapper;
import com.kses.backoffice.stt.dashboard.service.DashboardInfoManageService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

@Service
public class DashboardInfoManageServiceImpl extends EgovAbstractServiceImpl implements DashboardInfoManageService {

    @Autowired
    private DashboardInfoManageMapper dashboardInfoManageMapper;

    @Override
    public int selectEntryMaximumNumber() throws Exception {
        return dashboardInfoManageMapper.selectEntryMaximumNumber();
    }

    @Override
    public int selectTodayResvNumber(List<String> resvStates) throws Exception {
        return dashboardInfoManageMapper.selectTodayResvNumber(resvStates);
    }

    @Override
    public List<Map<String, Object>> selectDashboardList() throws Exception {
        List<Map<String, Object>> dashboardList = dashboardInfoManageMapper.selectDashboardList();
        dashboardList.add(
            dashboardList.stream()
                .reduce(new HashMap<String, Object>(), (map, b) -> {
                    map.compute("center_cd", (k, v) -> "TOTAL");
                    map.compute("center_nm", (k, v) -> "합계");
                    Iterator<String> keys = b.keySet().iterator();
                    while (keys.hasNext()) {
                        String key = keys.next();
                        switch (key) {
                            case "class_4":
                            case "class_3":
                            case "class_2":
                            case "class_1":
                            case "stand":
                            case "entry_number":
                            case "maximum_number":
                                map.compute(key, (k, v) -> v == null ? b.get(k) : Integer.valueOf(v+"") + Integer.valueOf(b.get(k)+""));
                                break;
                            default:
                        }
                    }
                    return map;
                })
        );
        return dashboardList;
    }
    
    @Override
    public List<Map<String, Object>> selectCenterUsageStatList(Map<String, Object> parmas) throws Exception {
    	return dashboardInfoManageMapper.selectCenterUsageStatList(parmas);
    }

    @Override
    public Map<String, Object> selectCenterUsageStatTotal(Map<String, Object> parmas) throws Exception {
    	return dashboardInfoManageMapper.selectCenterUsageStatTotal(parmas);
    }

    @Override
    public int insertCenterUsageStat() throws Exception {
    	return dashboardInfoManageMapper.insertCenterUsageStat();
    }
}