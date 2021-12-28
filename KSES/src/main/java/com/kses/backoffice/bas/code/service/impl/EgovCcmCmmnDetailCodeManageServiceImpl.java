package com.kses.backoffice.bas.code.service.impl;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bas.code.mapper.EgovCmmnDetailCodeManageMapper;
import com.kses.backoffice.bas.code.service.EgovCcmCmmnDetailCodeManageService;
import com.kses.backoffice.bas.code.vo.CmmnDetailCode;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EgovCcmCmmnDetailCodeManageServiceImpl extends EgovAbstractServiceImpl implements EgovCcmCmmnDetailCodeManageService {

	@Autowired
    private EgovCmmnDetailCodeManageMapper CmmnDetailCodeManageMapper;
	/**
	 * 공통상세코드를 삭제한다.
	 */
	@Override
	public int deleteCmmnDetailCode(String code) throws Exception {
		 return CmmnDetailCodeManageMapper.deleteCmmnDetailCode(code);		
	}
	
	@Override
	public CmmnDetailCode selectCmmnDetailCodeDetail(String code) throws Exception {
    	return CmmnDetailCodeManageMapper.selectCmmnDetailCodeDetail(code);    	
	}

	/**
	 * 공통상세코드 목록을 조회한다.
	 */
	@Override
	public List<?> selectCmmnDetailCodeList(String codeId) throws Exception {
        return CmmnDetailCodeManageMapper.selectCmmnDetailCodeListByPagination(codeId);
	}
	
	@Override
	public List<Map<String, Object>> selectCmmnDetailCombo(String code) throws Exception {
		// TODO Auto-generated method stub
		return CmmnDetailCodeManageMapper.selectCmmnDetailCombo(code);
	}
	
	@Override
	public int insertCmmnDetailCode(CmmnDetailCode cmmnDetailCode) throws Exception {
		return CmmnDetailCodeManageMapper.insertCmmnDetailCode(cmmnDetailCode);
	}
	
	@Override
	public int updateCmmnDetailCode(CmmnDetailCode cmmnDetailCode) throws Exception {
		return CmmnDetailCodeManageMapper.updateCmmnDetailCode(cmmnDetailCode);
	}

	
	@Override
	public Map<String, Object> selectCmmnDetail(String code) throws Exception {
		// TODO Auto-generated method stub
		return CmmnDetailCodeManageMapper.selectCmmnDetail(code);
	}

	@Override
	public List<Map<String, Object>> selectComboSwcCon() throws Exception {
		// TODO Auto-generated method stub
		return CmmnDetailCodeManageMapper.selectComboSwcCon();
	}

	@Override
	public List<Map<String, Object>> selectCmmnDetailResTypeCombo(Map<String, Object> vo) throws Exception {
		// TODO Auto-generated method stub
		return CmmnDetailCodeManageMapper.selectCmmnDetailResTypeCombo(vo);
	}
	 
	@Override
	public List<CmmnDetailCode> selectCmmnDetailComboEtc(Map<String, Object> params)
			throws Exception {
		// TODO Auto-generated method stub
		return CmmnDetailCodeManageMapper.selectCmmnDetailComboEtc(params);
	}

	@Override
	public List<Map<String, Object>> selectCmmnDetailAjaxCombo(String code) throws Exception {
		// TODO Auto-generated method stub
		return CmmnDetailCodeManageMapper.selectCmmnDetailComboLamp(code);
	}

	
	

}
