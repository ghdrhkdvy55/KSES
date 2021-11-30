package com.kses.backoffice.sym.log.service;

import java.lang.reflect.Type;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;



import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

public class ParamToJson {

	private static final Logger LOGGER = LoggerFactory.getLogger(ParamToJson.class);
	
	/* 특정 키값 받아오기 */
	public static String JsonKeyToString (Object param, String Reqkey)   throws Exception {
		if (param == null || param == "") return "";
		String ReqValue = "";
		try{
			Gson gson = new GsonBuilder().setPrettyPrinting().create();
			Map<String, String>  map = gson.fromJson(gson.toJson(param), Map.class);
			map.values().removeAll(Collections.singleton(""));
			Iterator<String> keys = map.keySet().iterator();
			for( String key : map.keySet() ){
				Object object = map.get(key);
				if ( object instanceof Double){
					 map.put(key,  String.valueOf(   ((Double) object).intValue()  ) ) ;
				}
				//LOGGER.debug(key + ":" + Reqkey);
				if (key.equals(Reqkey)){
					ReqValue = object.toString();
					break;
				}
	        }   
			return ReqValue;
		}catch(Exception e){
	    	System.err.println("ERROR:" + e);
	    	return "";
	    }
		
	}
	public static String paramToJson (Object param)   throws Exception {
		 if (param == null || param == "") return "";
		 LOGGER.debug("param:" + param.toString());
		 if (param != null && param instanceof Number ) return param.toString();
		 if (param != null && param instanceof String ) return param.toString();
		 // 추후 form-data 를 json 형태로 수정 하기 
		 if (param != null && param.toString().contains("multipart") ) return param.toString();
		 try{
			 
			    LOGGER.debug("jsonGubun 시작");
			    Gson gson = new GsonBuilder().setPrettyPrinting().create();
			    //여기 부분 정확하게 정리 하기 
			    Boolean jsonGubun =  gson.toJson(param).trim().equals("},{") ? true : false;
			    LOGGER.debug("jsonGubun" + jsonGubun);
			    if(jsonGubun == false ){
			    	LOGGER.debug("JSON OBJECT");
			    	//json 일때
			    	Map<String, String>  map = gson.fromJson(gson.toJson(param), Map.class);
					map.values().removeAll(Collections.singleton(""));
					Iterator<String> keys = map.keySet().iterator();
					for( String key : map.keySet() ){
						Object object = map.get(key);
						if ( object instanceof Double){
							 map.put(key,  String.valueOf(   ((Double) object).intValue()  ) ) ;
						}
			        }   
					return  gson.toJson(map);
			    }else {
			    	//json object 일때
			    	LOGGER.debug("JSONArray");
			    	Type listType = new TypeToken<List<HashMap<String, String>>>(){}.getType();
					List<HashMap<String, String>> listInfo =  gson.fromJson(gson.toJson(param), listType);
					
					for(HashMap<String, String> map : listInfo){
						map.values().removeAll(Collections.singleton(""));
						Iterator<String> keys = map.keySet().iterator();
						for( String key : map.keySet() ){
							Object object = map.get(key);
							if ( object instanceof Double){
								 map.put(key,  String.valueOf(   ((Double) object).intValue()  ) ) ;
							}
				        }
					}
					return  gson.toJson(listInfo); 
			    }
		 }catch(Exception e){
			 LOGGER.debug("JSON 객체 아님:" + e);
		     return param.toString();
	    }
		
	}
}
