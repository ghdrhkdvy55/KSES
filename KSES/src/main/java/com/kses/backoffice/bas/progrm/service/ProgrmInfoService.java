package com.kses.backoffice.bas.progrm.service;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.bas.progrm.vo.ProgrmInfo;

public interface ProgrmInfoService {
	
	List<Map<String, Object>> selectProgrmInfoList(Map<String, Object> params) throws Exception;
	
    Map<String, Object> selectProgrmInfoDetail(String progrmFileNm) throws Exception;
	
    int insertProgrmInfo(ProgrmInfo progrmInfo) throws Exception;
    
    int updateProgrmInfo(ProgrmInfo progrmInfo) throws Exception;
    
    int deleteProgrmInfo(String progrmFileNm) throws Exception;

    /**
	 * 화면에 조회된 메뉴 목록 정보를 데이터베이스에서 삭제
	 * @param checkedProgrmFileNmForDel String
	 * @exception Exception
	 */
	int deleteProgrmManageList(String checkedProgrmFileNmForDel) throws Exception;

}