package com.kses.backoffice.cus.kko.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.cus.kko.vo.KkoMsgInfo;

public interface KkoMsgManageSevice {

	List<Map<String, Object>> selectKkoMsgInfoList(Map<String, Object> params) throws Exception;
	
	Map<String, Object> selectKkoMsgInfoDetail(String msgkey)throws Exception;
	
	int kkoMsgInsertSevice(String _snedGubun, Map<String, Object> params) throws Exception;
	
	int kkoVisitedInsertService (String _snedGubun, List<List< Object>> params, String _visitedGubun) throws Exception;
	

}
