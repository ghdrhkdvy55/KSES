package com.kses.backoffice.rsv.entrance.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.rsv.entrance.mapper.EntranceInfoManageMapper;
import com.kses.backoffice.rsv.entrance.service.EntranceInfoManageService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class EntranceInfoManageServiceImpl extends EgovAbstractServiceImpl implements EntranceInfoManageService {

	@Autowired
	private EntranceInfoManageMapper EntranceMapper;
	
	@Override
	public List<?> selectEnterRegistList(String resvSeq) throws Exception {
		return EntranceMapper.selectEnterRegistList(resvSeq);
	}
	
	@Override
	public List<Map<String, Object>> selectResvInfoEnterRegistList(Map<String, Object> params) throws Exception {		
		return EntranceMapper.selectResvInfoEnterRegistList(params);
	}
}
