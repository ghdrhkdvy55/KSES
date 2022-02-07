package com.kses.backoffice.rsv.reservation.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.rsv.reservation.mapper.AttendInfoManageMapper;
import com.kses.backoffice.rsv.reservation.service.AttendInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.AttendInfo;
import com.kses.backoffice.util.SmartUtil;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class AttendInfoManageServiceImpl extends EgovAbstractServiceImpl implements AttendInfoManageService {

	private static final Logger LOGGER = LoggerFactory.getLogger(AttendInfoManageServiceImpl.class);
	
	@Autowired
	private AttendInfoManageMapper attendMapper;

	@Override
	public List<Map<String, Object>> selectAttendInfoListPage(Map<String, Object> params) {
		return attendMapper.selectAttendInfoListPage(params);
	}

	@Override
	public Map<String, Object> selectAttendInfoDetail(AttendInfo vo) {
		return attendMapper.selectAttendInfoDetail(vo);
	}

	@Override
	public AttendInfo insertAttendInfo(AttendInfo vo) {
		int ret = 0;
		
		if(!vo.getMode().equals("Manual")) {
			Map<String, Object> info = attendMapper.selectAttendInfoDetail(vo);
			
			if ((vo.getInoutDvsn().equals("IN") && info == null)
				|| (vo.getInoutDvsn().equals("IN") && SmartUtil.NVL(info.get("inout_dvsn"), "").toString().equals("IN") )) {			
				ret = attendMapper.insertAttendInfo(vo);
				if (ret > 0) {
					if (info == null) 
						info = attendMapper.selectAttendInfoDetail(vo);
					
					vo.setUserId(SmartUtil.NVL(info.get("user_id"), "").toString());
					vo.setUserNm(SmartUtil.NVL(info.get("user_nm"), "").toString());
					vo.setResvSeq("OK");
				} else {
					vo.setRcvCd("ERROR_03"); //시스템 에러
				}
				
			} else {
				vo.setRcvCd("ERROR_02"); // 입/출입 잘못 시도 
			}
		} else {
			ret = attendMapper.insertAttendInfo(vo);
			vo.setRet(ret);
		}
		return vo;
	}

	@Override
	public boolean deleteAttendInfo(String delCds) {
		try {
			attendMapper.deleteAttendInfo(SmartUtil.dotToList(delCds));
			return true;
		}catch(Exception e) {
			LOGGER.error("deleteAuthInfo error:" + e.toString());
			return false;
		}
	}	
}
