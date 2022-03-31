package com.kses.backoffice.bas.system.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bas.system.vo.AutoPaymentInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface AutoPaymentInfoManageMapper {
	
	public List<Map<String, Object>> selectAutoPaymentInfoList() throws Exception;
	
	public int updateAutoPaymentInfo(@Param("autoPaymentInfoList") List<AutoPaymentInfo> AutoPaymentInfoList) throws Exception;
}
