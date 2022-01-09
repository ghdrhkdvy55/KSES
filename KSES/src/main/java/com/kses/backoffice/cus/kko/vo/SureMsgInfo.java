package com.kses.backoffice.cus.kko.vo;

import java.util.Map;
import com.kses.backoffice.util.SmartUtil;

public class SureMsgInfo {
	public SureDataInfo resvSureDataMsg(String msgDvsn, Map<String, Object> resvInfo) throws Exception {
		SureDataInfo sureData = new SureDataInfo();
		String domain = "http://kses.kcycle.or.kr/front/qrEnter.do?";
		String msg = "";
		String templateCode = "";
		
		String buttonType = "";
		String buttonNm = "";
		String buttonUrl = "";
		
		String userDvsn = resvInfo.get("resv_user_dvsn").toString();
		String userNm = resvInfo.get("resv_user_nm").toString();
		String userPhNum = resvInfo.get("resv_user_clphn").toString();
		
		String centerPilotYn = resvInfo.get("center_pilot_yn").toString();
		String resvSeq = resvInfo.get("resv_seq").toString();
		String resvDate = resvInfo.get("resv_end_dt").toString();
		String centerNm = resvInfo.get("center_nm").toString();
		String seatNm = resvInfo.get("seat_nm").toString();
		
		if(msgDvsn.equals("RESERVATION")) {
			if(centerPilotYn.equals("Y")) {
                if(userDvsn.equals("USER_DVSN_1")) {
                	templateCode = "KSES_001";
                	
                	msg += "[ 회원 입장 신청 안내 ]\n";
                	
                	buttonType = "WL";
                	buttonNm = "QR링크";
                    buttonUrl = domain + "resvSeq=" + resvSeq + "&" + "accessType=BUTTON";
                } else {
                	templateCode = "KSES_002";
                	msg += "[ 비회원 입장 신청 안내 ]\n";
                }
				
                msg += SmartUtil.getSmsName(resvInfo) + "님 " + resvDate.substring(4,6) + "월 " + resvDate.substring(6,8) + "일 ";
                msg += centerNm + "지점 " + seatNm + "에 예약 완료되었습니다. ";
                msg += "(예약번호 : " + resvSeq + ")";
                
                msg += userDvsn.equals("USER_DVSN_1") ? "" : "\n예약한 영업장의 무인발권기에서 현금결제를 통해 종이QR입장권을 발급해주시기 바랍니다.";           
			} else {
				templateCode = "KSES_003";
				
				msg += SmartUtil.getSmsName(resvInfo) + "님 " + resvDate.substring(4,6) + "월 " + resvDate.substring(6,8) + "일 ";
                msg += centerNm + "지점 " + seatNm + "에 예약 완료되었습니다. ";
                msg += "(예약번호 : " + resvSeq + ")";
                
                buttonType = "WL";
            	buttonNm = "QR링크";
			    buttonUrl = domain + "resvSeq=" + resvSeq + "&" + "accessType=BUTTON";
			}
		} else if(msgDvsn.equals("CANCEL")) {
			templateCode = "KSES_004";
			msg += resvDate.substring(4,6) + "월 " + resvDate.substring(6,8) + "일  " + "입장취소 완료되었습니다.";
		}
		
		sureData.setCallname(userNm);
		sureData.setCallphone(userPhNum);
		sureData.setTemplatecode(templateCode);
		sureData.setMsg(msg);
		sureData.setBtnType01(buttonType);
		sureData.setBtnNm01(buttonNm);
		sureData.setBtnType01(buttonType);
		sureData.setBtn01Url01(buttonUrl);

		return sureData;
	}
}