package com.kses.backoffice.sys.board.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import com.kses.backoffice.sys.board.vo.BoardSetInfo;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface BoardSetInfoManageMapper {

    public List<Map<String, Object>> selectBoardSettingInfoList(@Param("params") Map<String, Object> params);
    
    public Map<String, Object> selectBoardSettingInfoDetail(String boardCd);
    
    public void insertBoardInfo(BoardSetInfo vo);
	
    public void updateBoardInfo(BoardSetInfo vo);
    
    public void deleteBoardSettingInfo(@Param("delCds") List<String> delCds);
}
