package com.kses.backoffice.sym.log.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import com.kses.backoffice.sym.log.vo.InterfaceInfo;

public interface InterfaceInfoManageService {

    List<Map<String, Object>> selectInterfaceLogInfo (Map<String, Object> searchVO) throws Exception;
    
    Map<String, Object> selectInterfaceDetail (String requstId) throws Exception;
    
    Map<String, Object> SpeedOnCancelPayMent(JSONObject jsonObject) throws Exception;
    
    Map<String, Object> SpeedOnPayMent(JSONObject jsonObject) throws Exception;
	
    int InterfaceInsertLoginLog(InterfaceInfo vo) throws Exception;
	
	int InterfaceUpdateLoginLog(InterfaceInfo vo) throws Exception;
}