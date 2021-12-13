package com.kses.backoffice.cus.kko.vo;

import java.util.HashMap;
import java.util.Map;


public class kkoMessageInfo {

	public Map<String, String> tourMsg(String _dayGubun, Map<String, Object> vo ) {
		Map<String, String> returnMsg = new HashMap<String, String>();
		String title = "";
		String resMessage = "";
		String templeCode = "";
		String buttonJson = "";
		switch (_dayGubun) {
		    case  "RES":
		    	title = "[서울관광플라자]";
		    	resMessage = "[서울관광플라자]\r\n\r\n" +
		    	         "안녕하세요. 서울관광플라자입니다.\r\n\r\n"+
		    	         "서울관광플라자 정기투어를 신청해주셔서 감사드리며,\r\n\r\n"+
		    	         "아래와 같이 투어 일정이 확정되었음을 안내드립니다.\r\n\r\n"+
	    			     "- 일시: "+ vo.get("visited_resday") +"\r\n" + 
	    			     "- 신청자: "+ vo.get("visited_req_name")+"\r\n" + 
	    			     "- 신청인원: "+vo.get("visited_person")+"분\r\n\r\n" + 
	    			     "문의 또는 일정 변경/취소를 희망하실 경우 02-3788-8172로 연락 바랍니다.\r\n\r\n"+
	    			     "감사합니다.";
		    	templeCode = "stptr01";
		    	break;
		    case  "REM":
		    	title = "[서울관광플라자]";
		    	resMessage = "[서울관광플라자]\r\n\r\n" +
		    	         "안녕하세요. 서울관광플라자입니다.\r\n\r\n"+
		    	         "아래와 같이 서울관광플라자 투어 사전 안내드립니다.\r\n\r\n"+
		    	         "- 일시: "+ vo.get("visited_resday") +"\r\n" + 
	    			     "- 장소: 서울특별시 종로구 청계천로85 (31빌딩) 서울관광플라자 1층 \r\n" + 
	    			     "*1층 로비 내 구형 미디어(지구본) 앞에서 집결.\r\n"+
	    			     "**위치 자세히보기: http://naver.me/xZDP7BYK\r\n\r\n"+
	    			     "※ 투어는 정각에 진행되므로, 반드시 시간을 준수하여 주시기 바랍니다.\r\n"+
	    			     "※ 투어 시 여러팀이 함께 동행하는 점 양해 바랍니다.\r\n"+
	    			     "※ 일정 변경 및 취소를 희망하실 경우, 02-3788-8172로 연락 바랍니다.";
		    	templeCode = "stptr02";
		    	break;
		    case  "STA":
		    	title = "[서울관광플라자]";
		    	resMessage = "[서울관광플라자]\r\n\r\n" +
		    	         "안녕하세요. 서울관광플라자입니다.\r\n\r\n"+
		    	         "금일 서울관광플라자 투어가 진행될 예정이며, 아래와 같이 안내드립니다.\r\n\r\n"+
		    	         "- 일시: "+ vo.get("visited_resday") +"\r\n" + 
	    			     "- 장소: 서울특별시 종로구 청계천로85 (31빌딩) 서울관광플라자 1층 \r\n" + 
	    			     "*1층 로비 내 구형 미디어(지구본) 앞에서 집결.\r\n"+
	    			     "**위치 자세히보기: http://naver.me/xZDP7BYK\r\n\r\n"+
	    			     "※ 투어는 정각에 진행되므로, 반드시 시간을 준수하여 주시기 바랍니다.\r\n"+
	    			     "※ 투어 시 여러팀이 함께 동행하는 점 양해 바랍니다.\r\n"+
	    			     "※ 일정 변경 및 취소를 희망하실 경우, 02-3788-8172로 연락 바랍니다.";
		    	templeCode = "stptr03";
		    	break;
		    case  "COV":
		    	title = "[서울관광플라자]";
		    	resMessage = "[서울관광플라자]\r\n\r\n" +
		    	         "안녕하세요. 서울관광플라자입니다.\r\n\r\n"+
		    	         "사회적 거리두기 격상에 따라\r\n"+
		    	         " "+ vo.get("visited_resday") +" 예정된 투어가 취소됨을 안내드립니다. \r\n\r\n"+
		    	         "이점 많은 양해 부탁드리며, 정기투어 재신청을 희망하실 경우 번거로우시겠지만 신규 신청서 작성을 부탁드립니다.\r\n\r\n"+
	    			     "건강 조심하시고 다음 기회에 뵐 수 있기를 바라겠습니다.\r\n\r\n"+
		    	         "감사합니다.";
		    	templeCode = "stptr04";
		    	break;
		  
		    case  "CAN":
		    	title = "[서울관광플라자]";
		    	resMessage = "[서울관광플라자]\r\n\r\n" +
		    	         "안녕하세요. 서울관광플라자입니다.\r\n\r\n"+
		    	         "서울관광플라자 건물 내 코로나19 확진자 발생에 따라 추가 확산 방지 목적으로 "+ vo.get("visited_resday") +" 예정된 투어가 취소됨을 안내드립니다.\r\n\r\n"+
		    	         "이점 많은 양해 부탁드리며, 정기투어 재신청을 희망하실 경우 번거로우시겠지만 신규 신청서 작성을 부탁드립니다.\r\n\r\n"+
	    			     "건강 조심하시고 다음 기회에 다시 뵐 수 있기를 바라겠습니다.\r\n\r\n"+
		    	         "감사합니다.";
		    	templeCode = "stptr05";
		    	break;
		}
		returnMsg.put("title", title);
		returnMsg.put("resMessage", resMessage);
		returnMsg.put("templeCode", templeCode);
		returnMsg.put("buttonJson", buttonJson);
		return returnMsg;
		
	}
	
