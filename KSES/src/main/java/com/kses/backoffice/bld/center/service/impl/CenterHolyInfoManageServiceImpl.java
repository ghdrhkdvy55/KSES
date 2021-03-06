package com.kses.backoffice.bld.center.service.impl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bas.holy.service.impl.HolyInfoServiceImpl;
import com.kses.backoffice.bld.center.mapper.CenterHolyInfoManageMapper;
import com.kses.backoffice.bld.center.service.CenterHolyInfoManageService;
import com.kses.backoffice.bld.center.vo.CenterHolyInfo;
import com.kses.backoffice.util.mapper.UniSelectInfoManageMapper;

@Service
public class CenterHolyInfoManageServiceImpl extends EgovAbstractServiceImpl implements CenterHolyInfoManageService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(HolyInfoServiceImpl.class);
		
	@Autowired
	CenterHolyInfoManageMapper centerHolyMapper;
	
	@Autowired
	private UniSelectInfoManageMapper uniMapper;
	
	@Override
	public List<Map<String, Object>> selectCenterHolyInfoList(Map<String, Object> params) throws Exception {
		return centerHolyMapper.selectCenterHolyInfoList(params);
	}

	@Override
	public int updateCenterHolyInfo(CenterHolyInfo vo) throws Exception {
		int ret;
		Map<String, Object> centerUpdateSelect = centerHolyMapper.centerUpdateSelect(vo.getCenterHolySeq());
		if (vo.getMode().equals("Ins")) {
			ret = (uniMapper.selectIdDoubleCheck("HOLY_DT", "TSEB_CENTERHOLY_INFO_I", "HOLY_DT = ["+ vo.getHolyDt() + "[ AND CENTER_CD = ["+ vo.getCenterCd() + "[" ) > 0) ? -1 : centerHolyMapper.insertCenterHolyInfo(vo);
		} else {
			if (centerUpdateSelect.get("holy_dt").equals(vo.getHolyDt()) && centerUpdateSelect.get("center_holy_seq").toString().equals(vo.getCenterHolySeq().toString())) {
				ret = centerHolyMapper.updateCenterHolyInfo(vo);
			} else {
				ret = (uniMapper.selectIdDoubleCheck("HOLY_DT", "TSEB_CENTERHOLY_INFO_I", "HOLY_DT = ["+ vo.getHolyDt() + "[ AND CENTER_CD = ["+ vo.getCenterCd() + "[" ) > 0) ? -1 : centerHolyMapper.updateCenterHolyInfo(vo);
			}			
		}
		return ret;
	}

	@Override
	public int copyCenterHolyInfo(Map<String, Object> params) throws Exception {
		return centerHolyMapper.copyCenterHolyInfo(params);
	}
	
	@Override
	public Map<String, Object> centerUpdateSelect(String centerHolySeq) throws Exception {
		return centerHolyMapper.centerUpdateSelect(centerHolySeq);
	}
	
	@Override
	public int deleteCenterHolyInfo(int centerHolySeq) throws Exception {
		return centerHolyMapper.deleteCenterHolyInfo(centerHolySeq);
	}
	
	@Override
	public boolean insertExcelCenterHoly(List<CenterHolyInfo> centerHolyInfoList) throws Exception {
		boolean result = false;
		try {
			centerHolyMapper.insertExcelCenterHoly(centerHolyInfoList);
			result = true;
		}catch( Exception e) {
			LOGGER.error("insertExcelCenterHoly error:" + e.toString());
		}
		return result;
	}
}