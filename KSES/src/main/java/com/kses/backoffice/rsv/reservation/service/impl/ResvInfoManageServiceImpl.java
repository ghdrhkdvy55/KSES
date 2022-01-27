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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

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
	public String selectResvSeqNext() throws Exception {
		return resvMapper.selectResvSeqNext();
	}

	@Override
	public int updateUserResvInfo(ResvInfo vo) throws Exception {
		return vo.getMode().equals("Ins") ? resvMapper.insertUserResvInfo(vo) : resvMapper.updateUserResvInfo(vo);
	}
	
	@Override
	public int updateLongResvInfo(ResvInfo vo) throws Exception {
		return vo.getMode().equals("Ins") ? resvMapper.insertLongResvInfo(vo) : resvMapper.updateLongResvInfo(vo);
	}
	
	@Override
	public int updateUserLongResvInfo(ResvInfo vo) throws Exception {
		int ret = 0;
		
		try {
			if(vo.getMode().equals("Ins")) {
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
	public Map<String, Object> selectResvBillInfo(String resvSeq) throws Exception {
		return resvMapper.selectResvBillInfo(resvSeq);
	}
	
	@Override
	public int resvInfoDuplicateCheck(Map<String, Object> params) throws Exception {
		return resvMapper.resvInfoDuplicateCheck(params);
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
	public int updateResvState(ResvInfo vo) throws Exception {
		return resvMapper.updateResvState(vo);
	}
	
	@Override
	public int resPriceChange(ResvInfo vo) throws Exception {
		return resvMapper.resPriceChange(vo);
	}
	
	@Override
	public int updateResvSeatInfo(Map<String, Object> params) throws Exception {
		return resvMapper.updateResvSeatInfo(params);
	}
	
	@Override
	public ModelMap resvSeatChange(Map<String, Object> params) throws Exception {
		ModelMap resultMap = new ModelMap();
		String message = "처리중 오류가 발생하였습니다.";
		String resvSeq = SmartUtil.NVL(params.get("resvSeq"),"");
		String cardPw = SmartUtil.NVL(params.get("cardPw"),"");
		
		try {			
			Map<String, Object> resvInfo = resvService.selectUserResvInfo(params);
			int cancelResvPayCost = Integer.parseInt(SmartUtil.NVL(resvInfo.get("resv_pay_cost"),""));
			String cancelResvPayDvsn = SmartUtil.NVL(resvInfo.get("resv_pay_dvsn"),"");
			String cancelResvCenterPilotYn = SmartUtil.NVL(resvInfo.get("center_pilot_yn"),"Y");
			
			int changeResvPayCost = Integer.parseInt(SmartUtil.NVL(params.get("resvEntryPayCost"),"")) + Integer.parseInt(SmartUtil.NVL(params.get("resvSeatPayCost"),""));
			if(cancelResvCenterPilotYn.equals("Y") && cancelResvPayCost != changeResvPayCost && cancelResvPayDvsn.equals("RESV_PAY_DVSN_2")) {
				// 1.이전 예약정보 취소
				resultMap = resvService.resvInfoAdminCancel(resvSeq, cardPw, true);
				if(!resultMap.get(Globals.STATUS).equals(Globals.STATUS_SUCCESS)) {
					return resultMap;
				}
				
				// 2.신규 예약정보 생성
				String copyResvSeq = resvService.selectResvSeqNext();
				params.put("copyResvSeq", copyResvSeq);
				resultMap = resvService.updateResvInfoCopy(params);
				
				LOGGER.info("original : " + resvSeq);
				LOGGER.info("new : " + copyResvSeq);
				if(!resultMap.get(Globals.STATUS).equals(Globals.STATUS_SUCCESS)) {
					resultMap.addAttribute(Globals.STEP, "[예약등록]");
					return resultMap;
				}
				
				// 3.신규 예약정보 출금거래
				resultMap = interfaceService.SpeedOnPayMent(copyResvSeq, cardPw, true);
				if(!resultMap.get(Globals.STATUS).equals(Globals.STATUS_SUCCESS)) {
					resultMap.addAttribute(Globals.STEP, "[출금거래]");
					return resultMap;
				}
			
			} else {
				int seatChangCount = resvMapper.updateResvSeatInfo(params);
				if(seatChangCount > 0) { 
					resultMap.addAttribute(Globals.STATUS, Globals.STATUS_SUCCESS);
					resultMap.addAttribute(Globals.STATUS_MESSAGE, "비시범 지점 또는 변경 좌석과 금액정보가 동일하여 기존 예약정보에서 좌석정보만 변경되었습니다.");
				} else {
					message = "기존 예약정보 변경중 오류가 발생하였습니다.";
					throw new Exception();
				}
				return resultMap;
			}
		} catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			LOGGER.error(e.toString() + ":" + ste[0].getLineNumber());
			resultMap.addAttribute(Globals.STATUS, Globals.STATUS_FAIL);
			resultMap.addAttribute(Globals.STATUS_MESSAGE, message);	
		}

		return resultMap;
	}
	
	@Override
	public ModelMap updateResvInfoCopy(Map<String, Object> params) throws Exception {
		ModelMap resultMap = new ModelMap();
		String message = "신규 예약정보 등록중 오류가 발생하였습니다.";
		try {
			
			if(resvMapper.updateResvInfoCopy(params) > 0) {
				resultMap.addAttribute(Globals.STATUS, Globals.STATUS_SUCCESS);
				resultMap.addAttribute(Globals.STATUS_MESSAGE, "신규 예약정보 등록 완료");
				sureService.insertResvSureData("RESERVATION", params.get("copyResvSeq").toString());
			} else {
				throw new Exception();
			}	
		} catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			LOGGER.error(e.toString() + ":" + ste[0].getLineNumber());
			resultMap.addAttribute(Globals.STATUS, Globals.STATUS_FAIL);
			resultMap.addAttribute(Globals.STATUS_MESSAGE, message);	
		}
		return resultMap;
	}	
	
	@Override
	public int updateResvUseComplete() throws Exception {
		return resvMapper.updateResvUseComplete();
	}
	
	@Override
	public int updateResvQrCount(String resvSeq) throws Exception {
		return resvMapper.updateResvQrCount(resvSeq);
	}
	
	@Override
	public Map<String, Object> resvQrDoubleCheck(Map<String, Object> params) throws Exception {
		return resvMapper.resvQrDoubleCheck(params);
	}
	
	@Override
	public int resvInfoCancel(Map<String, Object> params) throws Exception {
		return resvMapper.resvInfoCancel(params);
	}
		
	@Override
	public ModelMap resvInfoAdminCancel(String resvSeq, String cardPw, boolean isPassword) throws Exception {
		ModelMap resultMap = new ModelMap();
		ResvInfo resInfo = new ResvInfo();
		String message = "처리중 오류가 발생하였습니다.";
		String step = "";
		
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
						ModelMap result = interfaceService.SpeedOnPayMentCancel(resvSeq, cardPw, isPassword);
						if(!SmartUtil.NVL(result.get(Globals.STATUS), "").equals("SUCCESS")) {
							LOGGER.info("예약번호 : " + resvSeq + " 결제취소실패");
							LOGGER.info("에러코드 : " + result.get(Globals.STATUS));
							LOGGER.info("에러메세지 : " + result.get(Globals.STATUS_MESSAGE));
							
							step = "[거래취소]";
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
					step = "[예약취소]";
					message = "예약취소중 오류가 발생하였습니다.";
					throw new Exception();
				}
			} else {
				step = "[예약취소]";
				message = resvState.equals("RESV_STATE_3") ? "이미 이용완료 처리된 예약 정보입니다." : "이미 취소된 예약 정보입니다.";
				throw new Exception();
			}
		} catch(Exception e) {
			StackTraceElement[] ste = e.getStackTrace();
			LOGGER.error(e.toString() + ":" + ste[0].getLineNumber());
			resultMap.put(Globals.STEP, step);
			resultMap.put(Globals.STATUS, Globals.STATUS_FAIL);
			resultMap.put(Globals.STATUS_MESSAGE, message);	
		}
	     	
		return resultMap;
	}
	
	@Override
	public void resvValidCheck(Map<String, Object> params) throws Exception {
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
	}
	
	@Override
	public int resvBillChange(ResvInfo vo) throws Exception {
		return resvMapper.resvBillChange(vo);
	}
	
	@Override
	public Map<String, Object> selectTicketMchnSnoCheck(Map<String, Object> params) {
		return resvMapper.selectTicketMchnSnoCheck(params);
	}
}