	public Map<String, String> visitedMsg(String _dayGubun, Map<String, Object> vo ) {
		Map<String, String> returnMsg = new HashMap<String, String>();
		String title = "";
		String resMessage = "";
		String templeCode = "";
		String buttonJson = "";
		switch (_dayGubun) {
		    case  "RES":
		    	title = "[방문 예약 승인 요청]";
		    	resMessage = "[방문 예약 승인 요청]\r\n\r\n" +
		    	         "아래와 같이 방문 예약 신청이 있습니니다.\r\n"+
		    	         "확인 후 방문승인 요청드립니다.\r\n\r\n"+
	    			     "- 일시: "+ vo.get("visited_resday") +"\r\n" + 
	    			     "- 목적: "+ vo.get("visited_purpose")+"\r\n" + 
	    			     "- 신청자: "+vo.get("visited_req_name")+"\r\n\r\n" + 
	    			     "감사합니다.";
		    	templeCode = "stpvr01";
		    	buttonJson = "";
		    	break;
		    case  "REQ":
		    	title = "[방문 예약 승인 요청]";
		    	resMessage = "[방문 예약 승인 요청]\r\n\r\n" +
		    	         "아래와 같이 방문 예약 신청이 있습니니다.\r\n"+
		    	         "확인 후 방문승인 요청드립니다.\r\n\r\n"+
	    			     "- 일시: "+ vo.get("visited_resday") +"\r\n" + 
	    			     "- 목적: "+ vo.get("visited_purpose")+"\r\n" + 
	    			     "- 신청자: "+vo.get("visited_req_name")+"\r\n\r\n" + 
	    			     "감사합니다.";
		    	templeCode = "stpvr02";
		    	buttonJson = "";
		    	break;
		    case  "QRS":
		    	title = "[서울관광플라자]";
		    	resMessage = "[서울관광플라자]\r\n\r\n" +
		    	         "안녕하세요. 서울관광플라자입니다.\r\n"+
		    	         "아래와 같이 방문 예약 완료되었습니다.\r\n\r\n"+
	    			     "- 일시: "+ vo.get("visited_resday").toString() +"\r\n" + 
	    			     "- 신청자: "+ vo.get("visited_req_name")+"\r\n" + 
	    			     "- 담당자: "+vo.get("empname")+"\r\n\r\n" + 
	    			     "감사합니다.";
		    	templeCode = "stpvr03";
		    	buttonJson = "{\"button\":[{\"name\":\"QR 받기\",\"type\":\"WL\",\"url_pc\":\"\", \r\n" + 
		    			"\"url_mobile\":\"https://room.visitseoul.net/web/visitedQr.do?visitedCode="+vo.get("visited_code")+"\"}]}";
		    	
		    	
		    	break;
		    case  "ARR":
		    	title = "[도착알림]";
		    	resMessage = "[도착알림]\r\n\r\n" +
		    	         "방문 예약자가 서울관광플라자에 도착하였습니다.\r\n\r\n"+
		    	         "- 신청자: "+vo.get("visited_req_name")+"\r\n" + 
	    			     "- 연락처: "+ vo.get("visited_req_celphone")+"\r\n\r\n" + 
	    			     "감사합니다.";
		    	templeCode = "stpvr04";
		    	buttonJson = "";
		    	break;
		    case  "CAN":
		    	title = "[서울관광플라자]";
		    	resMessage = "[서울관광플라자]\r\n\r\n" +
		    	         "안녕하세요. 서울관광플라자입니다. \r\n"+
		    	         "요청주신 방문 예약 신청이 아래의 사유로 거절되었습니다.\r\n\r\n"+
	    			     "- 일시: "+ vo.get("visited_resday") +"\r\n" + 
	    			     "- 신청자: "+vo.get("visited_req_name")+"\r\n" +
	    			     "- 담당자: "+ vo.get("empname")+"\r\n" + 
	    			     "- 사유: "+ vo.get("cancel_reason")+"\r\n\r\n" + 
	    			     "감사합니다.";
		    	templeCode = "stpvr05";
		    	buttonJson = "";
		    	break;
		
		}
		returnMsg.put("title", title);
		returnMsg.put("resMessage", resMessage);
		returnMsg.put("buttonJson", buttonJson);
		returnMsg.put("templeCode", templeCode);
		
		return returnMsg;
	}
	
	
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
		    	templeCode = "stpre03";
		    	break;
		    // 신규 작성 
		    case "COV" : 
		    	resMessage = "[서울관광플라자]\r\n"+
		    	             "안녕하세요. 서울관광플라자입니다.\r\n" + 
		        		     "\r\n" + 
		        		     "사회적 거리두기 격상에 따라\r\n" + 
		        		     "예정된 대관이 취소됨을 안내드립니다. \r\n" + 
		        		     "\r\n" + 
			    			 "- 시설명: "+vo.get("itme_name")+"\r\n" + 
			    			 "- 행사명: "+ vo.get("res_title") +"\r\n" + 
			    			 "- 신청자: "+ vo.get("empname") +"님\r\n" + 
			    			 "- 일시: "+vo.get("resstartday")+" "+vo.get("resstarttime")+"~"+vo.get("resendday")+" "+vo.get("resendtime")+
		    	             "  ※. 대관료 환불 예정\r\n"+
		    	             "\r\n" + 
		    	             "  향후 사회적 거리두기 단계 완화 시 대관 정책은 별도 문의 부탁드립니다.\r\n"+
		    	             "\r\n" +
		    	             "감사합니다.";
		    	templeCode = "stpre04";
		    	break;
		    case "EMP" : 
		    	resMessage = "[서울관광플라자]\r\n"+
		    	             "안녕하세요. 서울관광플라자입니다.\r\n" + 
		        		     "\r\n" + 
		        		     "사회적 거리두기 격상에 따라\r\n" + 
		        		     "예정된 대관이 취소됨을 안내드립니다. \r\n" + 
		        		     "\r\n" + 
			    			 "- 시설명: "+vo.get("itme_name")+"\r\n" + 
			    			 "- 행사명: "+ vo.get("res_title") +"\r\n" + 
			    			 "- 신청자: "+ vo.get("empname") +"님\r\n" + 
			    			 "- 일시: "+vo.get("resstartday")+" "+vo.get("resstarttime")+"~"+vo.get("resendday")+" "+vo.get("resendtime")+
		    	             "  ※. 대관료 환불 예정\r\n"+
		    	             "\r\n" + 
		    	             "  향후 사회적 거리두기 단계 완화 시 대관 정책은 별도 문의 부탁드립니다.\r\n"+
		    	             "\r\n" +
		    	             "감사합니다.";
		    	templeCode = "stpre05";
		    	break;
		    //신규 작성 끝 부분 
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
