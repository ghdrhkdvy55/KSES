package com.kses.backoffice.rsv.msg.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.rsv.msg.vo.MessageGroupInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface MessageGroupInfoManageMapper {

	
    public List<Map<String, Object>> selectMessageGroupInfoList(@Param("params") Map<String, Object> params);
    
    public Map<String, Object> selectMessageGroupDetail(String groupCd);
    
    public int insertMessageGroupInfo(MessageGroupInfo vo);
	
    public int updateMessageGroupInfo(MessageGroupInfo vo);
    
    public void deleteMessageGroupInfo(@Param("delCds") List<String> delCds);
}
