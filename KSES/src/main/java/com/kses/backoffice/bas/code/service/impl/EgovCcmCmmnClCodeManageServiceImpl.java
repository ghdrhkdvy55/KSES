package com.kses.backoffice.bas.code.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import com.kses.backoffice.bas.code.mapper.EgovCmmnClCodeManageMapper;
import com.kses.backoffice.bas.code.service.EgovCcmCmmnClCodeManageService;
import com.kses.backoffice.bas.code.vo.CmmnClCode;


@Service
public class EgovCcmCmmnClCodeManageServiceImpl extends EgovAbstractServiceImpl implements EgovCcmCmmnClCodeManageService {

	
	@Autowired
	EgovCmmnClCodeManageMapper cmmnClCodeManageMapper;

	/**
	 * 공통분류코드를 삭제한다.
	 */
	@Override
	public int deleteCmmnClCode(CmmnClCode cmmnClCode) throws Exception {
		return cmmnClCodeManageMapper.deleteCmmnClCode(cmmnClCode.getClCode());				
	}

	/**
	 * 공통분류코드 상세항목을 조회한다.
	 */
	@Override
	public Map<String, Object> selectCmmnClCodeDetail(String clCode) throws Exception {    	
    	return cmmnClCodeManageMapper.selectCmmnClCodeDetail(clCode);
	}

	/**
	 * 공통분류코드 목록을 조회한다.
	 */
	@Override
	public List<?> selectCmmnClCodeList(Map<String, Object> searchVO) throws Exception {
		return cmmnClCodeManageMapper.selectCmmnClCodeListByPagination(searchVO);        
	}

	/**
	 * 공통분류코드를 수정한다.
	 */
	@Override
	public int updateCmmnClCode(CmmnClCode cmmnClCode) throws Exception {
		return  cmmnClCode.getMode().equals("Ins")?  cmmnClCodeManageMapper.insertCmmnClCode(cmmnClCode) : cmmnClCodeManageMapper.updateCmmnClCode(cmmnClCode) ;		
	}

	
	
}
