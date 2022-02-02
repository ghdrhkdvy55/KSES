package com.kses.backoffice.rsv.msg.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.kses.backoffice.rsv.msg.vo.MessageGroupUserInfo;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface MessageGroupUserInfoManageMapper {

    public List<Map<String, Object>> selectMessageGroupUserInfoList(@Param("params") Map<String, Object> params);
    
    public Map<String, Object> selectMessageGroupUserDetail(String groupCd);
    
    public int insertMessageGroupUserInfo(@Param("MessageGroupUserInfo") List<MessageGroupUserInfo> userInfo);
    
    public void insertMessageGroupUser(MessageGroupUserInfo userInfo);
	
    public void deleteMessageGroupUserInfo(@Param("delCds") List<String> delCds);
}
