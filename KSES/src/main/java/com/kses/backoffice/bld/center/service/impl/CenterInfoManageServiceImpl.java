package com.kses.backoffice.bld.center.service.impl;

import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bld.center.mapper.CentertInfoManageMapper;
import com.kses.backoffice.bld.center.service.CenterInfoManageService;
import com.kses.backoffice.bld.center.vo.CenterInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class CenterInfoManageServiceImpl extends EgovAbstractServiceImpl implements CenterInfoManageService{
    //private static final Logger LOGGER = LoggerFactory.getLogger(CenterInfoManagerServiceImpl.class);
	
	@Autowired
    private CentertInfoManageMapper centerMapper;

	@Override
	public List<Map<String, Object>> selectCenterInfoList(Map<String, Object> SearchVO) throws Exception {
		return centerMapper.selectCenterInfoList(SearchVO);
	}

	@Override
	public List<Map<String, Object>> selectCenterInfoComboList()throws Exception {
		return centerMapper.selectCenterInfoComboList();
	}

	@Override
	public Map<String, Object> selectCenterInfoDetail(String centerCd)
			throws Exception {
		return centerMapper.selectCenterInfoDetail(centerCd);
	}
	
	@Override
	public List<Map<String, Object>> selectResvCenterList(String resvDate)throws Exception {
		return centerMapper.selectResvCenterList(resvDate);
	}
	
	@Override
	@Transactional
	public int updateCenterInfoManage(CenterInfo vo) throws Exception {
		int ret = 0;
		if (vo.getMode().equals(Globals.SAVE_MODE_INSERT)){
			List<?> floorList =  vo.getFloorInfo().equals("") ? null : SmartUtil.dotToList(vo.getFloorInfo());
			vo.setFloorList(floorList);
			ret =  centerMapper.insertCenterInfoManage(vo);
		}else{
			ret =  centerMapper.updateCenterInfoManage(vo);
		}
		return ret;
	}

	@Override
	public int updateCenterFloorInfoManage(String floorInfo, String centerCode) throws Exception {
		return centerMapper.updateCenterFloorInfoManage(floorInfo, centerCode);
	}
}