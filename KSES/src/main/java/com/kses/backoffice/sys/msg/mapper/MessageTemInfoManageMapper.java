package com.kses.backoffice.sys.msg.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import com.kses.backoffice.sys.msg.vo.MessageTemInfo;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface MessageTemInfoManageMapper {

    public List<Map<String, Object>> selectMessageTemplateInfoList(@Param("params") Map<String, Object> params);
    
    public Map<String, Object> selectMessageTemplateDetail(String tempSeq);
    
    public int insertMessageTemplateInfo(MessageTemInfo vo);
	
    public int updateMessageTemplateInfo(MessageTemInfo vo);
    
    public void deleteMessageTemplateInfo(@Param("delCds") List<String> delCds);
}
