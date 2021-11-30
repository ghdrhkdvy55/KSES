package com.kses.backoffice.cus.kko.vo;

import java.util.HashMap;
import java.util.Map;

public class kkoMessageInfo {

	
	
	public Map<String, String> meetingMsg(String _dayGubun, Map<String, Object> vo ) {
		
		Map<String, String> returnMsg = new HashMap<String, String>();
		String title = "";
		String resMessage = "";
		String templeCode = "";
		
		
		switch (_dayGubun) {
		    case "RES" :
		    	title = "[회의실 예약완료 알림]";
		    	resMessage = "[회의실 예약완료 알림]\r\n" +
		    			     "- 회의명: "+ vo.get("res_title") +"\r\n" + 
		    			     "- 일   자: "+ vo.get("resstartday")+"\r\n" + 
		    			     "- 시   간: "+vo.get("resstarttime")+"분 ~ "+vo.get("resendtime")+"분\r\n" + 
		    			     "- 회의실: "+vo.get("itme_name")+"";
		    	templeCode = "stpmr01";
		    	break;
		  
		    case "DAY" : 
		    	title = "[회의 D-1 알림]";
		    	resMessage =  "[회의 D-1 알림]\r\n" +
		    			      "- 회의명: "+ vo.get("res_title") +"\r\n" + 
			    			  "- 일   자: "+ vo.get("resstartday")+"\r\n" + 
			    			  "- 시   간: "+vo.get("resstarttime")+"분 ~ "+vo.get("resendtime")+"분\r\n" + 
			    			  "- 회의실: "+vo.get("itme_name")+"";
		    	templeCode = "stpmr02";
		    	break;
		    case "STR" : 
		    	title = "[회의 시작 알림]";
		    	resMessage = "[회의 시작 알림]\r\n" +
		    			     "잠시후 '(회의명)"+ vo.get("res_title") +"가 시작될 예정입니다. 장소와 시간을 확인해 주세요!\r\n\r\n"+
			    			 "- 회의명: "+ vo.get("res_title") +"\r\n" + 
		    			     "- 일   자: "+ vo.get("resstartday")+"\r\n" + 
		    			     "- 시   간: "+vo.get("resstarttime")+"분 ~ "+vo.get("resendtime")+"분\r\n" + 
		    			     "- 회의실: "+vo.get("itme_name")+""+
		    	             "\r\n\r\n※. 입실시 입실확인 선택을 하지 않으실 경우 자원 회수될 수 있습니다.";
		    	templeCode = "stpmr03";
		    	break;
		    default :
		    	title = "[회의실 예약완료 알림]";
		    	resMessage = "[회의실 예약완료 알림]\r\n" +
		    			     "- 회의명: "+ vo.get("res_title") +"\r\n" + 
		    			     "- 일   자: "+ vo.get("resstartday")+"\r\n" + 
		    			     "- 시   간: "+vo.get("resstarttime")+"분 ~ "+vo.get("resendtime")+"분\r\n" + 
		    			     "- 회의실: "+vo.get("itme_name")+"";
		    	templeCode = "stpmr01";
		    	break;
		}
		returnMsg.put("title", title);
		returnMsg.put("resMessage", resMessage);
		returnMsg.put("templeCode", templeCode);
		
		return returnMsg;
	}
    public Map<String, String> coregMsg(String _ProcessGubun, Map<String, Object> vo ) {
		
		Map<String, String> returnMsg = new HashMap<String, String>();
		String title = "[서울관광플라자]";
		String resMessage = "";
		String templeCode = "";
		switch (_ProcessGubun) {
		    case "RES" :
		    	resMessage = "[서울관광플라자]\r\n"+
		    	             "안녕하세요. 서울관광플라자입니다.\r\n" + 
		    			     "\r\n" + 
		    			     "아래와 같이 서울관광플라자 시설대관 예약이 완료 되었음을 안내드립니다.\r\n" + 
			    			 "\r\n" + 
			    			 "- 시설명: "+vo.get("itme_name")+"\r\n" + 
			    			 "- 행사명: "+ vo.get("res_title") +"\r\n" + 
			    			 "- 신청자: "+ vo.get("empname") +"님\r\n" + 
			    			 "- 일시: "+vo.get("resstartday")+" "+vo.get("resstarttime")+"~"+vo.get("resendday")+" "+vo.get("resendtime")+ "\r\n" + 
			    			 "\r\n" + 
			    			 " ※ 대관 유의사항을 준수하여 행사를 준비해주시기 바랍니다.\r\n"+
			    			 " ※ 일정 변경 및 취소를 희망하실 경우, 02-3788-0808/leejw@sto.or.kr로 연락 바랍니다.\r\n" + 
			    			 "\r\n" + 
		    	             "감사합니다.";
		    	templeCode = "stpre01";
		    	break;
		    	
		    case "CAN" : 
		    	resMessage = "[서울관광플라자]\r\n"+ 
		    	             "안녕하세요. 서울관광플라자입니다.\r\n" + 
		    			     "\r\n" + 
		    			     "아래와 같이 서울관광플라자 시설대관이 취소 되었음을 안내드립니다.\r\n" + 
			    			 "\r\n" + 
			    			 "- 시설명: "+vo.get("itme_name")+"\r\n" + 
			    			 "- 행사명: "+ vo.get("res_title") +"\r\n" + 
			    			 "- 신청자: "+ vo.get("empname") +"님\r\n" + 
			    			 "- 일시: "+vo.get("resstartday")+" "+vo.get("resstarttime")+"~"+vo.get("resendday")+" "+vo.get("resendtime")+
		    	             "-취소사유:"+ vo.get("cancel_reason")+"\r\n" +
		    	             " ※문의사항이 있을 시 02-3788-0808/leejw@sto.or.kr로 연락 바랍니다.\r\n"+
		    	             "감사합니다.";
		    	templeCode = "stpre02";
		    	break;
		    case "REQ" : 
		    	resMessage = "[서울관광플라자]\r\n"+
		    	             "안녕하세요. 서울관광플라자입니다.\r\n" + 
		        		     "\r\n" + 
		        		     "요청하신 시설 대관관련하여 대관료 납부가 확인되지 않았음을 안내 드립니다.\r\n" + 
		        		     "\r\n" + 
		        		     "신청일 기준 7일이내 대관료 납부가 진행되지 않을경우, 예약 취소될 수 있습니다." + 
			    			 "\r\n" + 
			    			 "- 시설명: "+vo.get("itme_name")+"\r\n" + 
			    			 "- 행사명: "+ vo.get("res_title") +"\r\n" + 
			    			 "- 신청자: "+ vo.get("empname") +"님\r\n" + 
			    			 "- 일시: "+vo.get("resstartday")+" "+vo.get("resstarttime")+"~"+vo.get("resendday")+" "+vo.get("resendtime")+
		    	             " ※문의사항이 있을 시 02-3788-0808/leejw@sto.or.kr로 연락 바랍니다.\r\n"+
		    	             "감사합니다.";
		    	
		    	break;
		    default :
		    	resMessage = "[서울관광플라자]\r\n"+
	    	             "안녕하세요. 서울관광플라자입니다.\r\n" + 
	    			     "\r\n" + 
	    			     "아래와 같이 서울관광플라자 시설대관 예약이 완료 되었음을 안내드립니다.\r\n" + 
		    			 "\r\n" + 
		    			 "- 시설명: "+vo.get("itme_name")+"\r\n" + 
		    			 "- 행사명: "+ vo.get("res_title") +"\r\n" + 
		    			 "- 신청자: "+ vo.get("empname") +"님\r\n" + 
		    			 "- 일시: "+vo.get("resstartday")+" "+vo.get("resstarttime")+"~"+vo.get("resendday")+" "+vo.get("resendtime");
		    	templeCode = "stpmr01";
		    	break;
		}
		returnMsg.put("title", title);
		returnMsg.put("resMessage", resMessage);
		returnMsg.put("templeCode", templeCode);
		
		return returnMsg;
	}
}
