package com.kses.backoffice.rsv.reservation.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.rsv.reservation.vo.AttendInfo;

public interface AttendInfoManageService {

    List<Map<String, Object>> selectAttendInfoListPage(Map<String, Object> params);
    
    Map<String, Object> selectAttendInfoDetail(AttendInfo vo);
    
    AttendInfo insertAttendInfo(AttendInfo vo);
    
    boolean deleteAttendInfo(String delCds);
}
