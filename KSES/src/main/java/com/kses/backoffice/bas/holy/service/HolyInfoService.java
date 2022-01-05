package com.kses.backoffice.bas.holy.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bas.holy.vo.HolyInfo;

public interface HolyInfoService {
	
	/**
	 * KSES 휴일 목록 조회
	 * @param params
	 * @return
	 * @throws Exception
	 */
    List<Map<String, Object>> selectHolyInfoList(Map<String, Object> params) throws Exception;
	
	/**
	 * 휴일 상세 조회
	 * @param holySeq
	 * @return
	 * @throws Exception
	 */
    Map<String, Object> selectHolyInfoDetail(String holySeq) throws Exception;
	
    /**
     * KSES 휴일 정보 등록
     * @param holyInfo
     * @return
     * @throws Exception
     */
    int insertHolyInfo(HolyInfo holyInfo) throws Exception;
    
    /**
     * KSES 휴일 정보 수정
     * @param vo
     * @return
     * @throws Exception
     */
    int updateHolyInfo(HolyInfo holyInfo) throws Exception;
    
    /**
     * KSES 휴일 정보 삭제
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
    int holyInfoCenterApply(List<HolyInfo> holyInfoList) throws Exception;
    
    boolean insertExcelHoly(List<HolyInfo> holyInfoList) throws Exception;
    
    /**
     * KSES 휴일 센터 정보 목록
     * @param holyDt
     * @return
     * @throws Exception
     */
    List<Map<String, Object>> selectHolyCenterList(Map<String, Object> searchVO) throws Exception;
}
