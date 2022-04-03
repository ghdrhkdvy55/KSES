package com.kses.backoffice.bas.holy.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bas.holy.mapper.HolyInfoManageMapper;
import com.kses.backoffice.bas.holy.service.HolyInfoService;
import com.kses.backoffice.bas.holy.vo.HolyInfo;
import com.kses.backoffice.util.mapper.UniSelectInfoManageMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class HolyInfoServiceImpl extends EgovAbstractServiceImpl implements HolyInfoService{

	private static final Logger LOGGER = LoggerFactory.getLogger(HolyInfoServiceImpl.class);
			
	@Autowired
	private HolyInfoManageMapper holyMapper;
	
	@Autowired
	private UniSelectInfoManageMapper uniMapper;

	@Override
	public List<Map<String, Object>> selectHolyInfoList(Map<String, Object> params) throws Exception {
		return holyMapper.selectHolyInfoList(params);
	}

	@Override
	public Map<String, Object> selectHolyInfoDetail(String holySeq) throws Exception {
		return holyMapper.selectHolyInfoDetail(holySeq);
	}
	
	@Override
	public int updateHolyInfo(HolyInfo vo) throws Exception {
		int ret;
		Map<String, Object> doubleCheckHolySeq = holyMapper.selectHolyInfoDetail(vo.getHolySeq());
		if (vo.getMode().equals("Ins")) {
			ret = (uniMapper.selectIdDoubleCheck("HOLY_DT", "TSEC_HOLY_INFO_M", "HOLY_DT = ["+ vo.getHolyDt() + "[" ) > 0) ? -1 : holyMapper.insertHolyInfo(vo);
		} else {
			if (doubleCheckHolySeq.get("holy_dt").equals(vo.getHolyDt()) && doubleCheckHolySeq.get("holy_seq").toString().equals(vo.getHolySeq().toString())) {
				ret = holyMapper.updateHolyInfo(vo);
			} else {
				ret = (uniMapper.selectIdDoubleCheck("HOLY_DT", "TSEC_HOLY_INFO_M", "HOLY_DT = ["+ vo.getHolyDt() + "[" ) > 0) ? -1 : holyMapper.updateHolyInfo(vo);
			}			
		}
		return ret;
	}
	
	@Override
	public int deleteHolyInfo(List<String> holyList) throws Exception {
		return holyMapper.deleteHolyInfo(holyList);
	}
	
	@Override
	public int holyInfoCenterApply(List<HolyInfo> holyInfoList) throws Exception {
		return holyMapper.holyInfoCenterApply(holyInfoList);
	}

	@Override
	public boolean insertExcelHoly(List<HolyInfo> holyInfoList) throws Exception {
		boolean result = false;
		try {
			holyMapper.insertExcelHoly(holyInfoList);
			result = true;
		}catch( Exception e) {
			LOGGER.error("insertExcelHoly error:" + e.toString());
		}
		return result;
	}
}