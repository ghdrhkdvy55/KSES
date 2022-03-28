package com.kses.backoffice.sym.log.service;

import java.util.List;
import java.util.Map;

import org.springframework.ui.ModelMap;

import com.kses.backoffice.sym.log.vo.InterfaceInfo;

public interface InterfaceInfoManageService {

    List<Map<String, Object>> selectInterfaceLogInfo(Map<String, Object> searchVO) throws Exception;
    
    Map<String, Object> selectInterfaceDetail (String requstId) throws Exception;
    
    String selectInterfaceLogCsvHeader() throws Exception;
    
    List<String> selectInterfaceLogCsvList(InterfaceInfo vo) throws Exception;
    
    ModelMap SpeedOnPayMent(String resvSeq, String cardPw, boolean isPassword) throws Exception;
    
    ModelMap SpeedOnPayMentCancel(String resvSeq, String cardPw, boolean isPassword, boolean isForced) throws Exception;
	
    int InterfaceInsertLoginLog(InterfaceInfo vo) throws Exception;
	
	int InterfaceUpdateLoginLog(InterfaceInfo vo) throws Exception;
	
	int deleteInterfaceLogCsvList(String occrrncDe) throws Exception;
}