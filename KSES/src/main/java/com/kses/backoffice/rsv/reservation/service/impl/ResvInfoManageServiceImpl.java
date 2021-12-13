package com.kses.backoffice.rsv.reservation.service.impl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.rsv.reservation.mapper.ResvInfoManageMapper;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;
import com.kses.backoffice.rsv.reservation.vo.reservation;

@Service
public class ResvInfoManageServiceImpl extends EgovAbstractServiceImpl implements ResvInfoManageService {
	
	@Autowired
	ResvInfoManageMapper resvMapper;
	
	@Override
	public List<Map<String, Object>> selectResInfoManageListByPagination(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		params.forEach((key, value)
			    -> System.out.println("key: " + key + ", value: " + value));
		
		
		return resvMapper.selectResInfoManageListByPagination(params);
	}
	
	@Override
	public Map<String, Object> selectResInfoDetail(String resvSeq) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.selectResInfoDetail(resvSeq);
	}
	
	@Override
	public Map<String, Object> selectUserLastResvInfo(String userId) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.selectUserLastResvInfo(userId);
	}
	
	@Override
	public Map<String, Object> selectUserResvInfo(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.selectUserResvInfo(params);
	}

	@Override
	public int updateUserResvInfo(ResvInfo vo) throws Exception {
		// TODO Auto-generated method stub
		return vo.getMode().equals("Ins") ? resvMapper.insertUserResvInfo(vo) : resvMapper.updateUserResvInfo(vo);
	}
	
	@Override
	public Map<String, Object> selectInUserResvInfo(ResvInfo vo) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.selectInUserResvInfo(vo);
	}
	
	@Override
	public Map<String, Object> selectResvQrInfo(String resvSeq) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.selectResvQrInfo(resvSeq);
	}
	
	@Override
	public int checkUserResvInfo(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.checkUserResvInfo(params);
	}
	
	@Override
	public String selectResvUserId(String resvSeq) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.selectResvUserId(resvSeq);
	}
	
	@Override
	public String selectResvEntryDvsn(String resvSeq) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.selectResvEntryDvsn(resvSeq);
	}
	
	@Override
	public List<Map<String, Object>> selectUserMyResvInfo(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.selectUserMyResvInfo(params);
	}
	
	@Override
	public Map<String, Object> selectGuestMyResvInfo(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.selectGuestMyResvInfo(params);
	}
	
	@Override
	public int resPriceChange(ResvInfo vo) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.resPriceChange(vo);
	}
	
	@Override
	public int resvInfoCancel(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.resvInfoCancel(params);
	}
	
	@Override
	public String resvValidCheck(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		params.put("resultCode", "");
		params.put("resvDate", "");
		
		resvMapper.resvValidCheck(params);
		
		if(!params.get("resultCode").equals("SUCCESS")) {
			for(reservation resv : reservation.values()) {
				if(resv.getCode().equals(params.get("resultCode"))) {
					params.put("resultMessage", resv.getName());
				}
			}
		}
		
		return "";
	}
	
	@Override
	public String selectFindPassword(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.selectFindPassword(paramMap);
	}

	@Override
	public int resbillChange(ResvInfo vo) throws Exception {
		// TODO Auto-generated method stub
		return resvMapper.resbillChange(vo);
	}
}