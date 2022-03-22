$.Holyday = function() {
    this._editoptions = {
        value: 'Y:사용;N:사용안함'
    };
};

$.Holyday.prototype.mainGridSettings = function() {
    MainGridAjaxUrl = '/backoffice/bld/centerHolyInfoListAjax.do';
    EgovJqGridApi.mainGrid([
        { label: '지점휴일시퀀스', name: 'center_holy_seq', key: true, hidden: true },
        { label: '휴일일자', name: 'holy_dt', align: 'center', sortable: false },
        { label: '휴일명', name: 'holy_nm', align: 'center', sortable: false, editable: true },
        { label: '사용여부', name: 'use_yn', align: 'center', sortable: false, formatter: 'select', editable: true,  edittype: 'select', editoptions: this._editoptions
        },
    ], false, false, fnSearch, false).jqGrid('setGridParam', {
        cellEdit: true,
        cellsubmit: 'clientArray'
    });
    $('#rightAreaBtn').hide();
};

$.Holyday.prototype.updateSettings = function(ajaxUpdate, changedArr) {
    ajaxUpdate.title = '휴일관리 수정';
    ajaxUpdate.url = '/backoffice/bld/centerHolyInfoListUpdate.do';
    changedArr.forEach(x => ajaxUpdate.params.push({
        holyNm: x.holy_nm,
        useYn: x.use_yn,
        centerHolySeq: x.center_holy_seq
    }));
};

$.Holyday.prototype.centerCopy = function(ajaxCopy) {
    ajaxCopy.title = '지점휴일 복사';
    ajaxCopy.url = '/backoffice/bld/centerHolyInfoCopy.do';  	
};
const Holyday = new $.Holyday();