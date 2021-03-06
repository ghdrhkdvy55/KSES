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
		String message = "????????? ????????? ?????????????????????.";
		String resvSeq = SmartUtil.NVL(params.get("resvSeq"),"");
		String cardPw = SmartUtil.NVL(params.get("cardPw"),"");
		
		try {			
			Map<String, Object> resvInfo = resvService.selectUserResvInfo(params);
			int cancelResvPayCost = Integer.parseInt(SmartUtil.NVL(resvInfo.get("resv_pay_cost"),""));
			String cancelResvPayDvsn = SmartUtil.NVL(resvInfo.get("resv_pay_dvsn"),"");
			String cancelResvCenterPilotYn = SmartUtil.NVL(resvInfo.get("center_pilot_yn"),"Y");
			
			int changeResvPayCost = Integer.parseInt(SmartUtil.NVL(params.get("resvEntryPayCost"),"")) + Integer.parseInt(SmartUtil.NVL(params.get("resvSeatPayCost"),""));
			if(cancelResvCenterPilotYn.equals("Y") && cancelResvPayCost != changeResvPayCost && cancelResvPayDvsn.equals("RESV_PAY_DVSN_2")) {
				// 1.?????? ???????????? ??????
				resultMap = resvService.resvInfoAdminCancel(resvSeq, cardPw, true);
				if(!resultMap.get(Globals.STATUS).equals(Globals.STATUS_SUCCESS)) {
					resultMap.addAttribute("resvSeq", resvSeq);
					return resultMap;
				}
				
				// 2.?????? ???????????? ??????
				String copyResvSeq = resvService.selectResvSeqNext(SmartUtil.NVL(resvInfo.get("resv_end_dt"),""));
				params.put("copyResvSeq", copyResvSeq);
				resultMap = resvService.updateResvInfoCopy(params);
				
				if(!resultMap.get(Globals.STATUS).equals(Globals.STATUS_SUCCESS)) {
					resultMap.addAttribute("resvSeq", resvSeq);
					resultMap.addAttribute(Globals.STEP, "[????????????]");
					return resultMap;
				}
				
				// 3.?????? ???????????? ????????????
				LOGGER.info("resvSeatChange : " + SmartUtil.NVL(resvInfo.get("resv_seq"),"") + "??? ?????? ??????");
				resultMap = interfaceService.SpeedOnPayMent(copyResvSeq, cardPw, true);
				if(!resultMap.get(Globals.STATUS).equals(Globals.STATUS_SUCCESS)) {
					resultMap.addAttribute("resvSeq", copyResvSeq);
					resultMap.addAttribute(Globals.STEP, "[????????????]");
					return resultMap;
				}
			
				message = "??????????????? ???????????? ???????????????.<br>???????????? : " + resvSeq + " -> " + copyResvSeq;
				resultMap.addAttribute("resvSeq", copyResvSeq);
				resultMap.addAttribute(Globals.STATUS, Globals.STATUS_SUCCESS);
				resultMap.addAttribute(Globals.STATUS_MESSAGE, message);	
			} else {
				int seatChangCount = resvMapper.updateResvSeatInfo(params);
				if(seatChangCount > 0) {
					resultMap.addAttribute("resvSeq", resvSeq);
					resultMap.addAttribute(Globals.STATUS, Globals.STATUS_SUCCESS);
					resultMap.addAttribute(Globals.STATUS_MESSAGE, "????????? ?????? ?????? ?????? ????????? ??????????????? ???????????? ?????? ?????????????????? ??????????????? ?????????????????????.");
				} else {
					message = "?????? ???????????? ????????? ????????? ?????????????????????.";
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
		String message = "?????? ???????????? ????????? ????????? ?????????????????????.";
		try {
			
			if(resvMapper.updateResvInfoCopy(params) > 0) {
				resultMap.addAttribute(Globals.STATUS, Globals.STATUS_SUCCESS);
				resultMap.addAttribute(Globals.STATUS_MESSAGE, "?????? ???????????? ?????? ??????");
				sureService.insertResvSureData(Globals.SMS_TYPE_RESV, params.get("copyResvSeq").toString());
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
		String message = "????????? ????????? ?????????????????????.";
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
				//?????? ?????? ??????
				if(resvPayDvsn.equals("RESV_PAY_DVSN_2")) {
					if(resvTicketDvsn.equals("RESV_TICKET_DVSN_1")) {
						// ???????????? ??????(???????????? ???????????????)
						ModelMap result = interfaceService.SpeedOnPayMentCancel(resvSeq, cardPw, isPassword, true);
						if(!SmartUtil.NVL(result.get(Globals.STATUS), "").equals("SUCCESS")) {
							LOGGER.info("???????????? : " + resvSeq + " ??????????????????");
							LOGGER.info("???????????? : " + result.get(Globals.STATUS));
							LOGGER.info("??????????????? : " + result.get(Globals.STATUS_MESSAGE));
							
							step = "[????????????]";
							message = SmartUtil.NVL(result.get(Globals.STATUS_MESSAGE),"");
							throw new Exception();
						} 
					} else {
						//??????????????? ?????? ??????(??????)
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
					resultMap.put(Globals.STATUS_MESSAGE, "??????????????? ??????????????? ?????????????????????.");
					
					sureService.insertResvSureData(Globals.SMS_TYPE_CANCEL, resvSeq);
				} else {
					step = "[????????????]";
					message = "??????????????? ????????? ?????????????????????.";
					throw new Exception();
				}
			} else {
				step = "[????????????]";
				message = resvState.equals("RESV_STATE_3") ? "?????? ???????????? ????????? ?????? ???????????????." : "?????? ????????? ?????? ???????????????.";
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
}