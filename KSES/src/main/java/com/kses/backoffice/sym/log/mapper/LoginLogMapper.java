package com.kses.backoffice.sym.log.mapper;

import java.util.List;
import java.util.Map;
import com.kses.backoffice.sym.log.vo.LoginLog;
import egovframework.rte.psl.dataaccess.mapper.Mapper;



@Mapper
public interface LoginLogMapper {

    public List<Map<String, Object>> selectLoginLogInfo (Map<String, Object> searchVO);
    
    public Map<String, Object> selectLoginDetail (String logId);
	
	public int logInsertLoginLog(LoginLog vo);
}
