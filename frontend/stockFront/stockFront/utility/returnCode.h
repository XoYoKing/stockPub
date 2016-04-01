//
//  returnCode.h
//  stockFront
//
//  Created by wang jam on 1/4/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#ifndef returnCode_h
#define returnCode_h


#define LOGIN_SUCCESS 1010
#define LOGIN_FAIL 1011
#define ERROR 1000
#define SUCCESS 1002

#define EXCEPTION -9998

#define REGISTER_SUCCESS 1020
#define REGISTER_FAIL 1021

#define PHONE_EXIST 1042
#define CERTIFICATE_CODE_SEND 1040
#define CERTIFICATE_CODE_SENDED 1041

#define CAR_BRAND_SUCCESS 1030
#define	CAR_BRAND_ERROR 1031



//附近的人 功能相关
#define NEARBY_SUCCESS 1100
#define NEARBY_FAIL 1101

//更新头像
#define UPDATE_FACE_SUCCESS 1070

//添加用户照片
#define ADD_IMAGE_SUCCESS 1050

//获取用户照片集
#define GET_IMAGE_SUCCESS 1060

//删除用户图片
#define DEL_IMAGE_SUCCESS 1080

//更新用户信息
#define USER_INFO_UPDATE_SUCCESS 1090

//黑名单提醒
#define BLACK_LIST 1400

#define JOIN 1200
#define NOT_JOIN 1201

#define GET_JOIN_LIST 1300
#define GET_COMMENT_LIST 1301


#define USER_EXIST 1500

#define USER_NOT_EXIST 1501

#define CERTIFICATE_CODE_MATCH 1043

#define CERTIFICATE_CODE_NOT_MATCH 1044


#define COMMENT_GOOD_EXIST 1601

#define TIMEMSG 1
#define USERMSG 0
#define LOADINGMSG 2
#define NOTIFYMSG 3
#define IMAGEMSG 4
#define VOICEMSG 5
#define VIDEOMSG 6


#define SENDED_SUCCESS 1
#define SENDED_FAILED 2
#define SENDING 3

#define STOCK_NOT_EXIST 1801
#define LOOK_STOCK_EXIST 1901
#define LOOK_STOCK_COUNT_OVER 1902
#define LOOK_DEL_NOT_TODAY 1903


#endif /* returnCode_h */
