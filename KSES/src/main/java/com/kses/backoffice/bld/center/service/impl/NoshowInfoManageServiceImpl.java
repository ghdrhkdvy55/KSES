package com.kses.backoffice.bld.center.service.impl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.kses.backoffice.bld.center.mapper.NoshowInfoManageMapper;
import com.kses.backoffice.bld.center.service.NoshowInfoManageService;
import com.kses.backoffice.bld.center.vo.NoshowInfo;
import com.kses.backoffice.cus.kko.service.SureManageSevice;
import com.kses.backoffice.cus.usr.service.UserInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.NoShowHisInfo;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;
import com.kses.backoffice.util.SmartUtil;

@Service
public class NoshowInfoManageServiceImpl extends EgovAbstractServiceImpl implements NoshowInfoManageService {
	private static final Logger LOGGER = LoggerFactory.getLogger(NoshowInfoManageServiceImpl.class);
	
	@Autowired
	NoshowInfoManageMapper noshowMapper;
	
	@Autowired
	private SureManageSevice sureService;
	
	@Autowired
	private UserInfoManageService userService;
	
	@Override
	public List<Map<String, Object>> selectNoshowInfoList(String centerCd) throws Exception {
		return noshowMapper.selectNoshowInfoList(centerCd);
	}
	
	@Override
	public List<Map<String, Object>> selectNoshowResvInfo_R1() throws Exception {
		return noshowMapper.selectNoshowResvInfo_R1();
	}
	
	@Override
	public List<Map<String, Object>> selectNoshowResvInfo_R2() throws Exception {
		return noshowMapper.selectNoshowResvInfo_R2();
	}
	
	@Override
	public int insertNoshowResvInfo(NoShowHisInfo noshowHisInfo) throws Exception {
		return noshowMapper.insertNoshowResvInfo(noshowHisInfo);
	}

	@Override
	public int updateNoshowResvInfoTranCancel(ResvInfo resvInfo) throws Exception {
		return noshowMapper.updateNoshowResvInfoTranCancel(resvInfo);
	}
	
	@Override
	public int updateNoshowInfo(List<NoshowInfo> noshowInfoList) throws Exception {
		return noshowMapper.updateNoshowInfo(noshowInfoList);
	}

	@Override
	public int copyNoshowInfo(Map<String, Object> params) throws Exception {
		return noshowMapper.copyNoshowInfo(params);
	}
	
	@Override
	@Transactional(propagation=Propagation.REQUIRES_NEW, rollbackFor=Exception.class)
	public boolean updateNoshowResvInfoTran(Map<String, Object> params) throws Exception {
		int resultCount = 0;
		String userId = SmartUtil.NVL(params.get("user_id"),"");
		String resvSeq = SmartUtil.NVL(params.get("resv_seq"),"");
		String noshowCd = SmartUtil.NVL(params.get("noshow_cd"),"");
		
		try {
			NoShowHisInfo noshowHisInfo = new NoShowHisInfo();
			ResvInfo resvInfo = new ResvInfo();
			noshowHisInfo.setUserId(userId);
			noshowHisInfo.setNoshowCd(noshowCd);
			noshowHisInfo.setResvSeq(resvSeq);
			resultCount = noshowMapper.insertNoshowResvInfo(noshowHisInfo);
			userService.updateUserNoshowCount(userId);
			
			if(resultCount > 0) {
				LOGGER.info("예약번호 : " + resvSeq + " 노쇼 정보 등록성공");
				resvInfo.setResvSeq(resvSeq);
				resultCount = noshowMapper.updateNoshowResvInfoTranCancel(resvInfo);
				if(resultCount > 0) {
					LOGGER.info("예약번호 : " + resvSeq + " 예약 정보 취소성공");
					sureService.insertResvSureData("CANCEL", resvSeq);
				} else {
					resultCount = 0;
					LOGGER.info("예약번호 : " + resvSeq + " 예약 정보 취소실패");
					throw new Exception();
				}
			} else {
				LOGGER.info("예약번호 : " + resvSeq + " 노쇼 정보 등록실패");
				throw new Exception();
			}
		} catch (Exception e) {
			LOGGER.info("예약번호 : " + resvSeq + " 예외발생 트랜잭션 실행");
		}
		
		return resultCount > 0 ? true : false;
	}
}