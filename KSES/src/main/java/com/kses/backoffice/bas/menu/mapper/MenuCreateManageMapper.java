package com.kses.backoffice.bas.menu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bas.menu.vo.MenuCreatInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;



@Mapper
public interface MenuCreateManageMapper {

	public List<Map<String, Object>>selectMenuCreatManageList_D(@Param("params") Map<String, Object> vo);
	
	public int selectMenuCreatManageTotCnt_S(String searchKeyword);
	
	public MenuCreatInfo selectAuthorByUsr(String empNo);
	
	public int selectUsrByPk(String empNo);
	
	public int selectMenuCreatCnt_S(String authorCode);
	
	public List<Map<String, Object>> selectMenuCreatList_D(String authorCode);
	//tree 메뉴 설정
	public List<Map<String, Object>> selectMenuCreatList_Author(String authorCode);
	
	public int insertMenuCreat_S(MenuCreatInfo info);
	
	public int updateMenuCreat_S(MenuCreatInfo info);
	
	public int deleteMenuCreat_S(MenuCreatInfo info);
	
	
}
