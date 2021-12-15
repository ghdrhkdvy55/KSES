package com.kses.backoffice.bld.season.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.season.vo.SeasonInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface SeasonInfoManageMapper {

    public List<Map<String, Object>> selectSeasonInfoList(@Param("params") Map<String, Object> params);
	
    public Map<String, Object> selectSeasonInfoDetail(String seasonCd);
    
    public List<Map<String, Object>> selectSeasonCenterInfoList(String seasonCd);
    
    public int selectSeasonCenterInclude(SeasonInfo vo);
    
    public String selectCenterSeasonCd(@Param("params") Map<String, Object> params);
    
    public int insertSeasonInfo(SeasonInfo vo);
	
    public int updateSeasonInfo(SeasonInfo vo);
    
    public int deleteSeasonInfo(@Param("seasonList") List<String> seasonList);

}