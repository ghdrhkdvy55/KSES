package com.kses.backoffice.bas.code.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.kses.backoffice.bas.code.mapper.EgovCmmnCodeManageMapper;
import com.kses.backoffice.bas.code.service.EgovCcmCmmnCodeManageService;
import com.kses.backoffice.bas.code.vo.CmmnCode;



@Service
public class EgovCcmCmmnCodeManageServiceImpl extends EgovAbstractServiceImpl implements EgovCcmCmmnCodeManageService {

	@Autowired
	private EgovCmmnCodeManageMapper codeMapper;

	@Override
	public int deleteCmmnCode(String codeId) throws Exception {
		return codeMapper.deleteCmmnCode(codeId);
	}

	@Override
	public Map<String, Object> selectCmmnCodeDetail(String codeId) throws Exception {
		return codeMapper.selectCmmnCodeDetail(codeId);
	}

	@Override
	public List<?> selectCmmnCodeList() throws Exception {
		return codeMapper.selectCmmnCodeList();
	}

	@Override
	public int updateCmmnCode(CmmnCode cmmnCode) throws Exception {
		return cmmnCode.getMode().equals("Ins") ?  codeMapper.insertCmmnCode(cmmnCode) : codeMapper.updateCmmnCode(cmmnCode);
	}

	
	@Override
	public List<Map<String, Object>> selectCmmnCodeListByPagination(Map<String, Object> vo) throws Exception {
		System.out.println("vo:" + vo);
		return codeMapper.selectCmmnCodeListByPagination(vo);
	}
}