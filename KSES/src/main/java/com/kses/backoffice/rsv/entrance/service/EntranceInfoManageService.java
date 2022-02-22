package com.kses.backoffice.rsv.entrance.service;

import java.util.List;
import java.util.Map;

public interface EntranceInfoManageService {

	List<?> selectEnterRegistList(String resvSeq) throws Exception;
	
	List<Map<String, Object>> selectResvInfoEnterRegistList(Map<String, Object> params) throws Exception;
}
