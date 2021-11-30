package com.kses.backoffice.sys.msg.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kses.backoffice.sys.msg.vo.MessageInfo;
import egovframework.rte.psl.dataaccess.mapper.Mapper;



@Mapper
public interface MessageInfoManageMapper {

    public List<Map<String, Object>> selectMsgManageListByPagination(@Param("params") Map<String, Object> searchVO) throws Exception;
    
    public Map<String, Object> selectMsgManageDetail(String MsgSeq) throws Exception;
	
    public int insertMsgManage(@Param("messageInfos") List<MessageInfo> messageInfos) throws Exception;
    
    public void deleteMsgManage(@Param("params") List<String> delCds);
	
	
}
