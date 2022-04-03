package com.kses.backoffice.rsv.longcustomers.service;

import java.util.List;
import java.util.Map;


public interface LongcustomersInfoService {

	List<Map<String, Object>> selectLongcustomerList (Map<String, Object> searchVO) throws Exception;
	
	List<?> selectLongcustomerResvList(String longResvSeq) throws Exception;
	
}