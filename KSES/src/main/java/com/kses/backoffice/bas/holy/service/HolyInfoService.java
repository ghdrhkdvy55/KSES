package com.kses.backoffice.bas.holy.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.bas.holy.vo.HolyInfo;

public interface HolyInfoService {
	
	/**
	 * KSES 계정 권한 목록 조회
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
    List<Map<String, Object>> selectHolyInfoList(Map<String, Object> params) throws Exception;
	
	/**
	 * KSES 계정 권한 상세정보 조회
	 * 
	 * @param HolyCode
	 * @return
	 * @throws Exception
	 */
    Map<String, Object> selectHolyInfoDetail(String holySeq) throws Exception;
	
    
    boolean insertExcelHoly(List<HolyInfo> holyInfoList)throws Exception;
    /**
     * KSES 계정 권한 정보 등록 및 수정
     * 
     * @param vo
     * @return
     * @throws Exception
     */
    int updateHolyInfo(HolyInfo vo) throws Exception;
    
    /**
     * KSES 계정 권한 정보 삭제
     * 
     * @param HolyCode
     * @return
     * @throws Exception
     */
    int deleteHolyInfo(List<String> holyList)throws Exception;
    
    /**
     * KSES 계정 권한 정보 삭제
     * 
     * @param HolyCode
     * @return
     * @throws Exception
     */
    int holyInfoCenterApply(List<HolyInfo> holyInfoList)throws Exception;
}
