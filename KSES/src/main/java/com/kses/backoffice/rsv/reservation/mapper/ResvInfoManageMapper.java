package com.kses.backoffice.rsv.reservation.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Param;

import java.util.List;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface ResvInfoManageMapper {
	
	public Map<String, Object> selectUserLastResvInfo(@Param("userId") String userId);
	
	public Map<String, Object> selectResvInfoDetail(String resvSeq);
	
	public String selectResvUserId(@Param("resvSeq") String resvSeq) throws Exception;
	
	public String selectResvEntryDvsn(@Param("resvSeq") String paramString);
	
	public String selectFindPassword(@Param("params") Map<String, Object> paramMap );
	
	public List<String> selectResvDateList(ResvInfo vo) throws Exception;
	
	public Map<String, Object> selectInUserResvInfo(ResvInfo paramResvInfo);
	
	public Map<String, Object> selectResvBillInfo(@Param("resvSeq") String resvSeq) throws Exception;
	
	public List<Map<String, Object>> selectUserMyResvInfo(@Param("params") Map<String, Object> paramMap);
	
	public List<Map<String, Object>> selectGuestMyResvInfo(@Param("params") Map<String, Object> paramMap);
	
	public int resvSeatChange(@Param("params") Map<String, Object> paramMap);
	
	public int resvInfoCancel(@Param("params") Map<String, Object> paramMap);
	
	public int resvInfoDuplicateCheck(@Param("params") Map<String, Object> params);
	//신규 추가
	public List<Map<String, Object>> selectResvInfoManageListByPagination(@Param("params") Map<String, Object> params);
	
	public Map<String, Object> selectUserResvInfo(@Param("params") Map<String, Object> params);
	
	public int insertUserResvInfo(ResvInfo vo);
	
	public int insertLongResvInfo(ResvInfo vo);
	
	public int insertUserLongResvInfo(ResvInfo vo);
	
	public int updateUserResvInfo(ResvInfo vo);
	
	public int updateLongResvInfo(ResvInfo vo);
	
	public int updateUserLongResvInfo(ResvInfo vo);
	
	public int resvStateChange(ResvInfo vo);
	
	public int resvCompleteUse();
	
	public int resvQrCountChange(@Param("resvSeq") String resvSeq);
	
	public Map<String, Object> resvQrDoubleCheck(@Param("params") Map<String, Object> params);
	
	public int resvBillChange(ResvInfo vo);
	
	public int resPriceChange(ResvInfo vo);
	
	public String resvValidCheck(@Param("params") Map<String, Object> params);
	
	public Map<String, Object> selectTicketMchnSnoCheck(@Param("params") Map<String, Object> params);
}
