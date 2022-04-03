package com.kses.backoffice.bas.menu.service.impl;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.bas.menu.mapper.MenuCreateManageMapper;
import com.kses.backoffice.bas.menu.service.MenuCreateManageService;
import com.kses.backoffice.bas.menu.vo.MenuCreatInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class MenuCreateManageServiceImpl extends EgovAbstractServiceImpl implements MenuCreateManageService {

	@Autowired
	private MenuCreateManageMapper createMapper;

	
	@Override
	public List<Map<String, Object>> selectMenuCreatList(String authorCode) throws Exception {
		return createMapper.selectMenuCreatList_D(authorCode);
	}

	@Override
	public List<Map<String, Object>> selectMenuCreatList_Author(String authorCode) throws Exception {
		return createMapper.selectMenuCreatList_Author(authorCode);
	}
	
	
	@Override
	public int selectMenuCreatManagTotCnt(String searchKeyword) throws Exception {
		return createMapper.selectMenuCreatCnt_S(searchKeyword);
	}

	@Override
	public int selectUsrByPk(String empNo) throws Exception {
		return createMapper.selectUsrByPk(empNo);
	}

	@Override
	public MenuCreatInfo selectAuthorByUsr(String empNo) throws Exception {
		return createMapper.selectAuthorByUsr(empNo);
	}

	@Override
	public List<Map<String, Object>> selectMenuCreatManagList(Map<String, Object> searchVO) throws Exception {
		return createMapper.selectMenuCreatManageList_D(searchVO);
	}

	@Override
	public void insertMenuCreatList(String authorCode, String checkedMenuNoForInsert) throws Exception {
		
		
		int AuthorCnt = 0;
		
        List<String> insertMenuNo =  SmartUtil.dotToList(checkedMenuNoForInsert).stream().distinct().collect(Collectors.toList());

		MenuCreatInfo menuCreatVO = new MenuCreatInfo();
		menuCreatVO.setAuthorCode(authorCode);
		AuthorCnt = createMapper.selectMenuCreatCnt_S(authorCode);

		// 이전에 존재하는 권한코드에 대한 메뉴설정내역 삭제
		if (AuthorCnt > 0) {
			createMapper.deleteMenuCreat_S(menuCreatVO);
		}
		for (String menu : insertMenuNo) {
			menuCreatVO.setAuthorCode(authorCode);
			menuCreatVO.setMenuNo(menu);
			createMapper.insertMenuCreat_S(menuCreatVO);
		}
		
		
	}


	
	
}
