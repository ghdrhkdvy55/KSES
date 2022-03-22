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
	
	public String selectResvPayCost(@Param("params") Map<String, Object> paramMap) ;
	
	public List<String> selectResvDateList(ResvInfo vo);
	
	public String selectResvSeqNext() throws Exception;
	
	public String selectCenterResvDate(@Param("centerCd") String centerCd);
	
	public List<Map<String, Object>> selectCenterResvDateList(@Param("centerCd") String centerCd);
	
	public Map<String, Object> selectInUserResvInfo(ResvInfo paramResvInfo);
	
	public String selectAutoPaymentResvInfo(@Param("userId") String userId);
	
	public Map<String, Object> selectResvBillInfo(@Param("resvSeq") String resvSeq);
	
	public List<Map<String, Object>> selectUserMyResvInfo(@Param("params") Map<String, Object> paramMap);
	
	public List<Map<String, Object>> selectGuestMyResvInfo(@Param("params") Map<String, Object> paramMap);
	
	public List<Map<String, Object>> selectResvInfoManageListByPagination(@Param("params") Map<String, Object> params);
	
	public Map<String, Object> selectUserResvInfo(@Param("params") Map<String, Object> params);
	
	public Map<String, Object> selectUserResvInfoFront(@Param("params") Map<String, Object> params);
	
	public int selectResvDuplicate(@Param("params") Map<String, Object> params);
	
	public int insertUserResvInfo(ResvInfo vo);
	
	public int insertLongResvInfo(ResvInfo vo);
	
	public int insertUserLongResvInfo(ResvInfo vo);
	
	public int updateResvSeatInfo(@Param("params") Map<String, Object> paramMap);
	
	public int updateResvInfoCopy(@Param("params") Map<String, Object> paramMap); 
	
	public int resvInfoCancel(@Param("params") Map<String, Object> paramMap);
	
	public int updateUserResvInfo(ResvInfo vo);
	
	public int updateLongResvInfo(ResvInfo vo);
	
	public int updateUserLongResvInfo(ResvInfo vo);
	
	public int updateResvState(ResvInfo vo);
	
	public int updateResvRcptInfo(ResvInfo vo);
	
	public int updateResvUseComplete();
	
	public int updateResvQrCount(@Param("resvSeq") String resvSeq);
	
	public Map<String, Object> selectQrDuplicate(@Param("params") Map<String, Object> params);
	
	public int resvBillChange(ResvInfo vo);
	
	public int updateResvPriceInfo(ResvInfo vo);
	
	public String resvValidCheck(@Param("params") Map<String, Object> params);
}