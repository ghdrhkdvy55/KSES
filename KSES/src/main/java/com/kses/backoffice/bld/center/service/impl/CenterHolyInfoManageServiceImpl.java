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
		int ret = 0;
		
		if (vo.getMode().equals("Edt")){
			ret = centerHolyMapper.updateCenterHolyInfo(vo);
		} else {
			ret = (uniMapper.selectIdDoubleCheck("HOLY_DT", "TSEB_CENTERHOLY_INFO_I", "HOLY_DT = ["+ vo.getHolyDt() + "[ AND CENTER_CD = ["+ vo.getCenterCd() + "[" ) > 0) ? -1 : centerHolyMapper.insertCenterHolyInfo(vo);
		}		
		return ret;
	}

	@Override
	public int copyCenterHolyInfo(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return centerHolyMapper.copyCenterHolyInfo(params);
	}
	
	@Override
	public Map<String, Object> centerUpdateSelect(String centerHolySeq) throws Exception {
		// TODO Auto-generated method stub
		return centerHolyMapper.centerUpdateSelect(centerHolySeq);
	}
	
	@Override
	public int deleteCenterHolyInfo(int centerHolySeq) throws Exception {
		// TODO Auto-generated method stub
		return centerHolyMapper.deleteCenterHolyInfo(centerHolySeq);
	}

}