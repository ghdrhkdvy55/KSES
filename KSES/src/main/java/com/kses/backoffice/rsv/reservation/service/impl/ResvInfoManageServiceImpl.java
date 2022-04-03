package com.kses.backoffice.rsv.reservation.service.impl;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import lombok.extern.slf4j.Slf4j;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

@Slf4j
@Service
public class ResvInfoManageServiceImpl extends EgovAbstractServiceImpl implements ResvInfoManageService {
	
	@Autowired
	ResvInfoManageMapper resvMapper;

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
	public Map<String, Object> selectUserResvInfoFront(Map<String, Object> params) throws Exception {
		return resvMapper.selectUserResvInfoFront(params);
	}
	
	@Override
	public List<String> selectResvDateList(ResvInfo vo) throws Exception {
		return resvMapper.selectResvDateList(vo);
	}
	
	@Override
	public String selectResvSeqNext(String resvDate) throws Exception {
		return resvMapper.selectResvSeqNext(resvDate);
	}
	
	@Override
	public String selectCenterResvDate(String centerCd) throws Exception {
		return resvMapper.selectCenterResvDate(centerCd);
	}

	@Override
	public List<Map<String, Object>> selectCenterResvDateList(String centerCd) throws Exception {
		return resvMapper.selectCenterResvDateList(centerCd);
	}

	@Override
	public int insertUserLongResvInfo(ResvInfo vo) throws Exception {
		int ret = 0;
		
		try {
			resvMapper.insertUserLongResvInfo(vo);
			ret = 1;
		} catch (Exception e) {
			ret = -1;
		}
		return ret; 
	}
	
	@Override
	public int insertLongResvInfo(ResvInfo vo) throws Exception {
		return resvMapper.insertLongResvInfo(vo);
	}
	
	@Override
	public int updateUserResvInfo(ResvInfo vo) throws Exception {
		return vo.getMode().equals(Globals.SAVE_MODE_INSERT) ? resvMapper.insertUserResvInfo(vo) : resvMapper.updateUserResvInfo(vo);
	}
	
	@Override
	public Map<String, Object> selectInUserResvInfo(ResvInfo vo) throws Exception {
		return resvMapper.selectInUserResvInfo(vo);
	}
	
	@Override
	public String selectAutoPaymentResvInfo(String userId) throws Exception {
		return resvMapper.selectAutoPaymentResvInfo(userId);
	}
	
	@Override
	public Map<String, Object> selectResvBillInfo(String resvSeq) throws Exception {
		return resvMapper.selectResvBillInfo(resvSeq);
	}
	
	@Override
	public int selectResvDuplicate(Map<String, Object> params) throws Exception {
		return resvMapper.selectResvDuplicate(params);
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
	public int updateResvRcptInfo(ResvInfo vo) throws Exception {
		return resvMapper.updateResvRcptInfo(vo);
	}
	
	@Override
	public int updateResvPriceInfo(ResvInfo vo) throws Exception {
		return resvMapper.updateResvPriceInfo(vo);
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
			
			int changeResvPayCost = Integer.parseInt(SmartUtil.NVL(params.get("resvEntryPayCost"),"0")) + Integer.parseInt(SmartUtil.NVL(params.get("resvSeatPayCost"),"0"));
			if(cancelResvCenterPilotYn.equals("Y") && cancelResvPayCost != changeResvPayCost && cancelResvPayDvsn.equals("RESV_PAY_DVSN_2")) {
				// 1.이전 예약정보 취소
				resultMap = resvService.resvInfoAdminCancel(resvSeq, cardPw, true);
				if(!resultMap.get(Globals.STATUS).equals(Globals.STATUS_SUCCESS)) {
					resultMap.addAttribute("resvSeq", resvSeq);
					return resultMap;
				}
				
				// 2.신규 예약정보 생성
				String copyResvSeq = resvService.selectResvSeqNext(SmartUtil.NVL(resvInfo.get("resv_end_dt"),""));
				params.put("copyResvSeq", copyResvSeq);
				resultMap = resvService.updateResvInfoCopy(params);
				
				if(!resultMap.get(Globals.STATUS).equals(Globals.STATUS_SUCCESS)) {
					resultMap.addAttribute("resvSeq", resvSeq);
					resultMap.addAttribute(Globals.STEP, "[예약등록]");
					return resultMap;
				}
				
				// 3.신규 예약정보 출금거래
				log.info("resvSeatChange : " + SmartUtil.NVL(resvInfo.get("resv_seq"),"") + "번 결제 시작");
				resultMap = interfaceService.SpeedOnPayMent(copyResvSeq, cardPw, true);
				if(!resultMap.get(Globals.STATUS).equals(Globals.STATUS_SUCCESS)) {
					resultMap.addAttribute("resvSeq", copyResvSeq);
					resultMap.addAttribute(Globals.STEP, "[출금거래]");
					return resultMap;
				}
			
				message = "정상적으로 좌석변경 되었습니다.<br>예약번호 : " + resvSeq + " -> " + copyResvSeq;
				resultMap.addAttribute("resvSeq", copyResvSeq);
				resultMap.addAttribute(Globals.STATUS, Globals.STATUS_SUCCESS);
				resultMap.addAttribute(Globals.STATUS_MESSAGE, message);	
			} else {
				int seatChangCount = resvMapper.updateResvSeatInfo(params);
				if(seatChangCount > 0) {
					resultMap.addAttribute("resvSeq", resvSeq);
					resultMap.addAttribute(Globals.STATUS, Globals.STATUS_SUCCESS);
					resultMap.addAttribute(Globals.STATUS_MESSAGE, "비시범 지점 또는 변경 좌석과 금액정보가 동일하여 기존 예약정보에서 좌석정보만 변경되었습니다.");
				} else {
					message = "기존 예약정보 변경중 오류가 발생하였습니다.";
					throw new Exception();
				}
				return resultMap;
			}
		} catch(Exception e) {
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
				sureService.insertResvSureData(Globals.SMS_TYPE_RESV, params.get("copyResvSeq").toString());
			} else {
				throw new Exception();
			}	
		} catch(Exception e) {
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
	public Map<String, Object> selectQrDuplicate(Map<String, Object> params) throws Exception {
		return resvMapper.selectQrDuplicate(params);
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
							log.info("예약번호 : " + resvSeq + " 결제취소실패");
							log.info("에러코드 : " + result.get(Globals.STATUS));
							log.info("에러메세지 : " + result.get(Globals.STATUS_MESSAGE));
							
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
						resvService.updateResvPriceInfo(resInfo);
					}
				} 
				
				params.put("resv_seq", resvSeq);
				params.put("resv_cancel_id", loginVO.getAdminId());
				params.put("resv_cancel_cd", "RESV_CANCEL_CD_1");
				if(resvService.resvInfoCancel(params) > 0) {
					resultMap.put(Globals.STATUS, Globals.STATUS_SUCCESS);
					resultMap.put(Globals.STATUS_MESSAGE, "예약정보가 정상적으로 취소되었습니다.");
					sureService.insertResvSureData(Globals.SMS_TYPE_CANCEL, resvSeq);
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
}