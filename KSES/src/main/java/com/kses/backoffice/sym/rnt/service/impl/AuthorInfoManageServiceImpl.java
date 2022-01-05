package com.kses.backoffice.sym.rnt.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.sym.rnt.mapper.AuthorInfoManagerMapper;
import com.kses.backoffice.sym.rnt.service.AuthorInfoManageService;
import com.kses.backoffice.sym.rnt.vo.AuthorInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class AuthorInfoManageServiceImpl extends EgovAbstractServiceImpl implements AuthorInfoManageService {

	
	
	@Autowired
	private AuthorInfoManagerMapper authMapper;
	
	@Override
	public List<AuthorInfo> selectAuthorIInfoManageCombo() {
		return authMapper.selectAuthorIInfoManageCombo();
	}
	

}
