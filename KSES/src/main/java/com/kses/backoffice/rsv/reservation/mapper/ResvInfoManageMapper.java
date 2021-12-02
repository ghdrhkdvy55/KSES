package com.kses.backoffice.rsv.reservation.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Param;
import java.util.List;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface ResvInfoManageMapper {
	
	public Map<String, Object> selectUserLastResvInfo(@Param("userId") String userId);
	
	public Map<String, Object> selectResInfoDetail(String resvSeq);
	
	
	public String selectResvEntryDvsn(@Param("resvSeq") String paramString);
	
	public String selectFindPassword(@Param("params") Map<String, Object> paramMap );
	
	public Map<String, Object> selectInUserResvInfo(ResvInfo paramResvInfo);
	
	public Map<String, Object> selectResvQrInfo(@Param("resvSeq") String paramString);
	
	public List<Map<String, Object>> selectUserMyResvInfo(@Param("params") Map<String, Object> paramMap);
	
	public Map<String, Object> selectGuestMyResvInfo(@Param("params") Map<String, Object> paramMap);
	
	public int resvInfoCancel(@Param("params") Map<String, Object> paramMap);
	
	public int checkUserResvInfo(@Param("params") Map<String, Object> params);
	//신규 추가
	public List<Map<String, Object>> selectResInfoManageListByPagination(@Param("params") Map<String, Object> params);
	
	public Map<String, Object> selectUserResvInfo(@Param("params") Map<String, Object> params);
	
	public int insertUserResvInfo(ResvInfo vo);
	
	public int updateUserResvInfo(ResvInfo vo);
	
	public int resPriceChange(ResvInfo vo);
	
	
}
