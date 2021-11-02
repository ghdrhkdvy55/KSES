package com.kses.backoffice.bld.floor.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bld.floor.mapper.FloorPartInfoManageMapper;
import com.kses.backoffice.bld.floor.service.FloorPartInfoManageService;
import com.kses.backoffice.bld.floor.vo.FloorPartInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class FloorPartInfoManageServiceImpl extends EgovAbstractServiceImpl  implements FloorPartInfoManageService{

	
	
	@Autowired
	private FloorPartInfoManageMapper partMapper;

	@Override
	public List<Map<String, Object>> selectFloorPartInfoList(Map<String, Object> params)
			throws Exception {
		// TODO Auto-generated method stub
		return partMapper.selectFloorPartInfoList(params);
	}

	@Override
	public List<Map<String, Object>> selectFloorPartInfoManageCombo(String floorCd) throws Exception {
		// TODO Auto-generated method stub
		return partMapper.selectFloorPartInfoManageCombo(floorCd);
	}

	@Override
	public Map<String, Object> selectFloorPartInfoDetail(String partSeq) throws Exception {
		// TODO Auto-generated method stub
		return partMapper.selectFloorPartInfoDetail(partSeq);
	}

	@Override
	public int updateFloorPartInfoManage(FloorPartInfo vo) throws Exception {
		// TODO Auto-generated method stub
		return vo.getMode().equals("Ins") ? partMapper.insertFloorPartInfo(vo) : partMapper.updateFloorPartInfo(vo);
	}	
}