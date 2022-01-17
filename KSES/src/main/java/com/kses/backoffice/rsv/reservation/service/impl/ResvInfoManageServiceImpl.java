package com.kses.backoffice.rsv.reservation.service.impl;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kses.backoffice.cus.kko.service.SureManageSevice;
import com.kses.backoffice.rsv.reservation.mapper.ResvInfoManageMapper;
import com.kses.backoffice.rsv.reservation.service.ResvInfoManageService;
import com.kses.backoffice.rsv.reservation.vo.ResvInfo;
import com.kses.backoffice.rsv.reservation.vo.reservation;
import com.kses.backoffice.sym.log.service.InterfaceInfoManageService;
import com.kses.backoffice.util.SmartUtil;

@Service
public class ResvInfoManageServiceImpl extends EgovAbstractServiceImpl implements ResvInfoManageService {
	
	@Autowired
	ResvInfoManageMapper resvMapper;
	
    private static final Logger LOGGER = LoggerFactory.getLogger(ResvInfoManageServiceImpl.class);

    @Autowired
    EgovMessageSource egovMessageSource;
	
    @Autowired
    protected EgovPropertyService propertiesService;
	
	@Autowired
	private ResvInfoManageService resvService;
    
    @Autowired
    private InterfaceInfoManageService interfaceService;
    
	@Autowired
	private SureManageSevice sureService;
	
	@Override
	public List<Map<String, Object>> selectResvInfoManageListByPagination(Map<String, Object> params) throws Exception {
		params.forEach((key, value)
			    -> System.out.println("key: " + key + ", value: " + value));
		
		
		return resvMapper.selectResvInfoManageListByPagination(params);
	}
	
	@Override
	public Map<String, Object> selectResvInfoDetail(String resvSeq) throws Exception {
		return resvMapper.selectResvInfoDetail(resvSeq);
	}
	
	@Override
	public Map<String, Object> selectUserLastResvInfo(String userId) throws Exception {
		return resvMapper.selectUserLastResvInfo(userId);
	}
	
	@Override
	public Map<String, Object> selectUserResvInfo(Map<String, Object> params) throws Exception {
		return resvMapper.selectUserResvInfo(params);
	}
	
	@Override
	public List<String> selectResvDateList(ResvInfo vo) throws Exception {
		return resvMapper.selectResvDateList(vo);
	}

	@Override
	public int updateUserResvInfo(ResvInfo vo) throws Exception {
		return vo.getMode().equals(Globals.SAVE_MODE_INSERT) ? resvMapper.insertUserResvInfo(vo) : resvMapper.updateUserResvInfo(vo);
	}
	
	@Override
	public int updateLongResvInfo(ResvInfo vo) throws Exception {
		return vo.getMode().equals(Globals.SAVE_MODE_INSERT) ? resvMapper.insertLongResvInfo(vo) : resvMapper.updateLongResvInfo(vo);
	}
	
	@Override
	public int updateUserLongResvInfo(ResvInfo vo) throws Exception {
		int ret = 0;
		
		try {
			if(vo.getMode().equals(Globals.SAVE_MODE_INSERT)) {
				resvMapper.insertUserLongResvInfo(vo);
			} else {
				resvMapper.updateUserLongResvInfo(vo);
			}
			
			ret = 1;
		} catch (Exception e) {
			ret = -1;
		}

		return ret; 
	}
	
	@Override
	public Map<String, Object> selectInUserResvInfo(ResvInfo vo) throws Exception {
		return resvMapper.selectInUserResvInfo(vo);
	}
	
	@Override
	public int resvInfoDuplicateCheck(Map<String, Object> params) throws Exception {
		return resvMapper.resvInfoDuplicateCheck(params);
	}
	
	@Override
	public String selectResvUserId(String resvSeq) throws Exception {
		return resvMapper.selectResvUserId(resvSeq);
	}
	
	@Override
	public String selectResvEntryDvsn(String resvSeq) throws Exception {
		return resvMapper.selectResvEntryDvsn(resvSeq);
	}
	
	@Override
	public List<Map<String, Object>> selectUserMyResvInfo(Map<String, Object> params) throws Exception {
		return resvMapper.selectUserMyResvInfo(params);
	}
	
	@Override
	public List<Map<String, Object>> selectGuestMyResvInfo(Map<String, Object> params) throws Exception {
		return resvMapper.selectGuestMyResvInfo(params);
	}
	
	@Override
	public int resvStateChange(ResvInfo vo) throws Exception {
		return resvMapper.resvStateChange(vo);
	}
	
