package com.kses.backoffice.sym.log.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.kses.backoffice.sym.log.annotation.NoLogging;
import com.kses.backoffice.sym.log.mapper.SysLogManageMapper;
import com.kses.backoffice.sym.log.service.EgovSysLogService;
import com.kses.backoffice.sym.log.vo.SysLog;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Service
public class EgovSysLogServiceImpl extends EgovAbstractServiceImpl implements EgovSysLogService {

	@Autowired
	private SysLogManageMapper syslogMapper;
	
	
    /** ID Generation */    
	@Resource(name="egovSysLogIdGnrService")
	private EgovIdGnrService egovSysLogIdGnrService;

	
	
	@NoLogging
	@Override
	public void logInsertSysLog(SysLog sysLog) throws Exception {
		// TODO Auto-generated method stub
		if (!sysLog.getErrorCode().equals("909")){
			sysLog.setRequstId(egovSysLogIdGnrService.getNextStringId());
			syslogMapper.logInsertSysLog(sysLog);
		}
	}
	
	@NoLogging
	@Override
	public void logInsertSysLogSummary() throws Exception {
		// TODO Auto-generated method stub
		
	}
	
	@NoLogging
	@Override
	public Map<String, Object> selectSysLogInfo(@Param("requestId") String requstId) throws Exception {
		// TODO Auto-generated method stub
		return syslogMapper.selectSysLogInfo(requstId);
	}
	
	@NoLogging
	@Override
	public ModelAndView selectSysLogList(SysLog sysLog)  throws Exception {
		// TODO Auto-generated method stub
		//페이징 처리 다시 한번 생각하기 
		
		ModelAndView mav = new ModelAndView();
		
		PaginationInfo paginationInfo = new PaginationInfo();
	   	paginationInfo.setCurrentPageNo(sysLog.getPageIndex());
		paginationInfo.setRecordCountPerPage(sysLog.getPageUnit());
		paginationInfo.setPageSize(sysLog.getPageSize());
		 
		sysLog.setFirstIndex(paginationInfo.getFirstRecordIndex());
		sysLog.setLastIndex(paginationInfo.getLastRecordIndex());
		sysLog.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		
		List<Map<String, Object>> list = syslogMapper.selectSysLogList(sysLog);
		 int totCnt = list.size() > 0 ? Integer.parseInt( list.get(0).get("total_record_count").toString() ): 0;
		 paginationInfo.setTotalRecordCount(totCnt);
		 mav.addObject("regist", sysLog);
    	 mav.addObject("resultList",  list );
    	 mav.addObject("paginationInfo", paginationInfo);
    	 mav.addObject("totalCnt", totCnt);
		return mav;
	}
	
	@NoLogging
	@Override
	public List<Map<String, Object>> selectSysLogListCnt(SysLog sysLog) throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, Object>> list = syslogMapper.selectSysLogList(sysLog);
		return list;
	}
}