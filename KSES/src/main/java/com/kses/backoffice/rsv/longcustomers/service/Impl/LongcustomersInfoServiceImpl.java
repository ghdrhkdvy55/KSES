package com.kses.backoffice.rsv.longcustomers.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.rsv.longcustomers.mapper.LongcustomersInfoManageMapper;
import com.kses.backoffice.rsv.longcustomers.service.LongcustomersInfoService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class LongcustomersInfoServiceImpl extends EgovAbstractServiceImpl implements LongcustomersInfoService{
	
	@Autowired
	private LongcustomersInfoManageMapper longcustomerMapper;

	@Override
	public List<Map<String, Object>> selectLongcustomerList(Map<String, Object> searchVO) throws Exception {
		return longcustomerMapper.selectLongcustomerList(searchVO);
	}
	
	@Override
	public List<?> selectLongcustomerResvList(String longResvSeq) throws Exception {
        return longcustomerMapper.selectLongcustomerResvList(longResvSeq);
	}
}