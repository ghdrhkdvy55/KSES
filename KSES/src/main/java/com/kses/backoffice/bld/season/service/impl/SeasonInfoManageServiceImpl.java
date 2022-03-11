package com.kses.backoffice.bld.season.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bld.season.mapper.SeasonInfoManageMapper;
import com.kses.backoffice.bld.season.service.SeasonInfoManageService;
import com.kses.backoffice.bld.season.vo.SeasonInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class SeasonInfoManageServiceImpl extends EgovAbstractServiceImpl implements SeasonInfoManageService{
	private static final Logger LOGGER = LoggerFactory.getLogger(SeasonInfoManageServiceImpl.class);
	
	@Autowired
	private SeasonInfoManageMapper sessionMapper;
	
	@Override
	public List<Map<String, Object>> selectSeasonInfoList(Map<String, Object> params) {
		return sessionMapper.selectSeasonInfoList(params);
	}

	@Override
	public Map<String, Object> selectSeasonInfoDetail(String seasonCd) {
		return sessionMapper.selectSeasonInfoDetail(seasonCd);
	}

	@Override
	public int updateSeasonInfo(SeasonInfo vo) {
		int ret = 0;
		if (sessionMapper.selectSeasonCenterInclude(vo) > 0) {
			ret = -1;
		}else {
			try {
				 ret = vo.getMode().equals(Globals.SAVE_MODE_INSERT) ?  sessionMapper.insertSeasonInfo(vo) : sessionMapper.updateSeasonInfo(vo) ;
				 ret = 1; 
			}catch(Exception e) {
				LOGGER.error("updateSeasonInfo error:" + e.toString());
				ret = 0; 
			}
		}
		return ret;
	}

	@Override
	public int deleteSeasonInfo(String seasonCd) {
		return sessionMapper.deleteSeasonInfo(seasonCd);
	}

	@Override
	public int selectSeasonCenterInclude(SeasonInfo vo) {
		return 0;
	}
	
	@Override
	public String selectCenterSeasonCd(Map<String, Object> params) {
		return sessionMapper.selectCenterSeasonCd(params);
	}

	@Override
	public List<Map<String, Object>> selectSeasonCenterInfoList(String seasonCd) {
		return sessionMapper.selectSeasonCenterInfoList(seasonCd);
	}

}