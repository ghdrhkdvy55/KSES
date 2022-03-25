package com.kses.backoffice.rsv.black.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.rsv.black.vo.BlackUserInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface BlackUserInfoManageMapper {
	public List<Map<String, Object>> selectBlackUserInfoList(@Param("params") Map<String, Object> params);
	
	public int insertBlackUserInfo(BlackUserInfo vo);
	
	public int updateBlackUserInfo(BlackUserInfo vo);
	
	public int deleteBlackUserInfo(String blklstSeq);
}
