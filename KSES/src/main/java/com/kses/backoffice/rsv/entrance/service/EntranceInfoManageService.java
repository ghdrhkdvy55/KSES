package com.kses.backoffice.rsv.entrance.service;

import java.util.List;

public interface EntranceInfoManageService {

	List<?> selectEnterRegistList(String resvSeq) throws Exception;
}
