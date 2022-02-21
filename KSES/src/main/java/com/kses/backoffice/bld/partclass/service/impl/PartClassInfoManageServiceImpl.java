
package com.kses.backoffice.bld.partclass.service.impl;

import java.util.List; import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired; import
org.springframework.stereotype.Service;

import com.kses.backoffice.bld.partclass.mapper.PartClassInfoManageMapper;
import com.kses.backoffice.bld.partclass.service.PartClassInfoManageService;
import com.kses.backoffice.bld.partclass.vo.PartClassInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service public class PartClassInfoManageServiceImpl extends EgovAbstractServiceImpl implements PartClassInfoManageService {
  
	@Autowired
	private PartClassInfoManageMapper partClassMapper;

	@Override 
	public List<Map<String, Object>> selectPartClassList (Map<String, Object> searchVO) throws Exception{
		return partClassMapper.selectPartClassList(searchVO);
	}

	@Override
	public Map<String, Object> selectPartClass(String partClassSeq) throws Exception {
		return partClassMapper.selectPartClass(partClassSeq);
	}

	@Override
	public List<Map<String, Object>> selectPartClassComboList (String centerCd) throws Exception {
		return partClassMapper.selectPartClassComboList(centerCd);
	}
	
	@Override
	public int insertPartClassInfo(PartClassInfo partClassInfo) throws Exception {
		return partClassMapper.insertPartClassInfo(partClassInfo); 
	}

	@Override
	public int updatePartClassInfo(PartClassInfo partClassInfo) throws Exception {
		return partClassMapper.updatePartClassInfo(partClassInfo);
	}

	@Override
	public int deletePartClassInfo(String partClassSeq) throws Exception {
		return partClassMapper.deletePartClassInfo(partClassSeq); 
	} 
}