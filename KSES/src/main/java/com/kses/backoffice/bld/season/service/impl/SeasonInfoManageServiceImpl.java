package com.kses.backoffice.bld.season.service.impl;

import com.kses.backoffice.bld.season.mapper.SeasonInfoManageMapper;
import com.kses.backoffice.bld.season.service.SeasonInfoManageService;
import com.kses.backoffice.bld.season.vo.SeasonInfo;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class SeasonInfoManageServiceImpl extends EgovAbstractServiceImpl implements SeasonInfoManageService{
	private static final Logger LOGGER = LoggerFactory.getLogger(SeasonInfoManageServiceImpl.class);
	
	@Autowired
	private SeasonInfoManageMapper seasonInfoManageMapper;
	
	@Override
	public List<Map<String, Object>> selectSeasonInfoList(Map<String, Object> params) {
		return seasonInfoManageMapper.selectSeasonInfoList(params);
	}

	@Override
	public Map<String, Object> selectSeasonInfoDetail(String seasonCd) {
		return seasonInfoManageMapper.selectSeasonInfoDetail(seasonCd);
	}

	@Override
	public int insertSeasonInfo(SeasonInfo seasonInfo) {
		return seasonInfoManageMapper.insertSeasonInfo(seasonInfo);
	}

	@Override
	public int updateSeasonInfo(SeasonInfo seasonInfo) {
		return seasonInfoManageMapper.updateSeasonInfo(seasonInfo);
	}

	@Override
	public int deleteSeasonInfo(String seasonCd) {
		return seasonInfoManageMapper.deleteSeasonInfo(seasonCd);
	}

	@Override
	public int selectSeasonCenterInclude(SeasonInfo seasonInfo) {
		return seasonInfoManageMapper.selectSeasonCenterInclude(seasonInfo);
	}
	
	@Override
	public String selectCenterSeasonCd(Map<String, Object> params) {
		return seasonInfoManageMapper.selectCenterSeasonCd(params);
	}

	@Override
	public List<Map<String, Object>> selectSeasonCenterInfoList(String seasonCd) {
		return seasonInfoManageMapper.selectSeasonCenterInfoList(seasonCd);
	}

}