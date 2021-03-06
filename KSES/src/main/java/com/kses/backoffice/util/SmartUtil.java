package com.kses.backoffice.util;

import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.stream.Collectors;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.lang.reflect.Array;

import javax.imageio.ImageIO;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageConfig;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.kses.backoffice.sym.log.service.InterfaceInfoManageService;
import com.kses.backoffice.sym.log.vo.InterfaceInfo;
import com.kses.backoffice.sym.log.vo.sendEnum;

import egovframework.rte.fdl.property.EgovPropertyService;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;



@Service
public class SmartUtil {
	private static final Logger LOGGER = LoggerFactory.getLogger(SmartUtil.class);
	
	@Autowired
	protected EgovPropertyService propertiesService;
	
    public static InterfaceInfoManageService interfaceService;

	@Autowired
    private void InterfaceInfoManageService(InterfaceInfoManageService interfaceService) {
        this.interfaceService = interfaceService;
    }
	
	public void XMLParse(String xmlData) throws ParserConfigurationException, SAXException, IOException{
		InputSource is = new InputSource(new StringReader(xmlData));
		
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder documentBuilder = factory.newDocumentBuilder();
		Document doc = documentBuilder.parse(is);
		Element root = doc.getDocumentElement();
		NodeList chideren = root.getChildNodes();
		
		for (int i = 0; i < chideren.getLength(); i ++){
			Node node = chideren.item(i);
			if (node.getNodeType() == Node.ELEMENT_NODE){
				Element ele = (Element)node;
				String nodeName = ele.getNodeName();
				if(nodeName.equals("")) {
					
				} else {
					
				}
			}
		}		
	}
	
	/*
	 *  ????????? ??????
	 * 
	 */
	public static String reqDay( int _number  ){
		LocalDate now = LocalDate.now();
		String dayFormat = _number == 0  ? now.format(DateTimeFormatter.ofPattern("yyyyMMdd")) :  now.plusDays(_number).format((DateTimeFormatter.ofPattern("yyyyMMdd")));
		return  dayFormat;
	}
	
