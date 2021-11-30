package com.kses.backoffice.bas.menu.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MenuCreatInfo {

    /** 메뉴번호 */
    private   String   menuNo;
    /** 맵생성ID */
    private   String   mapCreatId;
    /** 권한코드 */
    private   String   authorCode;
}
