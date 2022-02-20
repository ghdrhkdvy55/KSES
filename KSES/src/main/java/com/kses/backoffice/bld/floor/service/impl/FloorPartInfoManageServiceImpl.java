package com.kses.backoffice.bld.floor.service.impl;

import com.kses.backoffice.bld.floor.mapper.FloorPartInfoManageMapper;
import com.kses.backoffice.bld.floor.service.FloorPartInfoManageService;
import com.kses.backoffice.bld.floor.vo.FloorPartInfo;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class FloorPartInfoManageServiceImpl extends EgovAbstractServiceImpl  implements FloorPartInfoManageService{

	
	
	@Autowired
	private FloorPartInfoManageMapper partMapper;

	@Override
	public List<Map<String, Object>> selectFloorPartInfoList(Map<String, Object> params)
			throws Exception {
		return partMapper.selectFloorPartInfoList(params);
	}

	@Override
	public List<Map<String, Object>> selectFloorPartInfoManageCombo(String floorCd) throws Exception {
		return partMapper.selectFloorPartInfoManageCombo(floorCd);
	}

	@Override
	public Map<String, Object> selectFloorPartInfoDetail(String partSeq) throws Exception {
		return partMapper.selectFloorPartInfoDetail(partSeq);
	}

	@Override
	public int insertFloorPartInfoManage(FloorPartInfo floorPartInfo) throws Exception {
		return partMapper.insertFloorPartInfo(floorPartInfo);
	}

	@Override
	public int updateFloorPartInfoManage(FloorPartInfo vo) throws Exception {
		return partMapper.updateFloorPartInfo(vo);
	}
	
	@Override
	public int updateFloorPartInfPositionInfo(List<FloorPartInfo> floorPartInfo) throws Exception {
		return partMapper.updateFloorPartInfPositionInfo(floorPartInfo);
	}
		
	@Override
	public List<Map<String, Object>> selectResvPartList(Map<String, Object> params) throws Exception {
		return partMapper.selectResvPartList(params);
	}
}