package com.kses.backoffice.bld.center.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bld.center.vo.NoshowInfo;
import com.kses.backoffice.rsv.reservation.vo.NoShowHisInfo;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface NoshowInfoManageMapper {
	public List<Map<String, Object>> selectNoshowInfoList(@Param("centerCd") String centerCd) throws Exception;
	
	public List<Map<String, Object>> selectNoshowResvInfo_R1() throws Exception; 
	
	public List<Map<String, Object>> selectNoshowResvInfo_R2() throws Exception; 
	
	public int insertNoshowResvInfo(NoShowHisInfo noshowHisInfo) throws Exception;
	
	public int updateNoshowResvInfoCancel(ResvInfo resvInfo) throws Exception;
	
	public int updateNoshowInfo(@Param("noshowInfoList") List<NoshowInfo> noshowInfoList) throws Exception;
	
	public int copyNoshowInfo(@Param("params") Map<String, Object> params) throws Exception;
}