	@Override
	public int resPriceChange(ResvInfo vo) throws Exception {
		return resvMapper.resPriceChange(vo);
	}
	
	@Override
	public int resvSeatChange(Map<String, Object> params) throws Exception {
		return resvMapper.resvSeatChange(params);
	}
	
	@Override
	public int resvCompleteUse() throws Exception {
		return resvMapper.resvCompleteUse();
	}
	
	@Override
	public int resvQrCountChange(String resvSeq) throws Exception {
		return resvMapper.resvQrCountChange(resvSeq);
	}
	
	@Override
	public int resvInfoCancel(Map<String, Object> params) throws Exception {
		return resvMapper.resvInfoCancel(params);
	}
		
	@Override
	@SuppressWarnings("unchecked")
	public Map<String, String> resvInfoAdminCancel(String resvSeq) throws Exception {
		Map<String, String> resultMap = new HashMap<String, String>();
		
		ResvInfo resInfo = new ResvInfo();
		JSONObject jsonObject = new JSONObject();
		String message = "처리중 오류가 발생하였습니다.";
		
		try {
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("resvSeq", resvSeq);
			Map<String, Object> resvInfo = resvService.selectUserResvInfo(params);
			String resvState = resvInfo.get("resv_state").toString();
			String resvTicketDvsn = SmartUtil.NVL(resvInfo.get("resv_ticket_dvsn"),"");
			String resvPayDvsn = resvInfo.get("resv_pay_dvsn").toString();
			String tradeNo = SmartUtil.NVL(resvInfo.get("trade_no"),"");
			
			if(!resvState.equals("RESV_STATE_3") && !resvState.equals("RESV_STATE_4")) {
				//결제 유무 확인
				if(resvPayDvsn.equals("RESV_PAY_DVSN_2")) {
					if(resvTicketDvsn.equals("RESV_TICKET_DVSN_1")) {
						// 스피드온 결제(거래취소 인터페이스)
						jsonObject.put("Pw_YN", "N");
						jsonObject.put("resvSeq", resvSeq);
						Map<String, Object> result = interfaceService.SpeedOnCancelPayMent(jsonObject);
						if(!SmartUtil.NVL(result.get(Globals.STATUS), "").equals("SUCCESS")) {
							LOGGER.info("예약번호 : " + resvSeq + " 결제취소실패");
							LOGGER.info("에러코드 : " + result.get(Globals.STATUS));
							LOGGER.info("에러메세지 : " + result.get(Globals.STATUS_MESSAGE));
							message = SmartUtil.NVL(result.get(Globals.STATUS_MESSAGE),"");
							throw new Exception();
						} 
					} else {
						//무인발권기 결제 취소(현금)
						resInfo.setResvPayDvsn("RESV_PAY_DVSN_3");
						resInfo.setResvState("RESV_STATE_4");
						resInfo.setResvTicketDvsn("RESV_TICKET_DVSN_1");
						resInfo.setTradNo(tradeNo);
						resvService.resPriceChange(resInfo);
					}
				} 
				
				params.put("resv_seq", resvSeq);
				params.put("resv_cancel_id", loginVO.getAdminId());
				params.put("resv_cancel_cd", "RESV_CANCEL_CD_1");
				if(resvService.resvInfoCancel(params) > 0) {
					resultMap.put(Globals.STATUS, Globals.STATUS_SUCCESS);
					resultMap.put(Globals.STATUS_MESSAGE, "예약정보가 정상적으로 취소되었습니다.");
					
					sureService.insertResvSureData("CANCEL", resvSeq);
				} else {
					message = "예약취소중 오류가 발생하였습니다.";
					throw new Exception();
				}
			} else {
				message = resvState.equals("RESV_STATE_3") ? "이미 이용완료 처리된 예약 정보입니다." : "이미 취소된 예약 정보입니다.";
				throw new Exception();
			}
		} catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			LOGGER.error(e.toString() + ":" + ste[0].getLineNumber());
			resultMap.put(Globals.STATUS, Globals.STATUS_FAIL);
			resultMap.put(Globals.STATUS_MESSAGE, message);	
		}
	     	
		return resultMap;
	}
	
	@Override
	public String resvValidCheck(Map<String, Object> params) throws Exception {
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
		return resvMapper.selectFindPassword(paramMap);
	}

	@Override
	public int resbillChange(ResvInfo vo) throws Exception {
		return resvMapper.resbillChange(vo);
	}
	
	@Override
	public Map<String, Object> selectTicketMchnSnoCheck(Map<String, Object> params) {
		return resvMapper.selectTicketMchnSnoCheck(params);
	}
}