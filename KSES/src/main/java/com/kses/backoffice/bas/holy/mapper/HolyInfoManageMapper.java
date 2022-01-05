package com.kses.backoffice.bas.holy.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bas.holy.vo.HolyInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface HolyInfoManageMapper {

    List<Map<String, Object>> selectHolyInfoList(@Param("params") Map<String, Object> params);
	
    Map<String, Object> selectHolyInfoDetail(String holySeq);
    
    int insertHolyInfo(HolyInfo vo);
    
    void insertExcelHoly(@Param("holyInfoList") List<HolyInfo> holyInfoList);
	
    int updateHolyInfo(HolyInfo vo);
    
    int deleteHolyInfo(@Param("holyList") List<String> holyList);
    
    int holyInfoCenterApply(@Param("holyInfoList") List<HolyInfo> holyInfoList);
    
    List<Map<String, Object>> selectHolyCenterList(@Param("params") Map<String, Object> params);
}
