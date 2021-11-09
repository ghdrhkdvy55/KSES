package com.kses.backoffice.bld.season.service;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.kses.backoffice.bld.season.vo.SeasonInfo;

public interface SeasonInfoManageService {
	
    List<Map<String, Object>> selectSeasonInfoList(Map<String, Object> params);
	
    Map<String, Object> selectSeasonInfoDetail(String seasonCd);
    
    List<Map<String, Object>> selectSeasonCenterInfoList(String seasonCd);
    
    int selectSeasonCenterInclude(SeasonInfo vo);
    
    int updateSeasonInfo(SeasonInfo vo);
    
    int deleteSeasonInfo(String seasonCd);

}