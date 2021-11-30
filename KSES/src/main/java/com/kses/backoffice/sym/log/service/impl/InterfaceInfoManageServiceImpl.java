package com.kses.backoffice.sym.log.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.sym.log.mapper.InterfaceInfoManageMapper;
import com.kses.backoffice.sym.log.service.InterfaceInfoManageService;
import com.kses.backoffice.sym.log.vo.InterfaceInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;


@Service
public class InterfaceInfoManageServiceImpl extends EgovAbstractServiceImpl implements InterfaceInfoManageService {

	
	@Autowired
	private InterfaceInfoManageMapper interfaceMapper;
	
	@Resource (name = "egovTrsmrcvLogIdGnrService")
	private EgovIdGnrService egovTranLog;
	
	
	
	@Override
	public List<Map<String, Object>> selectInterfaceLogInfo(Map<String, Object> searchVO) throws Exception {
		// TODO Auto-generated method stub
		return interfaceMapper.selectInterfaceLogInfo(searchVO);
	}

	@Override
	public Map<String, Object> selectInterfaceDetail(String requstId) throws Exception {
		// TODO Auto-generated method stub
		return interfaceMapper.selectInterfaceDetail(requstId);
	}

	@Override
	public int InterfaceInsertLoginLog(InterfaceInfo vo) throws Exception {
		// TODO Auto-generated method stub
		vo.setRequstId( egovTranLog.getNextStringId());
		return  interfaceMapper.InterfaceInsertLoginLog(vo);
	}

	@Override
	public int InterfaceUpdateLoginLog(InterfaceInfo vo) throws Exception {
		// TODO Auto-generated method stub
		return interfaceMapper.InterfaceUpdateLoginLog(vo);
	}

}
