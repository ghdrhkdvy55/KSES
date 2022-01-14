package com.kses.backoffice.bas.system.service;

import com.kses.backoffice.bas.system.vo.SystemInfo;

/**
 * KSES 시스템 환경설정 서비스
 * 
 * @author JangDaeHan
 *
 */
public interface SystemInfoManageService {
	
    public SystemInfo selectSystemInfo() throws Exception;
	
    public int updateSystemInfo(SystemInfo vo) throws Exception;
}
