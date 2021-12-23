package com.kses.backoffice.bld.center.service.impl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bld.center.mapper.NoshowInfoManageMapper;
import com.kses.backoffice.bld.center.service.NoshowInfoManageService;
import com.kses.backoffice.bld.center.vo.NoshowInfo;
import com.kses.backoffice.rsv.reservation.vo.NoShowHisInfo;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;

@Service
public class NoshowInfoManageServiceImpl extends EgovAbstractServiceImpl implements NoshowInfoManageService {

	@Autowired
	NoshowInfoManageMapper noshowMapper;
	
	@Override
	public List<Map<String, Object>> selectNoshowInfoList(String centerCd) throws Exception {
		// TODO Auto-generated method stub
		return noshowMapper.selectNoshowInfoList(centerCd);
	}
	
	@Override
	public List<Map<String, Object>> selectNoshowResvInfo_R1() throws Exception {
		return noshowMapper.selectNoshowResvInfo_R1();
	}
	
	@Override
	public List<Map<String, Object>> selectNoshowResvInfo_R2() throws Exception {
		return noshowMapper.selectNoshowResvInfo_R2();
	}
	
	@Override
	public int insertNoshowResvInfo(NoShowHisInfo noshowHisInfo) throws Exception {
		// TODO Auto-generated method stub
		return noshowMapper.insertNoshowResvInfo(noshowHisInfo);
	}

	@Override
	public int updateNoshowResvInfoCancel(ResvInfo resvInfo) throws Exception {
		// TODO Auto-generated method stub
		return noshowMapper.updateNoshowResvInfoCancel(resvInfo);
	}
	
	@Override
	public int updateNoshowInfo(List<NoshowInfo> noshowInfoList) throws Exception {
		// TODO Auto-generated method stub
		return noshowMapper.updateNoshowInfo(noshowInfoList);
	}

	@Override
	public int copyNoshowInfo(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return noshowMapper.copyNoshowInfo(params);
	}
}