unit Thred_rc;

interface

resourcestring
    IDS_FSELB                = 'No border stiches';
    IDS_FSELF                = 'No fill stitches';
    IDS_FSELA                = 'No applique stitches';
    IDS_FSELM                = 'No stitches';
    IDS_SEL1FRM              = 'Select a form to use this function';
    IDS_PIKOL                = 'pick color';
    IDS_UPON                 = 'up to: on';
    IDS_UPOF                 = 'up to: off';
    IDS_FGRPF                = 'a form, a group of forms, or a group of stitches';
    IDS_ALL                  = 'all forms and stitches, a form,'#13'a group of forms, or a group of stitches';
    IDS_AUXTXT               = 'Open %s file';
    IDS_CPYRIT               = 'Thred Digitizing Program for Machine Embroidery'#13'(c)2000 Marion and Alfie McCoskey 1201 Locust Ave., Shasta Lake, CA'#13'All rights reserved'#13'Version: 3.092';
    IDS_PNT                  = 'Please enter the points for the %s';
    IDS_HUP0                 = 'Set Custom';
    IDS_HUP1                 = 'Small Pfaff';
    IDS_HUP2                 = 'Large Pfaff';
    IDS_HUP3                 = '100mm';
    IDS_HUP4                 = 'Custom';
    IDS_KEY                  = 'Thred, trial version'#13#13'You can register your copy of Thred at:'#13'http://www.Thredworks.com'#13#13;
    IDS_CLP                  = 'Clipboard data too small for clipboard fill';
    IDS_EXP                  = 'This key will expire in %d days';
    IDS_XPIRAD               = 'This key has expired';
    IDS_CNTR                 = 'Design re-centered';
    IDS_MAPLOD               = 'You must have a bitmap loaded'#13'to use the autotrace functions';
    IDS_FRMOVR               = 'Too many form points';
    IDS_ROTIN                = 'The rotate angle is tiny';
    IDS_SELC                 = 'You must select more than one form to center forms';
    IDS_NSEL                 = 'Nothing to select';
    IDS_CONT                 = 'A form must have at least five sides for the contour fill';
    IDS_ROTA                 = 'Please enter a rotate angle.'#13'The current value is: %.2f';
    IDS_FRM2                 = 'A form must have more than two sides'#13'for Convert to Satin Ribbon';
    IDS_FRML                 = 'Please enter a form number less than %d';
    IDS_FRM3                 = 'Can''t create a form with less than two points';
    IDS_STMAX                = 'Can''t convert more than 12,000 stitches';
    IDS_FRMN1                = 'Form number too large';
    IDS_COLU                 = 'Color in use';
    IDS_COLAL                = 'All colors used';
    IDS_MRK                  = 'Mark wasn''t set';
    IDS_FRMNO                = 'No forms';
    IDS_FRM2L                = 'Traced form too large';
    IDS_NOTHR                = 'Not a THR file';
    IDS_FNOPN                = 'Couldn''t open file: %s';
    IDS_REM1                 = 'To remove large stitches,'#13'set user stitch length less than maximum stitch length';
    IDS_DST1                 = 'The destination is within the move range';
    IDS_BAKDT                = 'Backups deleted';
    IDS_BAKDEL               = 'Deleting backups';
    IDS_FDEL                 = 'Delete form?';
    IDS_DELFRM               = 'Delete forms?';
    IDS_END                  = 'The End';
    IDS_INSF                 = 'To insert an entire file please select insert from the file menu';
    IDS_PFAF2L               = 'WARNING'#13'Design too large for Pfaff large hoop';
    IDS_DST2S                = 'Dst file header too short';
    IDS_BMAP                 = 'Thred only displays monochrome'#13'or 24 bit color bitmaps';
    IDS_SHOMAP               = 'No bitmap to save';
    IDS_MAPCHG               = 'Bitmap not changed';
    IDS_SAVMAP               = 'Save bitmap is only available for 24 bit color bitmaps';
    IDS_FILSTCH              = 'fill stitches';
    IDS_BRDSTCH              = 'border stitches';
    IDS_APSTCH               = 'applique stitches';
    IDS_FRMSEL               = 'form select %s';
    IDS_FRM1MSG              = 'a form';
    IDS_GRPMSG               = 'a group of stitches';
    IDS_ROTAGIN              = 'Rotate Again';
    IDS_SHOSEL               = 'Select %s'#13' to use %s';
    IDS_REGP                 = 'regular polygon';
    IDS_STAR                 = 'star';
    IDS_SPIR                 = 'spiral';
    IDS_HEART                = 'heart';
    IDS_LENS                 = 'lens';
    IDS_EGG                  = 'egg';
    IDS_CLPS                 = 'Put stitches on the clipboard to use this fill'#13'Select a form that is filled and hit control C'#13'or select a group of stitches and hit control C';
    IDS_FRM3X                = 'Can''t use this type of fill'#13'on a form with less than three points';
    IDS_ANGS                 = 'Please use the angle satin fill'#13'for a line form with only two points';
    IDS_FILSEL               = 'To use a fill,'#13' right click near a form point to select the form';
    IDS_FILCR                = 'To use a fill, create a form'#13'by selecting ""form"" on the main menu';
    IDS_FGRPS                = 'a group of stitches or a form';
    IDS_UNGRP                = 'ungroup';
    IDS_NOGRP                = 'Can''t find stitches for the selected form';
    IDS_NOHLP                = 'HTML Help is not available'#13'thred.chm needs to be in the same directory as thred.exe'#13'and Internet Explorer version 3.0 or greater'#13'needs to be installed on your computer';
    IDS_SAVDISC              = 'Save changes to %s';
    IDS_UNFIL                = 'Stitches in the form are edited, unfill anyway?';
    IDS_REFIL                = 'Stitches in the form are edited, refill anyway?';
    IDS_SNAP2GRD             = 'Snap to Grid';
    IDS_RETRAC               = 'Retrace';
    IDS_STCH_FRM             = 'a stich point or a form point';
    IDS_SETMRK               = 'Set Mark at Selected Point';
    IDS_FSZ                  = 'a form or a group of stitches'#13' and set the zoom mark';
    IDS_SETROTM              = 'Set Rotation Angle from Mark';
    IDS_RNGEND               = 'Set Range Ends For Clipboard Fills';
    IDS_ROT                  = 'Rotate';
    IDS_ROTCMD               = 'Rotate Command';
    IDS_CONVRIB              = 'Convert to Ribbon';
    IDS_ROTDUP               = 'Rotate and Duplicate';
    IDS_CROP                 = 'Crop';
    IDS_STCH2FRM             = 'Convert Stitches to Form';
    IDS_FRMGUID              = 'a form point with an interior satin guidline'#13'or a point in a line form';
    IDS_SPLT                 = 'Split Form';
    IDS_CENT                 = 'Center';
    IDS_SETFRM               = 'Set Form Number';
    IDS_FRMCLP               = 'a form with a clipboard border fill';
    IDS_SHRNK                = 'Shrink Clipboard Border';
    IDS_PRT                  = 'Partial file read';
    IDS_SHRTF                = 'File too short';
    IDS_TRC0                 = 'find edges';
    IDS_TRC1S                = 'show bmap';
    IDS_TRC2                 = 'rst frm pix';
    IDS_TRC3                 = 'sel colors';
    IDS_TRC4                 = 'show edges';
    IDS_TRC1H                = 'hide bmap';
    IDS_SRCH                 = 'search';
    IDS_NUMPNT               = 'pnt';
    IDS_NUMFRM               = 'frm';
    IDS_NUMSEL               = 'sel';
    IDS_NUMSCH               = 'sch';
    IDS_NUMFORM              = 'form';
    IDS_BOXSEL               = 'box select';
    IDS_RITER                = 'PCS file write error';
    IDS_SAVFIL               = 'Save File %s';
    IDS_CLOS                 = 'Closing Thred';
    IDS_TOT                  = 'tot %d';
    IDS_LAYR                 = 'layer %d';
    IDS_CREAT                = 'Couldn''t create file %s';
    IDS_FNOPNA               = 'Couldn''t open file %s'#13'Try closing Thred and opening the file again';
    IDS_NOTVER               = 'This THR file is a newer version'#13'than this copy of Thread can read.'#13'Please download the latest version'#13'of Thred from Thredworks.com to read this file';
    IDS_BADFIL               = 'Corrupted Thred file: %s';
    IDS_ZEROL                = 'Zero length file: %s';
    IDS_OVRLOK               = '%s is locked'#13'Overwrite anyway';
    IDS_OVRIT                = 'Overwrite locked file';
    IDS_FILROT               = 'File: %s was rotated';
    IDS_THRED                = 'Thred: %s';
    IDS_NUFIL                = 'nufil.thr';
    IDS_SIZ                  = 'Enter a new size for #%s thread'#13'The current size is %.2f millimeters';
    IDS_TRIAL                = 'Trial Version';
    IDS_EMB                  = 'Thred: Embird File Exchange';
    IDS_ON                   = 'on';
    IDS_OFF                  = 'off';
    IDS_FMEN                 = 'Line (E)'#13'Free Hand (F)'#13'Regular Polygon (R)'#13'Star (S)'#13'Spiral (A)'#13'Heart (H)'#13'Lens (L)'#13'Egg (G)'#13'Tear (T)'#13'Zig-Zag (Z)'#13'Wave (W)'#13'Daisy (D)';
    IDS_TXT0                 = 'Form';
    IDS_TXT1                 = 'Layer';
    IDS_TXT2                 = 'Fill';
    IDS_TXT3                 = 'Fill color';
    IDS_TXT4                 = 'Fill spacing';
    IDS_TXT5                 = 'Fill stitch length';
    IDS_TXT6                 = 'Fill Angle';
    IDS_TXT7                 = 'Border';
    IDS_TXT8                 = 'Border color';
    IDS_TXT9                 = 'Border spacing';
    IDS_TXT10                = 'Border stitch length';
    IDS_TXT11                = 'Border width';
    IDS_TXT12                = 'Applique color';
    IDS_TXT13                = 'BH corner';
    IDS_TXT14                = 'Start';
    IDS_TXT15                = 'End';
    IDS_TXT16                = 'Pico Spacing';
    IDS_TXT17                = 'Underlay';
    IDS_TXT18                = 'Fill phase';
    IDS_TXT19                = 'Chain Position';
    IDS_FIL0                 = 'None';
    IDS_FIL1                 = 'Vertical';
    IDS_FIL2                 = 'Horizontal';
    IDS_FIL3                 = 'Angle';
    IDS_FIL4                 = 'Fan';
    IDS_FIL5                 = 'Fan clip';
    IDS_FIL6                 = 'Contour';
    IDS_FIL7                 = 'Vrt clip';
    IDS_FIL8                 = 'Hor clip';
    IDS_FIL9                 = 'Ang clip';
    IDS_EDG0                 = 'None';
    IDS_EDG1                 = 'Line';
    IDS_EDG2                 = 'Bean';
    IDS_EDG3                 = 'Clipboard';
    IDS_EDG4                 = 'Ang Satin';
    IDS_EDG5                 = 'Applique';
    IDS_EDG6                 = 'Prp Satin';
    IDS_EDG7                 = 'BH';
    IDS_EDG8                 = 'Picot';
    IDS_EDG9                 = 'Double';
    IDS_EDG10                = 'Lin chain';
    IDS_EDG11                = 'Opn chain';
    IDS_PRF0                 = 'Fill spacing';
    IDS_PRF1                 = 'Fill angle';
    IDS_PRF2                 = 'Fill ends';
    IDS_PRF3                 = 'Border width';
    IDS_PRF4                 = 'Stitch length, maximum';
    IDS_PRF5                 = 'Stitch length, user';
    IDS_PRF6                 = 'Stitch length, minimum';
    IDS_PRF7                 = 'Grid cutoff';
    IDS_PRF8                 = 'Stitch box cutoff';
    IDS_PRF9                 = 'Small stitch size';
    IDS_PRF10                = 'Applique color';
    IDS_PRF11                = 'Snap to size';
    IDS_PRF12                = 'Star ratio';
    IDS_PRF13                = 'Spiral wrap';
    IDS_PRF14                = 'Button corner length';
    IDS_PRF15                = 'Satin form Ends';
    IDS_PRF16                = 'Picot spacing';
    IDS_PRF17                = 'Hoop Type';
    IDS_PRF18                = 'Hoop Width';
    IDS_PRF19                = 'Satin Underlay';
    IDS_PRF20                = 'Grid Size';
    IDS_PRF21                = 'Clipboard offset';
    IDS_PRF22                = 'Clipboard phase';
    IDS_PRF23                = 'Chain fill length';
    IDS_PRF24                = 'Chain fill position';
    IDS_PRF25                = 'Nudge';
    IDS_PRF26                = 'Egg ratio';
    IDS_PRF27                = 'Hoop Height';
    IDS_FRMPLUS              = 'frm+';
    IDS_FRMINUS              = 'frm-';
    IDS_OKENT                = 'OK=Enter or `';
    IDS_CANCEL               = 'Cancel';
    IDS_APCOL                = 'Applique color number has been set to %d';
    IDS_FREH                 = 'Free Hand';
    IDS_BLUNT                = 'Blunt';
    IDS_TAPR                 = 'Tapered';
    IDS_PNTD                 = 'Pointed';
    IDS_SQR                  = 'Square';
    IDS_DELST2               = 'Delete stitches too? (S to delete)';
    IDS_NCOLCHG              = '%d colors changed';
    IDS_SAV                  = 'Save';
    IDS_DISC                 = 'Discard';
    IDS_THRDBY               = 'Thred: %s by %s';
    IDS_STCHOUT              = 'WARNING'#13'Stitches outside of hoop'#13#13;
    IDS_STCHS                = 'Stitches: %d'#13'Stitch Width: %.2f mm, %.2f in'#13'Stitch Height: %.2f mm, %.2f in'#13#13;
    IDS_FORMS                = 'Forms: %d'#13'Forms Width: %.2f mm, %.2f in'#13'Forms Height: %.2f mm, %.2f in'#13#13;
    IDS_HUPWID               = 'Hoop Width: %.2f mm'#13'Hoop Height: %.2f mm'#13#13;
    IDS_CREATBY              = 'Created by: %s'#13'Modified by: %s';
    IDS_CUSTHUP              = 'Custom Hoop'#13'%.2f'#13'%.2f';
    IDS_STCHP                = 'Enter stitch point pixels'#13'currently: %d';
    IDS_FRMP                 = 'Enter form point pixels'#13'currently: %d';
    IDS_ENTROT               = 'Please enter rotate segments.'#13'The current value is: %.2f';
    IDS_NUDG                 = 'Enter nudge pixels'#13'currently: %d';
    IDS_NOSTCHSEL            = 'No stitch selected';
    IDS_ZIG                  = 'Zig-Zag';
    IDS_EDG12                = 'Even Clip';
    IDS_TXT20                = 'Max Fill Stitch';
    IDS_TXT21                = 'Min Fill Stitch';
    IDS_TXT22                = 'Max Border Stitch';
    IDS_TXT23                = 'Min Border Stitch';
    IDS_ALLX                 = 'all forms and stitches, a form,'#13'a group of forms, a group of form points,'#13' or a group of stitches';
    IDS_FTH0                 = 'Curve';
    IDS_FTH1                 = 'Curve2';
    IDS_FTH2                 = 'Line';
    IDS_FTH3                 = 'Ragged';
    IDS_FTH4                 = 'Ramp';
    IDS_FTH5                 = 'Picket';
    IDS_FIL10                = 'Feather';
    IDS_FTHCOL               = 'Feather color';
    IDS_FTHTYP               = 'Feather type';
    IDS_FTHBLND              = 'Feather Blend';
    IDS_FTHUP                = 'Feather up';
    IDS_FTHBOTH              = 'Feather both';
    IDS_FTHSIZ               = 'Feather size';
    IDS_FTHNUM               = 'Feather steps';
    IDS_FTHFLR               = 'Feather floor';
    IDS_FTHUPCNT             = 'Feather up count';
    IDS_FTHDWNCNT            = 'Feather down count';
    IDS_SETSTCH              = 'Left click to set stitches';
    IDS_P2CMSG               = 'Can''t locate PES2Card Software.'#13'Would you like to browse for'#13'Computerservice file: LinkP2C.exe?'#13;
    IDS_P2CTITL              = 'PES2Card Software Not Found';
    IDS_P2CNODAT             = 'No data to send to PES2Card';
    IDS_CLPSPAC              = 'Enter clipboard fill spacing'#13'currently: %.2f';
    IDS_CHANSMAL             = 'Chain stitch length too large for form';
    IDS_FSTRT                = 'Fill Start';
    IDS_FEND                 = 'Fill end';
    IDS_FORMP                = 'a form point';
    IDS_WLKIND               = 'Edge walk/underlay indent'#13'currently %.2f';
    IDS_WLKLEN               = 'Edge Walk/Underlay stitch length'#13'currently %.2f';
    IDS_UANG                 = 'Underlay angle'#13'currently %.2f';
    IDS_USPAC                = 'Underlay spacing'#13'currently %.2f';
    IDS_WALK                 = 'Edge walk';
    IDS_UWLKIND              = 'Indent';
    IDS_WLKCOL               = 'Edge walk color';
    IDS_UND                  = 'Underlay';
    IDS_UNDCOL               = 'Underlay color';
    IDS_ULEN                 = 'Underlay stitch length';
    IDS_FUANG                = 'Underlay angle';
    IDS_FUSPAC               = 'Underlay spacing';
    IDS_KEYVER               = 'This version of Thred is newer than your Thred key'#13#13;
    IDS_DAZCRV               = 'Curve';
    IDS_DAZSAW               = 'Side Point';
    IDS_DAZRMP               = 'Center Point';
    IDS_DAZRAG               = 'Ragged';
    IDS_DAZCOG               = 'Cog';
    IDS_CWLK                 = 'Center Walk';
    IDS_UCOL                 = 'Underlay Color';
    IDS_SETULEN              = 'Underlay Stitch Length';
    IDS_SRTER                = 'Color order error in form %d';
    IDS_SETUSPAC             = 'Underlay Spacing';
    IDS_SETUANG              = 'Underlay Angle';
    IDS_SETFLEN              = 'Stitch Length';
    IDS_SETFSPAC             = 'Spacing';
    IDS_SETFANG              = 'Angle';
    IDS_COL                  = 'Color';
    IDS_WID                  = 'Width';
    IDS_HI                   = 'Height';
    IDS_FRMBOX               = 'Form box pixels'#13'Currently %d';
    IDS_HSIZ                 = 'Hoop size changed to %d wide by %d high';
    IDS_DAZHART              = 'Mirror';
    IDS_CLEAR                = 'Clear';
    IDS_TXHI                 = 'hi: %.2f';
    IDS_TXWID                = 'wid: %.2f';
    IDS_TXSPAC               = 'spc: %.2f';
    IDS_TXVRT                = 'vert';
    IDS_TXHOR                = 'horz';
    IDS_TXANG                = 'angle';
    IDS_FIL11                = 'Vrt txtr';
    IDS_FIL12                = 'Hor txtr';
    IDS_FIL13                = 'Ang txt';
    IDS_TXOF                 = 'Texture offset';
    IDS_TXMIR                = 'mirror';
    IDS_BADFLT               = 'Form point data error'#13;
    IDS_BADCLP               = 'Clipboard data error'#13;
    IDS_BADSAT               = 'D-line data error'#13;
    IDS_BADTX                = 'Texture data error'#13;
    IDS_FRMDAT               = 'Form point';
    IDS_CLPDAT               = 'Clipboard';
    IDS_SATDAT               = 'D-line';
    IDS_TXDAT                = 'Texture';
    IDS_NOTREP               = 'data not repaired in %d forms'#13;
    IDS_DATREP               = 'Data Repaired';
    IDS_UNAM                 = 'Uknown Designer';


implementation

end.