	/*
	 *  ?????? ??? ????????? ??????  ??? ????????? 
	 *  ?????? ??? ??????, ?????? ??? ?????? ?????? 
	*/
    public static String reqEndDay(String _day){
    	//String day = LocalDate.parse("20181211", DateTimeFormatter.BASIC_ISO_DATE).with(TemporalAdjusters.firstDayOfMonth()).format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		String dayFormat = LocalDate.parse(_day, DateTimeFormatter.BASIC_ISO_DATE).with(TemporalAdjusters.lastDayOfMonth()).format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		
		return  dayFormat;
	}
    /*
     *  ?????? ????????? ?????? ?????? ??? ?????? ?????? ?????? 
     */
    public static String timeCheck(String _timeDate) {
    	LocalDateTime now = LocalDateTime.now();
    	//String formatedNow = now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
		LocalDateTime date = LocalDateTime.parse(_timeDate, DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
		Duration duration = Duration.between(now, date);
		return  String.valueOf(duration.getSeconds());
    }
    
    /*
     *  ?????? ??????
     * 
     * 
     */
    public static String nowTime() {
    	LocalDateTime now = LocalDateTime.now();
    	return now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }
    /*
     *  qr ?????? 
     *  path ????????? ?????? ?????? 
     */
    public static String getQrCode(String path, String data, int width, int height, String file_nm){
		
		LOGGER.debug("path : " + path);
		LOGGER.debug("data : " + data);
		LOGGER.debug("visit_id : " + file_nm);
		
		try {
            File file = null;
            // ?????????????????? ????????? ???????????? ??????
            file = new File(path);
            if(!file.exists()) {
                file.mkdirs();
            }
            //qr???????????????
            
            // ??????????????? ????????? ?????? (url??? ?????? ?????? )
            String codeurl = new String(data.getBytes("UTF-8"), "ISO-8859-1");
            // ???????????? ????????? ?????????
          
            int qrcodeColor =   0xff000000;
//            #000000
            // ???????????? ???????????????
            int backgroundColor = 0xFFFFFFFF;
             
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            // 3,4?????? parameter??? : width/height??? ??????
            BitMatrix bitMatrix = qrCodeWriter.encode(codeurl, BarcodeFormat.QR_CODE, width, height);
            //
            MatrixToImageConfig matrixToImageConfig = new MatrixToImageConfig(qrcodeColor,backgroundColor);
            BufferedImage bufferedImage = MatrixToImageWriter.toBufferedImage(bitMatrix,matrixToImageConfig);
            // ImageIO??? ????????? ????????? ????????????
            ImageIO.write(bufferedImage, "png", new File(path + "/" + file_nm + ".png" ));
        } catch (Exception e) {
        	data = "FAIL";
        	LOGGER.error("getQrCode ERROR" + e.toString());
        }  
		
		return data;
	}
	
    public static String timeView(String _time){
		return _time.length() ==4 ? _time.substring(0,2)+":"+_time.substring(2,4) : "";
	}
	
    //?????? ?????? ????????? ????????? 	
	public static String calView (int _year, int _month, int day, String _gubun){
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.set(_year, _month-1, day);
		
		if(_gubun.equals("pre")) {
			cal.add(Calendar.MONTH, -1);
		} else if (_gubun.equals("nxt")) {
			cal.add(Calendar.MONTH, 1);
		}
		
		String now_Month = String.valueOf(cal.get(Calendar.MONTH)+1);
		
        /*String fYMD =  String.valueOf(cal.getMinimum(Calendar.DAY_OF_MONTH));
        int w = cal.get(Calendar.WEEK_OF_MONTH);
        String lYMD = String.valueOf(cal.getMaximum(Calendar.DAY_OF_MONTH));*/
        
        //?????? ?????? 
        cal.set(Calendar.DATE, 1);
        int w = cal.get(Calendar.DAY_OF_WEEK);        
        String lYMD = String.valueOf(cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        
        // ?????? ?????? ???       
        StringBuilder sb = new StringBuilder();
        sb.append("<table class='data_cal'>");
        sb.append(" <caption>??????</caption>");
        sb.append(" <thead>");
        sb.append("   <tr>");
        sb.append("   <td><a href='javascript:cal_change(&#34;pre&#34;)'><</a></td>");
        sb.append("   <td colspan='5'>"+now_Month+"???</td>");
        sb.append("   <td><a href='javascript:cal_change(&#34;nxt&#34;)'>></a></td>");
        sb.append("   </tr>");        
        sb.append("   <tr>");
        sb.append("     <th>???</th> ");
        sb.append("     <th>???</th> ");
        sb.append("     <th>???</th> ");
        sb.append("     <th>???</th> ");
        sb.append("     <th>???</th> ");
        sb.append("     <th>???</th> ");
        sb.append("     <th>???</th> ");
        sb.append("   </tr>");
        sb.append(" </thead>");
        sb.append(" <tbody>");

        sb.append("<tr>");

        for (int i = 1; i < w; i++)
        { // 6?????? 1?????? ??????????????? w=7 ????????? ?????? 6?????? ?????????.
            sb.append("<td></td>");
        }

        String fc;
        String _res_remark = null;
        String _res_day_ck = null;
        //?????? ?????? ?????? 
        _year = cal.get(Calendar.YEAR);
		//?????? ?????? ?????? ??? ?????? 
        int meeting_count = 0;
        for (int i = 1; i <= Integer.parseInt(lYMD); i++)
        {
            fc = w % 7 == 1 ? "red" : (w % 7 == 0 ? "blue" : "black");
            if (i == day)
            {
                sb.append("<td id='cal_"+ String.valueOf(_year) + day_format(now_Month) + day_format(String.valueOf(i))+"' style='color:" + fc + ";' class='today' onclick='javascript:day_change(&#39;" + String.valueOf(_year) + day_format(now_Month) + day_format(String.valueOf(i)) + "&#39;)'>");
            } 
            else
            {
                sb.append("<td id='cal_"+String.valueOf(_year) + day_format(now_Month) + day_format(String.valueOf(i))+"' style='color:" + fc + ";' onclick='javascript:day_change(&#39;" + String.valueOf(_year) + day_format(now_Month) + day_format(String.valueOf(i)) + "&#39;)'>");
            }
            
            sb.append("<span>"+i+"</span></td>");
            _res_remark = "";
            meeting_count = 0;
            w++;

            if (w % 7 == 1 && i != Integer.parseInt(lYMD))
            {
                sb.append("</tr>");
                sb.append("<tr>");
            }
        }
        if (w % 7 != 1)
        {
            if (w % 7 == 0)
            {
                sb.append("<td></td>");
            }
            else
            {
                for (int i = w % 7; i <= 7; i++)
                    sb.append("<td></td>");
            }
        }
        sb.append(" </tbody>");
        sb.append("</table>");
        return sb.toString();
	}
    private static String day_format(String _date)
    {
        return (_date.length() == 1) ? "0" + _date : _date;
    }
    
    //null or empty ??????
    public static String NVL(String _val, String _replace) {
    	return _val.isEmpty() ? _replace : _val;
    }
    
    public static String NVL(Object _val, String _replace) {
    	return _val == null ? _replace : StringUtils.isBlank(_val.toString()) ? _replace : _val.toString();
    }
    
    public static int NVL(Object _val, int _replace) {
    	return _val == null ? _replace : Integer.valueOf( _val.toString());
    }
	
    public static List<String> dotToList (String _dotlist) {
    	return !_dotlist.equals("") ?  Arrays.asList(_dotlist.split("\\s*,\\s*")) : null;
    }
    
    //?????? ?????? ??? ?????? ?????? 
    public static String checkItemList(List<String> _arrayList, String _nowVal, String _newVal) {
    	String itemList = "";
    	if (_arrayList.size()>0) {
    		
    		List list = _arrayList.stream().filter(e ->  !e.startsWith(_nowVal)).collect(Collectors.toList()); 
    		if (!_newVal.isEmpty())
    	    	list.add(_newVal);
    		itemList = (String) list.stream().distinct().sorted().collect(Collectors.joining(","));
    	}
    	return itemList;
    	
    }
    
    /**
     *<pre>
     * ????????? ?????? String??? null??? ?????? &quot;&quot;??? ????????????.
     * &#064;param src null?????? ???????????? ?????? String ???.
     * &#064;return ?????? String??? null ?????? ?????? &quot;&quot;??? ?????? String ???.
     *</pre>
     */
    public static String nullConvert(Object src) {
		//if (src != null && src.getClass().getName().equals("java.math.BigDecimal")) {
		if (src != null && src instanceof java.math.BigDecimal) {
		    return ((BigDecimal)src).toString();
		}
	
		if (src == null || src.equals("null")) {
		    return "";
		} else {
		    return ((String)src).trim();
		}
    }
    public static String checkHtmlView(String strString) {
		String strNew = "";

		StringBuffer strTxt = new StringBuffer("");

		char chrBuff;
		int len = strString.length();

		for (int i = 0; i < len; i++) {
			chrBuff = (char) strString.charAt(i);

			switch (chrBuff) {
				case '<':
					strTxt.append("&lt;");
					break;
				case '>':
					strTxt.append("&gt;");
					break;
				case '"':
					strTxt.append("&quot;");
					break;
				case 10:
					strTxt.append("<br>");
					break;
				case ' ':
					strTxt.append("&nbsp;");
					break;
				case '&' :
					strTxt.append("&amp;");
				break;
				default:
					strTxt.append(chrBuff);
			}
		}

		strNew = strTxt.toString();

		return strNew;
	}
    
    /*
	 *  ?????? ?????? 
	 *  strTitle ,  strMessage, sendEmail, sendName, recMail
	 * 
	 */
	public boolean sendMail ( String  strTitle, String strMessage, String sendEmail , String sendName,  String recMail )throws Exception {
		
		boolean sendMailResult = false;
		
	    Properties props = System.getProperties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.port", Integer.valueOf(25));
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.auth", "true");

        Session session = Session.getDefaultInstance(props);
        MimeMessage mine_msg = new MimeMessage(session);
        mine_msg.setFrom(new InternetAddress(sendEmail, sendName));
        mine_msg.setRecipient(Message.RecipientType.TO, new InternetAddress(recMail  ));
        mine_msg.setSubject(strTitle);
        mine_msg.setContent(strMessage, "text/html;charset=euc-kr");

        Transport transport = session.getTransport();
        
        try
        {
          transport.connect(this.propertiesService.getString("smtpIp"), this.propertiesService.getString("smtpUser"), this.propertiesService.getString("smtpPwd"));
          transport.sendMessage(mine_msg, mine_msg.getAllRecipients());
          sendMailResult = true;
        }
        catch (Exception ex) {
        	LOGGER.error("sendMail ERROR:" + ex.toString());
        } finally {
          transport.close();
        }
        
        return sendMailResult;
	}
	
	/*
	 *   ?????? ?????? ????????? ?????? ??????
	 *  
	 */
	public int sendSMS(String strTitle, String msg, String sendMail,  String sendName,  String empMail, String mailCheck,
			           String emphandphone, String sendHandphone,  String smsCheck, String smsMsg) throws Exception {
		
		
		
		int ret = 0;
		try {
			
			if (mailCheck.equals("Y")){
				sendMail(strTitle, msg, sendMail, sendName, empMail);
			}
		
			if (smsCheck.equals("Y") && NVL(emphandphone, "").indexOf("-") > 0) {
				    /*
				    MailInfo mail = new MailInfo();
					mail.setMemberName(info.getEmpname());
					mail.setMsg(smsMsg);
			
					String[] destel = info.getEmphandphone().split("-");
					mail.setDestel1(destel[0].toString());
					mail.setDestel2(destel[1].toString());
					mail.setDestel3(destel[2].toString());
					String[] srctel = sendHandphone.split("-");
					mail.setSrctel1(srctel[0].toString());
					mail.setSrctel2(srctel[1].toString());
					mail.setSrctel3(srctel[2].toString());
					try{
					     ret = this.smsMapper.SmsInsertInfo(mail);
					} catch (Exception e1) {
					   LOGGER.error("e1" + e1.toString());
					}
				   */
			  }
		} catch (Exception e){
			LOGGER.error(" sendSMS ERROR:" + e.toString());
		}
		
		return ret;
	} 
	/*
	 *  ibats ???????????? ????????????   
	 * 
	 */
	public static boolean isEmpty(Object obj) {
		if (obj instanceof String ) return obj == null || "".equals(obj.toString().trim());
		else if (obj instanceof List) return obj == null || ((List)obj).isEmpty();
		else if (obj instanceof Map) return obj == null || ((Map)obj).isEmpty();
		else if (obj instanceof Object[]) return obj == null || Array.getLength(obj) == 0;
		else return obj == null;
		
	}

	//fomr  ?????? ??????
	public JsonNode requestHttpForm(String _url, Map<String, String> _sendInfos) {
        HttpClient client = HttpClientBuilder.create().build();
        HttpPost httpPost = new HttpPost(_url);

        try {
            List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(1);
            /*
            for (Map.Entry<String, String> entry : _sendInfos.entrySet()) {
                nameValuePairs.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
            }
            */
            _sendInfos.forEach((key, value)  -> 
                               nameValuePairs.add(new BasicNameValuePair(key ,value)));
            
            //headers.forEach((key, value) -> map.put(key, Collections.unmodifiableList(value));
            		
            httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

            HttpResponse response = client.execute(httpPost);
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode node = null;
            if (response.getStatusLine().getStatusCode() == 200) {
                ResponseHandler<String> handler = new BasicResponseHandler();
                String body = handler.handleResponse(response);
                System.out.println("[RESPONSE] requestHttpForm() " + body);

                node = objectMapper.readTree(body);
            } else {
            	LOGGER.error("response is error:" + response.getStatusLine().getStatusCode());
                node = objectMapper.readTree("{\"ERROR CODE\":\""+ response.getStatusLine().getStatusCode() + "\"}");
            }
            return node;
        } catch (IOException e) {
            LOGGER.error("requestHttpForm IOException requestHttpForm : " + e.toString());
        }

        return null;
    }
	
	/*   json ????????? ??? ?????? ?????? 
	 *   _url : ?????? URL
	 *   _jsonInfo : ?????? Json
	 *   _integId : ?????? ID
	 *   _provdId : ?????? ID
	 *   _requstId : ?????? ID
	 * 
	 */
	
	public static JsonNode requestHttpJson(String _url, String _jsonInfo, String _integId, String _provdId, String _requstId){

        HttpClient client = HttpClientBuilder.create().build(); // HttpClient ??????
        HttpPost httpPost = new HttpPost(_url); //POST ????????? URL ??????
        try {
            httpPost.setHeader("Accept", "application/json");
            httpPost.setHeader("Connection", "keep-alive");
            httpPost.setHeader("Content-Type", "application/json");

            httpPost.setEntity(new StringEntity(_jsonInfo, "UTF-8")); //json ????????? ??????
            LOGGER.debug(_jsonInfo.toString());
            HttpResponse response = client.execute(httpPost);
            
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode node = null;
            //Response ??????
            
            InterfaceInfo info = new InterfaceInfo();
            info.setTrsmrcvSeCode(sendEnum.RPQ.getCode() );
            info.setIntegId(_integId);
            
            info.setRequstInsttId(_requstId);
            info.setRspnsRecptnTm(nowTime());
            
            if (response.getStatusLine().getStatusCode() == 200) {
                ResponseHandler<String> handler = new BasicResponseHandler();
                String body = handler.handleResponse(response);
                node = objectMapper.readTree(body);       
            } else {
            	LOGGER.error("response is error : " + response.getStatusLine().getStatusCode());
            	node = objectMapper.readTree("{\"Error_Cd\":\""+ response.getStatusLine().getStatusCode() + "\"}");
            }
            
            //?????? ?????? & ?????? ?????? 
            info.setRspnsRecptnTm(nowTime());
            info.setResultCode(node.get("Error_Cd").asText());
            info.setResultMessage(node.toString());
            info.setSendMessage(_jsonInfo);
            info.setRqesterId("SYSTEM");
            interfaceService.InterfaceInsertLoginLog(info);
            
            return node;
        } catch (Exception e) {
        	LOGGER.error("requestHttpJson Exception ERROR : " + e.toString());
        }

        return null;
    }
	
	public static String getSmsName(Map<String, Object> resvInfo) throws Exception {
		String userNm = NVL(resvInfo.get("resv_user_nm"),"");
		String userPhNum = NVL(resvInfo.get("resv_user_clphn"),"");
		
		return userNm.charAt(0) + "00" + userPhNum.substring(userPhNum.length()-4, userPhNum.length());
	}
	
	public static String[] getSplitPhNum(String phNum) throws Exception {
		String[] splitPhNumArray = new String[3];
		
		if(phNum.length() >= 9 && phNum.length() <= 12) {
			if(phNum.length() == 11) {
				splitPhNumArray[0] = phNum.substring(0, 3);
				splitPhNumArray[1] = phNum.substring(3, 7);
				splitPhNumArray[2] = phNum.substring(7, 11);
			} else {
				splitPhNumArray[0] = phNum.substring(0, 3);
				splitPhNumArray[1] = phNum.substring(3, 6);
				splitPhNumArray[2] = phNum.substring(6, 10);
			}
		} else {
			LOGGER.info("???????????? ?????? ?????????????????? ??????");
			throw new Exception();
		}
		
		return splitPhNumArray;
	}
	
	
	/**
	 * ???????????? ???????????? ????????? ??????(???????????? ?????? ???????????? SHA-256 ????????? ?????? ??????)
	 * 
	 * @param data ???????????? ????????????
	 * @param salt Salt
	 * @return ???????????? ????????????
	 * @throws Exception
	 */
	public static String encryptPassword(String data, String encryptType) {
		byte[] hashValue = null; // ?????????
		MessageDigest md;
		
		try {

			md = MessageDigest.getInstance(encryptType);
			md.reset();

			hashValue = md.digest(data.getBytes());

		} catch (NoSuchAlgorithmException e) {
			LOGGER.error("encryptPassword NoSuchAlgorithmException ERROR : " + e.toString());
		}
		
		return new String(Base64.encodeBase64(hashValue)); 
	}
	
	/**
	 * SPDM?????? ????????? ?????? ???????????? ????????? ??????
	 * 
	 * @param a_origin
	 * @return
	 */
	public static String getEncryptSHA256(String a_origin) {
		String encryptedSHA256 = "";
		MessageDigest md;
		
		try {
			md = MessageDigest.getInstance("SHA-256");
			md.update(a_origin.getBytes(), 0, a_origin.length());
			encryptedSHA256 = new BigInteger(1, md.digest()).toString(16);
		} catch (NoSuchAlgorithmException e) {
			LOGGER.error("getEncryptSHA256 NoSuchAlgorithmException ERROR : " + e.toString());
		}
		
		return encryptedSHA256;
	}
}