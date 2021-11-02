package com.kses.backoffice.bas.progrm.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import com.kses.backoffice.bas.progrm.vo.ProgrmInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper
public interface ProgrmInfoManageMapper {
	
    public List<Map<String, Object>> selectProgrmInfoList(@Param("params") Map<String, Object> params);
	
    public Map<String, Object> selectProgrmInfoDetail(String progrmFileNm);
    
    public int selectProgrmListTotCnt();
    
    public int insertProgrmInfo(ProgrmInfo vo);
	
    public int updateProgrmInfo(ProgrmInfo vo);
    
    public int deleteProgrmInfo(String progrmFileNm);
    
    public int deleteProgrmManageList(@Param("programFiles") List<String> programFiles);
	/**
	 * 프로그램목록 전체삭제 초기화
	 * @return boolean
	 * @exception Exception
	 */
    public int deleteAllProgrm();
    
   
}

