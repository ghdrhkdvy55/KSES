package com.kses.backoffice.bas.holy.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bas.holy.vo.HolyInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface HolyInfoManageMapper {

    public List<Map<String, Object>> selectHolyInfoList(@Param("params") Map<String, Object> params);
	
    public Map<String, Object> selectHolyInfoDetail(String holySeq);
    
    public int insertHolyInfo(HolyInfo vo);
    
    public void insertExcelHoly(@Param("holyInfoList") List<HolyInfo> holyInfoList);
	
    public int updateHolyInfo(HolyInfo vo);
    
    public int deleteHolyInfo(@Param("holyList") List<String> holyList);
    
    public int holyInfoCenterApply(@Param("holyInfoList") List<HolyInfo> holyInfoList);
}
