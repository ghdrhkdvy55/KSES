package com.kses.backoffice.bld.floor.mapper;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.floor.vo.FloorPartInfo;;

@Mapper
public interface FloorPartInfoManageMapper {

    public List<Map<String, Object>> selectFloorPartInfoList(@Param("params") Map<String, Object> params);
	
	public List<Map<String, Object>> selectFloorPartInfoManageCombo (@Param("floorCd") String floorCd);
	
	public Map<String, Object> selectFloorPartInfoDetail(String partSeq);
		
	public int insertFloorPartInfo(FloorPartInfo vo);
	
	public int updateFloorPartInfo(FloorPartInfo vo);
}