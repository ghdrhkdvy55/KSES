package com.kses.backoffice.cus.kko.mapper;

import java.util.List;
import java.util.Map;

import com.kses.backoffice.cus.kko.vo.KkoMsgInfo;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper
public interface KkoMsgManageMapper {

	public List<Map<String, Object>> selectKkoMsgInfoList(Map<String, Object> params);
	
	public Map<String, Object> selectKkoMsgInfoDetail(String msgkey);
	
	public int kkoMsgInsertSevice(KkoMsgInfo vo);
}
