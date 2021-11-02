package com.kses.backoffice.util.service;

import java.util.Map;

public interface UniSelectInfoManageService {

	String selectMaxValue(String is_Column, String is_Table) throws Exception;
	
	int updateUniStatement(String isColumn,String isTable, String isCondition);
	
	int deleteUniStatement(String is_Column, String is_Table, String is_condition) throws Exception;
	
	int selectIdDoubleCheck(String is_Column, String is_Table, String is_condition) throws Exception;
	
	Map<String, Object> selectFieldStatement(String is_Column, String is_Table, String is_condition)throws Exception;
}