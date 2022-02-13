package com.kses.backoffice.bld.center.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.center.vo.BillDayInfo;
import com.kses.backoffice.bld.center.vo.BillInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface BillInfoManageMapper {
	public List<Map<String, Object>> selectBillInfoList(@Param("centerCd") String centerCd) throws Exception;
	
	public List<Map<String, Object>> selectBillDayInfoList(@Param("centerCd") String centerCd) throws Exception;
	
	public Map<String, Object> selectBillInfoDetail(@Param("billSeq") String billSeq) throws Exception;
	
	public int insertBillInfo(BillInfo billInfo) throws Exception;
	
	public int updateBillInfo(BillInfo billInfo) throws Exception;
	
	public int updateBillDayInfo(@Param("billDayInfoList") List<BillDayInfo> billDayInfoList) throws Exception;

	public int updateBillDayInfoByCenterCd(BillInfo billInfo);
	
	public int deleteBillInfo(@Param("billSeq") String billSeq) throws Exception;
}
