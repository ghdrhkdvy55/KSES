package com.kses.backoffice.bld.center.service.impl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bld.center.mapper.CenterHolyInfoManageMapper;
import com.kses.backoffice.bld.center.service.CenterHolyInfoManageService;
import com.kses.backoffice.bld.center.vo.CenterHolyInfo;
import com.kses.backoffice.util.mapper.UniSelectInfoManageMapper;

@Service
public class CenterHolyInfoManageServiceImpl extends EgovAbstractServiceImpl implements CenterHolyInfoManageService {

	@Autowired
	CenterHolyInfoManageMapper centerHolyMapper;
	
	@Autowired
	private UniSelectInfoManageMapper uniMapper;
	
	@Override
	public List<Map<String, Object>> selectCenterHolyInfoList(String centerCd) throws Exception {
		// TODO Auto-generated method stub
		return centerHolyMapper.selectCenterHolyInfoList(centerCd);
	}

	@Override
	public int updateCenterHolyInfo(CenterHolyInfo vo) throws Exception {
		// TODO Auto-generated method stub
		int ret = 0;
		
		if (vo.getMode().equals("Ins")){
			ret = (uniMapper.selectIdDoubleCheck("CENTER_HOLY_SEQ", "TSEB_CENTERHOLY_INFO_I", "CENTER_HOLY_SEQ = ["+vo.getCenterHolySeq() +"[ AND HOLY_DT = [" + vo.getHolyDt() + "[") > 0) 
					? -1 :  centerHolyMapper.insertCenterHolyInfo(vo);
		} else {
			ret = centerHolyMapper.updateCenterHolyInfo(vo);
		}
		return ret;
	}

	@Override
	public int copyCenterHolyInfo(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return centerHolyMapper.copyCenterHolyInfo(params);
	}
}