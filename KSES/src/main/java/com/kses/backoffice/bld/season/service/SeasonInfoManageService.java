package com.kses.backoffice.bld.season.service;

import com.kses.backoffice.bld.season.vo.SeasonInfo;

import java.util.List;
import java.util.Map;

public interface SeasonInfoManageService {
	
    List<Map<String, Object>> selectSeasonInfoList(Map<String, Object> params);
	
    Map<String, Object> selectSeasonInfoDetail(String seasonCd);
    
    List<Map<String, Object>> selectSeasonCenterInfoList(String seasonCd);
    
    int selectSeasonCenterInclude(SeasonInfo seasonInfo);
    
    String selectCenterSeasonCd(Map<String, Object> params);

    int insertSeasonInfo(SeasonInfo seasonInfo);

    int updateSeasonInfo(SeasonInfo seasonInfo);
    
    int deleteSeasonInfo(String seasonCd);

}